#PV smoothing

#GRID STATUS CODES:
# 0- Invalid
# 1- On Grid
# 2- Off Grid
# 3- Island
# 4- Resynch
# 5- Black Start

###################################################################################################
######################  Imports and organize data #############################################
import time
from pyomo.environ import * #recommended to import pyomo.environ rather than pyomo.core in pyomo 4.x.
from pyomo.opt import SolverFactory, SolverStatus, TerminationCondition, SolverManagerFactory
import os
import getpass
from pyutilib.services import TempfileManager
import pandas as pd
import csv
import numpy as np
import sys
from scipy import interpolate

start_time = time.time() #gonna time how long it takes to run up to optimization complete.
u=getpass.getuser()
sys.stdout = open('C:\\Users\\' + u + '\\Documents\\LabVIEW Data\python_log.txt','w') #LabVIEW Data Directory
TempfileManager.tempdir = 'C:\\Users\\' + u + '\\AppData\\Local\\Temp'

TARGET_SOC = 50.


def optimize(ES_BUS_ID,ES_VF_Controller,ES_Measurement_SOC, ES_Power_Rating,ES_Energy_Rating,ES_PowerFactor,
          ES_ChargeEffic,ES_DischargeEffic,ES_min_SOC,ES_max_SOC,GEN_BUS_ID,GEN_VF_Controller,GEN_Min_Power,GEN_Power_Rating,
          GEN_MaxPF_Lead,GEN_MaxPF_Lag,GEN_Marginal_Cost,GEN_Marginal_Power,GEN_Start_Cost,LOAD_BUS_ID,ForecastDataLongLoadP,
          ForecastDataLongLoadQ,PV_BUS_ID,PV_PowerRating_kVA,ForecastDataLongPV,RealTimePrice,Forecast_dt,Bus_Number,Bus_Voltage_Min,
            Bus_Voltage_Max,Bus_Voltage_Measured,Bus_Voltage_Nominal,From_Bus,To_Bus,Network_resistance,Network_reactance,Power_Flow_Limit,
            Linear_PieceWise_PowerFLow,Reactive_Flow_Limit,Linear_PieceWise_ReactiveFLow,PCC_min,PCC_max,QCC_min,QCC_max,Optimization_Type,Grid_State): 
    #Optimization_Type
    
    #the following try loop will end after optimization complete, and before data formatting to return back
    try:
        GridFlag=Grid_State
        printing= True #prints way more than the minimum if you want to see data and return values
        
        if GridFlag==0: print 'SOMETHING IS WRONG: Grid Status is INVALID'
        if printing: print 'Running PV Smoothing'    
        
        #convert into numpy arrays
        ES_ChargeEffic=np.asarray(ES_ChargeEffic) #converting efficiency from decimal to percent
        ES_DischargeEffic=np.asarray(ES_DischargeEffic)        
        ES_ChargeEffic/=100. #converting efficiency from decimal to percent
        ES_DischargeEffic/=100.
        
        
        bat_df=pd.DataFrame({'Bus': ES_BUS_ID,'Pmax': ES_Power_Rating,
                            'Emax': ES_Energy_Rating ,'ESpf':ES_PowerFactor,
                            'minSOC':ES_min_SOC ,'maxSOC':ES_max_SOC,'chEff':ES_ChargeEffic ,
                            'dchEff':ES_DischargeEffic ,'stSOC':ES_Measurement_SOC,'endSOC':None,'ESvf':ES_VF_Controller})

        PV_df=pd.DataFrame({'Bus':PV_BUS_ID, 'cap':PV_PowerRating_kVA}) #PV parameters
      
     
        ForecastDataLongPV_T= np.transpose(ForecastDataLongPV) #Transpose the 2D array to make columns in df
        PVforecast_df=pd.DataFrame(ForecastDataLongPV_T)
        PVforecast_df.rename(columns={0:'power'},inplace=True) #kW/m^2 #NOT IRRADIANCE

        print 'PV \n' ,PV_df
        print 'Batteries\n', bat_df

        ########################## indices ##########################################
        timeperiods=set([i+1 for i in range(len(PVforecast_df))])    
        #timeperiods=set({1})
        #timeperiods=set([i+1 for i in range(20)])
 
        PV=set(PV_df.index)
        bats=set(bat_df.index)
        if printing: print 'Number of timeperiods:', len(timeperiods)

        GridState={}
        #separating by time period in case we want capability of having a different grid state each time period
        for t in timeperiods:
            GridState[t]= GridFlag
        if GridState[1]==1:
            print 'ONGRID at Current Time'
        if GridState[1]==2:
            print 'OFFGRID at Current Time'
        if GridState[1]==3:
            print 'ISLAND at Current Time'
        if GridState[1]==4:
            print 'RESYNCH at Current Time'    
       
        
        del_t=Forecast_dt

        # Current Energy
        currentEnergy = ES_Measurement_SOC[0] *  ES_Energy_Rating[0] / 100.      
        # Goal Energy
        goalEnergy = TARGET_SOC * ES_Energy_Rating[0] / 100.
        
        ###################################### DO THE SMOOTH ########
        
        #do we have PV power? (10 for noise)
        #extrapolate
        x = np.arange(1,3) #currently interp1d can only extrapolate with 2 points. 
        y = []
        for i in range(len(x)):
            try:
                y.append(PVforecast_df['power'][i+1])
            except Exception as e:
                y.append(0)
        f = interpolate.interp1d(x, y, fill_value = 'extrapolate')
        #then set our setpoint based on the extrapolation, with a min of 0 power
        smoothing_goal = max(f(0),0) - PVforecast_df['power'][0] 
        
        if PVforecast_df['power'][0] > 10:
            if ES_Measurement_SOC[0] < ES_max_SOC[0] and ES_Measurement_SOC[0] > ES_min_SOC[0]:
                ES_setpoint = smoothing_goal
            elif ES_Measurement_SOC[0] >= ES_max_SOC[0] and smoothing_goal > 0:
                ES_setpoint = smoothing_goal
            elif ES_Measurement_SOC[0] <= ES_min_SOC[0] and smoothing_goal < 0:
                ES_setpoint = smoothing_goal
            else:
                ES_setpoint = 0
        else:
            #we need to trend battery towards 50% SOC
            #first, find how many consecutive time periods are small
            numberOfZeros = 1
            for i in range(len(PVforecast_df.index)-1):
               #skip the first one because that's our measured value
                if PVforecast_df['power'][i+1] == 0:
                    numberOfZeros += 1
                else:
                    print 'Break at time', i
                    break
            
            if numberOfZeros < 4:
                #too short to try to get to 50%
                ES_setpoint = 0
            else:
                numberOfZeros = numberOfZeros - 3
                fractionalhour = del_t * numberOfZeros
                if ES_Measurement_SOC[0] < 48 :
                    #charge
                    ES_setpoint = (currentEnergy - goalEnergy) / ES_ChargeEffic[0] / fractionalhour
                   
                elif ES_Measurement_SOC[0] > 52:
                    #discharge (note efficiency is * because it's really 1/deff
                    print 'Discharge'
                    ES_setpoint = (currentEnergy - goalEnergy) * ES_DischargeEffic[0] / fractionalhour

                else:
                    ES_setpoint = 0
                    
            #print ES_Measurement_SOC
        
        
        #Now after everything, we better check our Pmax
        if ES_setpoint > ES_Power_Rating[0]:
            ES_setpoint = ES_Power_Rating[0]
        
        if ES_setpoint <  -ES_Power_Rating[0]:
            ES_setpoint = -ES_Power_Rating[0]
        
        Status = 'optimal'
        
        #calculate new SOC for the next time period so we can send it back
        if ES_setpoint < 0:
            newSOC = ES_Measurement_SOC[0] - ES_setpoint * ES_ChargeEffic[0] * del_t / ES_Energy_Rating[0] * 100
        elif ES_setpoint > 0:
            newSOC = ES_Measurement_SOC[0] - ES_setpoint * (1 / ES_DischargeEffic[0]) * del_t / ES_Energy_Rating[0] * 100
        else :
            newSOC = ES_Measurement_SOC[0]
        print 'New SOC', newSOC

    except KeyError as e: 
        print 'UNEXPECTED KeyError', e
        Status='FAIL'
    except IndexError as e: 
        print 'UNEXPECTED IndexError', e
        Status='FAIL'
    except ValueError as e: 
        print 'UNEXPECTED ValueError'
        print e
        Status='FAIL'

    ########### Get everything in correct format to return results ################
    negated_net_battery_hold = []
    reactive_hold = []
    SOC_hold=[]
    batQ_Arr = []
    generatorpower_hold = []
    generatorreactive_hold = []
    PV_hold = []
    PCC_hold = []
    QCC_hold = []
    voltage_hold = []
    
    #if optimal, populate the arrays we just created. Else, we will send empty ones
    try:
        for b in bats:
            batPT_Arr = []
            for t in timeperiods:
                if t == 1:
                    batPT_Arr.append(ES_setpoint)
                else:
                    batPT_Arr.append(0)
            negated_net_battery_hold.append(batPT_Arr)
        if printing: 
            try: 
                print('negated_net_battery_hold ES 0',negated_net_battery_hold[0][0])
                print('negated_net_battery_hold ES 1',negated_net_battery_hold[1][0])
            except: IndexError

        for b in bats:
            batSOC_Arr=[]
            for t in timeperiods:
                if t == 1:
                    batSOC_Arr.append(ES_Measurement_SOC[0])
                elif t == 2:
                    batSOC_Arr.append(newSOC)
                else:
                    batSOC_Arr.append(0) #convert energy back to SOC
            #print 'Q array', batQ_Arr
            SOC_hold.append(batSOC_Arr)
        if printing: 
            try: 
                print('SOC_hold battery ES 0',SOC_hold[0][0])
                print('SOC_hold battery ES 1',SOC_hold[1][0])
            except: IndexError
        
        for b in bats:
            batQ_Arr=[]
            for t in timeperiods:
                batQ_Arr.append(0)
            #print 'Q array', batQ_Arr
            reactive_hold.append(batQ_Arr)
        if printing: 
            try: 
                print('reactive_hold battery ES 0',reactive_hold[0][0])
                print('reactive_hold battery ES 1',reactive_hold[1][0])
            except: IndexError
        
        for b in range(1):
            dgP_Arr = []
            for t in timeperiods:
                dgP_Arr.append(0)
            generatorpower_hold.append(dgP_Arr)
        if printing:
            try: print('generatorpower_hold',generatorpower_hold[0][0])
            except: IndexError
        
        
        for b in range(1):
            dgQ_Arr = []
            for t in timeperiods:
                dgQ_Arr.append(0)
            generatorreactive_hold.append(dgQ_Arr)
        if printing: 
            try: print('generatorreactive_hold',generatorreactive_hold[0][0])
            except: IndexError

        for p in PV:
            PV_Arr = []
            for t in timeperiods:
                if GridState[t]==1:
                    PV_Arr.append(PV_df.cap[p])
                else:
                    PV_Arr.append(0)
            PV_hold.append(PV_Arr)
        if printing: 
            try: print('PV_hold',PV_hold[0][0])
            except: IndexError

        for b in range(1):
            Pbusgen_Arr = []
            for t in timeperiods:
                Pbusgen_Arr.append(0)
            PCC_hold.append(Pbusgen_Arr)
        if printing:
            try: print('PCC_hold',PCC_hold[0][0])
            except: IndexError
            
        for i in range(1):
            Qbusgen_Arr = []
            for t in timeperiods:
                Qbusgen_Arr.append(0)
            QCC_hold.append(Qbusgen_Arr)
        if printing:
            try: print('QCC_hold',QCC_hold[0][0])
            except: IndexError

        for b in range(1):
            voltage_Arr = []
            for t in timeperiods:
                if GridState[t]==4: #resynch needs to send PCC voltage
                    voltage_Arr.append(Bus_Voltage_Measured[0])
                else:
                    voltage_Arr.append(0)
            voltage_hold.append(voltage_Arr)
        if printing:
            try: print('voltage_hold',voltage_hold[0][0])
            except: IndexError
    except Exception as e:
        print(e)
        
    try:       
        if Status != 'optimal':
           QCC_hold.append(0) #if optimization failed or infeasible, just set these so we can send back a fail result.
           PCC_hold.append(0)       

        print 'Returning PV Smoothing Results'
        sys.stdout.flush()
        time.sleep(0)

        return (negated_net_battery_hold, reactive_hold, generatorpower_hold, generatorreactive_hold, PV_hold,
        PCC_hold[0], QCC_hold[0], ES_VF_Controller, GEN_VF_Controller, voltage_hold, SOC_hold, Status)
    except Exception as e:
        print(e)
        sys.stdout.flush()
        return ()