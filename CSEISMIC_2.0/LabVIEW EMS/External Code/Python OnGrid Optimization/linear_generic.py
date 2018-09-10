#Generic Microgrid Model Updated: 07/26/18 by amelia
#Amelia Mcilvenna
#PYTHON 2 (FOR CSEISMIC) /Balanced
#To run, pyomo and a LINEAR solver must be installed
# This version has binary variables
#model has batteries, pv, diesel generators, specified PCC, code (should) aggregate load of houses at each bus.
#added battery penalization for Maxsoc< or <minSOC

#GRID STATUS CODES:
# 0- Invalid
# 1- On Grid
# 2- Off Grid
# 3- Island
# 4- Resynch
# 5- Black Start
# 6- Networked

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

start_time = time.time() #gonna time how long it takes to run up to optimization complete.
u=getpass.getuser()
sys.stdout = open('C:\\Users\\' + u + '\\Documents\\LabVIEW Data\python_log.txt','w') #LabVIEW Data Directory
TempfileManager.tempdir = 'C:\\Users\\' + u + '\\AppData\\Local\\Temp'

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
        printing= True
        
        if GridFlag==0: print 'SOMETHING IS WRONG: Grid Status is INVALID'
        
        if printing: print 'Running GENERIC Balanced Optimization : Reading in Data'    

        #convert into numpy arrays
        ES_ChargeEffic=np.asarray(ES_ChargeEffic) #converting efficiency from decimal to percent
        ES_DischargeEffic=np.asarray(ES_DischargeEffic)
        ES_ChargeEffic/=100. #converting efficiency from decimal to percent
        ES_DischargeEffic/=100.
        
        bat_df=pd.DataFrame({'Bus': ES_BUS_ID,'Pmax': ES_Power_Rating,
                            'Emax': ES_Energy_Rating ,'ESpf':ES_PowerFactor,
                            'minSOC':ES_min_SOC ,'maxSOC':ES_max_SOC,'chEff':ES_ChargeEffic ,
                            'dchEff':ES_DischargeEffic ,'stSOC':ES_Measurement_SOC,'endSOC':None,'ESvf':ES_VF_Controller})

                            
        # # $/kw
        price_df=pd.DataFrame({'cost':RealTimePrice}) #cost to buy/sell from macrogrid
        
        #OnePower_Flow_Limit=[Power_Flow_Limit[0,0]] ##############FIX THIS LATERRRR ###just getting cap on line 
        CAP=[]
        for i in range(len(From_Bus)):
            CAP.append(10000) #HACK TO MAKE THIS WORK SINCE SENDING THREE VALUES PER LINE RIGHT NOW.... NEED TO CHANGE TO ACTUAL LINE CAPACITY LATER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        lines_df=pd.DataFrame({'From':From_Bus,'To':To_Bus,'cap':CAP,'r':Network_resistance,'x':Network_reactance})

        ForecastDataLongLoadP_T = zip(*ForecastDataLongLoadP) #Transpose the 2D array to make columns in df
        #print(ForecastDataLongLoadP_T)
        PLoad_df=pd.DataFrame(ForecastDataLongLoadP_T)

        ForecastDataLongLoadQ_T = zip(*ForecastDataLongLoadQ) #Transpose the 2D array to make columns in df
        QLoad_df=pd.DataFrame(ForecastDataLongLoadQ_T)

        PV_df=pd.DataFrame({'Bus':PV_BUS_ID, 'cap':PV_PowerRating_kVA}) #PV parameters
       
        # NEED TO HANDLE THESE: mc1','mc2','mc3','nlc','e1','e2'] #it's probably good now 9/18/17.
        DG_df=pd.DataFrame({'Bus':GEN_BUS_ID, 'minP':GEN_Min_Power,'cap':GEN_Power_Rating,
                          'pf':GEN_MaxPF_Lead,'SUC':GEN_Start_Cost})#GEN_Marginal_Cost,GEN_Marginal_Power)
        labels=['mc1','mc2','mc3']
        #print 'marginal cost array' ,GEN_Marginal_Cost  
        #print 'size', GEN_Marginal_Cost.size
        if  len(GEN_Marginal_Cost)==0: #if this 2D array has nothing in the first element, ie. empty
            MargC_df=pd.DataFrame(columns=labels)
        else:
            MargC_df=pd.DataFrame(GEN_Marginal_Cost,columns=labels)
            
        labels=['minP?','e1','e2']
        if len(GEN_Marginal_Power)==0: #if this 2D array is empty
            MargP_df=pd.DataFrame(columns=labels)
        else:
            MargP_df=pd.DataFrame(GEN_Marginal_Power,columns=labels)
        DG_df=pd.concat([DG_df,MargC_df,MargP_df],axis=1)
     
        ForecastDataLongPV_T= np.transpose(ForecastDataLongPV) #Transpose the 2D array to make columns in df
        PVforecast_df=pd.DataFrame(ForecastDataLongPV_T)
        PVforecast_df.rename(columns={0:'power'},inplace=True) #kW/m^2 #NOT IRRADIANCE
        
        #check if num lines =num buses-1 (b/c radial network)
        if len(lines_df.index) != len(Bus_Number)-1:
            print 'WARNING: Buses and lines do not match'

        try: print 'price $/kw', price_df.loc[1,'cost']
        except KeyError: 
            print 'UNEXPECTED KeyError, check Grid Price'

        print 'DG \n',DG_df
        print 'PV \n' ,PV_df
        print 'batteries\n', bat_df
        print 'Network \n', lines_df
        print 'Load id', LOAD_BUS_ID
        print 'Battery id', ES_BUS_ID
        print 'Buses', Bus_Number
        print 'Base voltage', Bus_Voltage_Nominal
        print 'Load at time 0:', PLoad_df[0][0] #using df[0][t-1]
        print 'Measured Voltage', Bus_Voltage_Measured
        print 'Voltage min bounds',Bus_Voltage_Min
        print 'Voltage max bounds',Bus_Voltage_Max

            #print 'P load', PLoad_df
            #print 'price', price_df
            #print 'PV forecast', PVforecast_df

        ######################################################################################################
        #########################Set all of the indices and parameters for model. ##############################

        ########################## indices ##########################################
        timeperiods=set([i+1 for i in range(len(price_df))])    
        #timeperiods=set({1})
        #timeperiods=set([i+1 for i in range(10)])
        times=set([i+1 for i in range(len(price_df))])  
        lines=set(lines_df.index)
        PV=set(PV_df.index)
        buses=set(Bus_Number)
        PCC=set({0.})
        diesels=set(DG_df.index)
        bats=set(bat_df.index)
        #print(housenumber)
        # print(lines)
        if printing: print 'Number of timeperiods:', len(timeperiods)
        
        GridState={}
        #separating by time period in case we want capability of having a different grid state each time period
        for t in timeperiods:
            GridState[t]=GridFlag
        if GridState[1]==1:
            print 'ONGRID at Current Time'
        if GridState[1]==2:
            print 'OFFGRID at Current Time'
        if GridState[1]==3:
            print 'ISLAND at Current Time'
        if GridState[1]==4:
            print 'RESYNC at Current Time'
        if GridState[1]==5:
            print 'BLACKSTART at Current Time'
        if GridState[1]==6:
            print 'NETWORK at Current Time'
        
        #NOTE: Base power is MW (or just scaled by 1000) to decrease matrix range in optimization to decrease numerical instability. 
        #if changing to other base, use caution!!
        Sbase=1000. #change kVA to MVA. Make sure is float
        Vbase=Bus_Voltage_Nominal[0]
        Zbase= Vbase**2/(1000.*Sbase)#convert base power to 1Mw 
        #print 'zbase',Zbase

        
        #just to make existing code work better...
        # PLoad_df['Time']=times
        # QLoad_df['Time']=times
        
        ######################### set parameters ####################################
        m_cb=.0001*Sbase #marg. battery cost
        #print 'Bus_Voltage_Min' ,Bus_Voltage_Min
        v_min={}
        v_max={}
        #print 'Bus_Voltage_Min' ,Bus_Voltage_Min
        for b in buses:
            v_min[b]=Bus_Voltage_Min[int(b)]**2
            v_max[b]=Bus_Voltage_Max[int(b)]**2
        vth_min=.98**2 #for voltage deviation
        vth_max=1.02**2
        del_t=Forecast_dt
        #del_t=48./len(timeperiods)
        no_of_intervals=30 #number of intervals for piecewise linearization
        piecewise_intervals = range(no_of_intervals)

        ######adjust for bases####
        DG_df.cap=DG_df.cap / Sbase #smax
        DG_df.minP=DG_df.minP/Sbase
        DG_df.e1=DG_df.e1 / Sbase
        DG_df.e2=DG_df.e2 / Sbase
        DG_df.mc1=DG_df.mc1 * Sbase
        DG_df.mc2=DG_df.mc2 * Sbase
        DG_df.mc3=DG_df.mc3 * Sbase
        price_df.cost=price_df.cost*Sbase 
        bat_df.Emax=bat_df.Emax / Sbase
        bat_df.Pmax=bat_df.Pmax / Sbase
        lines_df.cap=lines_df.cap / Sbase
        PLoad_df=PLoad_df / Sbase 
        QLoad_df=QLoad_df / Sbase

        lines_df.r=lines_df.r / Zbase
        lines_df.x=lines_df.x / Zbase

        #################### Indicators for obj #################  #DO we want to pass these in eventually? or read in?
        #note these weights should sum to 1
        Cost_Indicator = .3
        PF_Indicator = .1
        Loss_Indicator = .5
        Voltage_Indicator = .1 #future capability, if you want to penalize this, check vth_max and min
        
        #############################Will create curtail limits here if off grid or islanding######################
        #these are generic based solely on load level. If needing specific stability constraints, adjust/add here.
        curtail={}
         
        for t in timeperiods:
            if GridState[t] == 2 or GridState[t] == 3 or GridState[t] == 6: #offgrid or island
                curtail[t] = .5*PLoad_df.loc[t-1,0] #just keep PV under 50% of load
         

        ###### Getting MAX allowable generation at each bus (sum of all generators at that bus)
        busMax={}
        busMin={}
        bat_number={} #gets battery index for corresponding bus. Used in Network constraints for total generation at a bus.
        PV_number={} #gets PV index for bus
        DG_number={} #gets DG index for bus
        for i in buses:
            busMax[i]=0
            busMin[i]=0 #just generation
            if i in list(bat_df.Bus):
                #emax*maxSOC (.01 b/c percent to decimal)
                bat_number[i]=bat_df.loc[bat_df['Bus']==i].index.tolist() #gets battery index at corresponding bus
                busMax[i]+=bat_df.loc[bat_df['Bus']==i,'Emax'].iloc[0]*.01*bat_df.loc[bat_df['Bus']==i,'maxSOC'].sum()
                busMin[i]+=-busMax[i] #if there is a battery, it can discharge its capacity.
            if i in list(PV_df.Bus):
                #print (i,'yes')
                PV_number[i]=PV_df.loc[PV_df['Bus']==i].index.tolist()
                busMax[i]+=PV_df.loc[PV_df['Bus']==i,'cap'].sum()/Sbase #scale PV here, and at power generation.
            if i in list(DG_df.Bus):
                DG_number[i]=DG_df.loc[DG_df['Bus']==i].index.tolist()
                busMax[i]+=DG_df.loc[DG_df['Bus']==i,'cap'].sum()
            if i in PCC:
                for t in timeperiods:
                    if GridState[t]==1 or GridState[t]==4 or GridState[t]==5 or GridState[t]==6:
                        busMax[i]=PCC_max[0]/Sbase #pcc limits are taken in at the function definition.
                        busMin[i]=PCC_min[0]/Sbase
                    elif GridState[t]==2 or GridState[t]==3:
                        busMax[i]=0 #pcc limits are 0 if off grid or island
                        busMin[i]=0
                    else: print 'Invalid grid state at time',t
                    
        #print ('busMin', busMin)
        #print('busMax' ,busMax)
        # print(bat_number)
        # print(PV_number)
        
        ##Summing all real and reactive power load at each bus (at each time period), which is given to us in the data
        Pbusload={}
        Qbusload={}
        for b in buses:
            for t in timeperiods:
                if b==LOAD_BUS_ID[0]: #if load is on that bus
                    Pbusload[b,t]=PLoad_df.loc[t-1,0]
                    Qbusload[b,t]=QLoad_df.loc[t-1,0]
                else:
                    Pbusload[b,t]=0 
                    Qbusload[b,t]=0

        #Get adjacency (buses in and out of each node, should be one in and multiple out due to radial network)
        LinesIn={}
        LinesOut={}
        for bus in buses:
            LinesIn[bus] = list(lines_df[ lines_df.To == bus ].index) #if TO==bus, get the arc going in! (arc, NOT bus).
            LinesOut[bus] = list(lines_df[ lines_df.From == bus].index)
            #print(bus,LinesIn[bus],LinesOut[bus]) #if you wanna check the network is represented correctly.

        ##Get start and end energy in the batteries
        Energy_init={}
        SOCend={}
        for b in bats:
            Energy_init[b]=bat_df.stSOC[b]*bat_df.Emax[b]/100. #changing SOC to %.
            #SOCend[b]=bat_df.endSOC[b]*bat_df.Emax[b]/100 #no end SOC in this model
        #print(Energy_init)

        # for b in buses:
        #     if b in list(DG_df.Bus):
        #         for i in range(len(DG_number[b])):
        #             print(b,i, DG_number[b][i])

        PV_power={}
        for pv in PV:
            for t in timeperiods: #Using t-1 below due to timeperiods indexed by 1, df indexed by 0.
                 PV_power[pv,t]=PVforecast_df.power[t-1]/Sbase 
                 if PV_power[pv,t]>PV_df.cap[pv]:
                    print 'WARNING: PV forecast exceeds capacity at time',t
        # #print(PV_power)


        #############################################################################
        ############################ LINEARIZATION TERMS (INTERVALS)##################

        ##add ACOPF linearization terms for each interval
        intervals = range(no_of_intervals)
        points = range(no_of_intervals + 1)

        ###GENERATORS -be careful, these have a min power if on!
        ##find lin_pt (power) and P2,Q2 (power squared) for each interval
        gen_lin_df=pd.DataFrame() #each generator (if multiple) is a row of df.
        for pnt in points:
            gen_lin_df['lin_pt%d'%pnt] = pnt*( DG_df.cap ) / no_of_intervals
            gen_lin_df['P2_pt%d'%pnt] = (gen_lin_df['lin_pt%d'%pnt])**2
            gen_lin_df['Q2_pt%d'%pnt] = (gen_lin_df['lin_pt%d'%pnt])**2

        ##get slopes
        for i in intervals:
            gen_lin_df['CP'+str(i)] = (gen_lin_df['P2_pt'+str(i+1)] - gen_lin_df['P2_pt'+str(i)]) / \
                                        (gen_lin_df['lin_pt'+str(i+1)] - gen_lin_df['lin_pt'+str(i)])
            gen_lin_df['CQ'+str(i)] = ( gen_lin_df['Q2_pt'+str(i+1)] - gen_lin_df['Q2_pt'+str(i)]) / \
                                        ( gen_lin_df['lin_pt'+str(i+1)] - gen_lin_df['lin_pt'+str(i)])
        #print(gen_lin_df)

        ##BATTERIES
        ##find lin_pt (power) and P2,Q2 (power squared) for each interval
        bat_lin_df=pd.DataFrame()
        for pnt in points:
            bat_lin_df['lin_pt%d'%pnt] = pnt*(bat_df.Emax*.01*bat_df.maxSOC) / no_of_intervals
            bat_lin_df['P2_pt%d'%pnt] = (bat_lin_df['lin_pt%d'%pnt])**2
            bat_lin_df['Q2_pt%d'%pnt] = (bat_lin_df['lin_pt%d'%pnt])**2

        ##get slopes
        for i in intervals:
            bat_lin_df['CP'+str(i)] = (bat_lin_df['P2_pt'+str(i+1)] - bat_lin_df['P2_pt'+str(i)]) / \
                                        (bat_lin_df['lin_pt'+str(i+1)] - bat_lin_df['lin_pt'+str(i)])
            bat_lin_df['CQ'+str(i)] = ( bat_lin_df['Q2_pt'+str(i+1)] - bat_lin_df['Q2_pt'+str(i)]) / \
                                        ( bat_lin_df['lin_pt'+str(i+1)] - bat_lin_df['lin_pt'+str(i)])
        #print(bat_lin_df)

        ##NETWORK
        ##find lin_pt (power) and P2,Q2 (power squared) for each interval
        network_lin_df=pd.DataFrame() #each line is a row of the df
        for pnt in points:
            network_lin_df['lin_pt%d'%pnt] = pnt*(lines_df.cap) / no_of_intervals
            network_lin_df['P2_pt%d'%pnt] = (network_lin_df['lin_pt%d'%pnt])**2
            network_lin_df['Q2_pt%d'%pnt] = (network_lin_df['lin_pt%d'%pnt])**2

        ##get slopes
        for i in intervals:
            network_lin_df['CP'+str(i)] = (network_lin_df['P2_pt'+str(i+1)] - network_lin_df['P2_pt'+str(i)]) / \
                                        (network_lin_df['lin_pt'+str(i+1)] - network_lin_df['lin_pt'+str(i)])
            network_lin_df['CQ'+str(i)] = ( network_lin_df['Q2_pt'+str(i+1)] - network_lin_df['Q2_pt'+str(i)]) / \
                                        ( network_lin_df['lin_pt'+str(i+1)] - network_lin_df['lin_pt'+str(i)])
        #print(network_lin_df)


        ################################################################################
        ############################  BUILD MODEL ####################################
        print 'Creating Model'
        model = ConcreteModel()

        #############################################################################
        ######################## VARIABLES ########################################33
        print 'creating variables'
        ############################Network Variables: #####################
        def Pbusgen_bounds(model, b, time):  # P is real power
            return (busMin[b], busMax[b])
        model.Pbusgen = Var(buses, timeperiods, within=Reals, bounds=Pbusgen_bounds)

        model.Qbusgen = Var(buses, timeperiods, within=Reals)  # bdd in constraints.

        model.P_PCCabs=Var(PCC,timeperiods,within=Reals) #abs val of PCC injection for bounding Q
        model.Q_PCCabs=Var(PCC,timeperiods,within=Reals)
        
        # voltage
        def voltage_bounds(model, b, time):
            return (v_min[b], v_max[b])
        model.voltage = Var(buses, timeperiods, within=Reals, bounds=voltage_bounds)

        # aux vbl for voltage deviation
        model.aux_v = Var(buses, timeperiods, within=Reals)


        # complex current (l=I^2)
        def current_bounds(model, line, time):
            return (0, lines_df.cap[line] ** 2) 
        model.current = Var(list(lines), timeperiods, within=Reals, bounds=current_bounds)


        # Real Power flows Pij
        def real_line_limit(model, line, time):  # lines are indexed 0,1,2,3.
            return (-lines_df.cap[line], lines_df.cap[line])
        model.realFlow = Var(list(lines), timeperiods, within=Reals, bounds=real_line_limit)


        # Reactive Power flows Qij
        def reactive_line_limit(model, line, time):
            return (-lines_df.cap[line], lines_df.cap[line])
        model.reactiveFlow = Var(list(lines), timeperiods, within=Reals, bounds=reactive_line_limit)

        ###################### DG Variables ########################################
        # total real/reactive power
        model.dgP = Var(list(diesels), timeperiods, within=Reals)
        model.dgQ = Var(list(diesels), timeperiods, within=Reals)  # bdd in constraints

        # 3 piecewise components to determine cost later
        def dg_1_limit(model, generator, time):
            return (0, DG_df.e1[generator] - DG_df.minP[generator])  # e1-pmin
        model.dg1 = Var(list(diesels), timeperiods, within=Reals, bounds=dg_1_limit)
        

        def dg_2_limit(model, generator, time):
            return (0, DG_df.e2[generator] - DG_df.e1[generator])  # e2-e1
        model.dg2 = Var(list(diesels), timeperiods, within=Reals, bounds=dg_2_limit)
        


        def dg_3_limit(model, generator, time):
            return (0, DG_df.cap[generator] - DG_df.e2[generator])  # pmax-e2
        model.dg3 = Var(list(diesels), timeperiods, within=Reals, bounds=dg_3_limit)


        def dg_SU_bounds(model, generator, time):
            return (0, 1)
        model.dg_SU = Var(list(diesels), timeperiods, within=Binary, bounds=dg_SU_bounds)  # Diesel generator start up indicator


        # on/off for each generator and time period.
        def dg_bin_bounds(model, generator, time):
            return (0, 1)
        model.u_it = Var(list(diesels), timeperiods, within=Binary, bounds=dg_bin_bounds)
        
        model.Q_Gabs=Var(list(diesels),timeperiods,within=Reals)

        #######################Battery Variables ################################
        def charge_bounds(model, generator, time):
            return (0, 1)
        model.u_btC = Var(list(bats), timeperiods, within=Binary, bounds=charge_bounds)  # charging and discharging indicators


        def discharge_bounds(model, generator, time):
            return (0, 1)
        model.u_btD = Var(list(bats), timeperiods, within=Binary, bounds=discharge_bounds)

        model.batPC = Var(bats, timeperiods, within=NonNegativeReals)  # want bdd below by zero, ub given in constraints
        model.batPD = Var(bats, timeperiods, within=NonNegativeReals)

        model.batQ = Var(bats, timeperiods, within=Reals)
        model.Q_Babs=Var(bats,timeperiods,within=Reals)

        model.batPT = Var(bats, timeperiods, within=Reals)  # total battery power (signed)

        #Extreme SOC penalty
        model.extremeSOC=Var(bats,timeperiods,within=NonNegativeReals)
        
        ###Energy in the battery
        def Energy_limit(model, bat, t):
            return (0,bat_df.Emax[bat]) 
        model.B_energy= Var(bats, timeperiods, within=Reals, bounds=Energy_limit)
        
        ######################### PV Variables #####################################
        #this vbl represents the PV we take (should be forecast if ongrid, or curtailed if off)
        def PV_limit(model,pv,t):
            return(0,PV_df.cap[pv]/Sbase)
        model.PV_take=Var(PV,timeperiods,within=NonNegativeReals,bounds=PV_limit) 
                        
        ################################################################################
        ############################ Constraints #######################################
        print 'Generating Constraints'
        #######################Network Constraints ####################################
        ##Load balance constraints
        def real_balance_rule(model, bus, t):
            return (Pbusload[bus, t] - model.Pbusgen[bus, t] == sum(model.realFlow[line, t]
                                      
                                      - model.current[line, t] * lines_df.r[line] for line in
                                                                    LinesIn[bus])
                    - sum(model.realFlow[line, t] for line in LinesOut[bus]))
        model.real_bal_constr = Constraint(buses, timeperiods, rule=real_balance_rule)


        def reactive_balance_rule(model, bus, t):
            return (Qbusload[bus, t] - model.Qbusgen[bus, t] == sum(model.reactiveFlow[line, t]
                                                                    - model.current[line, t] * lines_df.x[line] for line in
                                                                    LinesIn[bus])
                    - sum(model.reactiveFlow[line, t] for line in LinesOut[bus]))
        model.reactive_bal_constr = Constraint(buses, timeperiods, rule=reactive_balance_rule)


        # voltage and current
        def voltage_rule(model, line, t):  
            return (model.voltage[lines_df.To[line], t]
                    == model.voltage[lines_df.From[line], t]
                    - 2 * (lines_df.r[line] * model.realFlow[line, t] + lines_df.x[line] * model.reactiveFlow[line, t])
                    + (lines_df.r[line] ** 2 + lines_df.x[line] ** 2) * model.current[line, t])
        model.voltage_constr = Constraint(lines, timeperiods, rule=voltage_rule)


        # Linearization of P2 and Q2:
        # variables for piecewise power intervals  (s_real and s_react are the flow on lines.)
        def s_real_bounds(model, line, t, step):
            return (0, lines_df.cap[line] / no_of_intervals)
        model.s_real = Var(list(lines), timeperiods, piecewise_intervals, within=NonNegativeReals, bounds=s_real_bounds)
        def s_react_bounds(model, line, t, step):
            return (0, lines_df.cap[line] / no_of_intervals)
        model.s_react = Var(list(lines), timeperiods, piecewise_intervals, within=NonNegativeReals, bounds=s_react_bounds)


        # sum of piecewise equals total power. Q has pos/neg support, so s_react can be non-neg (due to symmetry of Q2)
        def s_real_pos_support_rule(model, line, t):
            return (sum(model.s_real[line, t, step] for step in piecewise_intervals) >= model.realFlow[line, t])
        model.s_real_pos_support_constr = Constraint(lines, timeperiods, rule=s_real_pos_support_rule)


        def s_real_neg_support_rule(model, line, t):
            return (sum(model.s_real[line, t, step] for step in piecewise_intervals) >= -model.realFlow[line, t])
        model.s_real_neg_support_constr = Constraint(lines, timeperiods, rule=s_real_neg_support_rule)


        def s_react_pos_support_rule(model, line, t):
            return sum(model.s_react[line, t, step] for step in piecewise_intervals) >= model.reactiveFlow[line, t]
        model.s_react_pos_support_constr = Constraint(lines, timeperiods, rule=s_react_pos_support_rule)


        def s_react_neg_support_rule(model, line, t):
            return sum(model.s_react[line, t, step] for step in piecewise_intervals) >= -model.reactiveFlow[line, t]
        model.s_react_neg_support_constr = Constraint(lines, timeperiods, rule=s_react_neg_support_rule)

        ##mccormick envelopes: (aux_lv is an auxilary variable for l*v), over and under estimators follow.
        model.aux_lv = Var(list(lines), timeperiods, within=NonNegativeReals)


        #McCormick underestimators (zeros are included as placeholders because lb of current (I^2) is 0)
        def under1_rule(model,line,t):
            return (model.aux_lv[line,t]>=0+model.current[line,t]*v_min[lines_df.From[line]]-0)
        model.under1_constr=Constraint(lines,timeperiods,rule=under1_rule)
           
        def under2_rule(model,line,t):
            return (model.aux_lv[line,t]>=model.voltage[lines_df.From[line],t]*lines_df.cap[line]**2
                                        +model.current[line,t]*v_max[lines_df.From[line]]-v_max[lines_df.From[line]]*lines_df.cap[line]**2)
        model.under2_constr=Constraint(lines,timeperiods,rule=under2_rule)

        #McCormick overestimators
        def over1_rule(model,line,t):
            return (model.aux_lv[line,t]<=model.voltage[lines_df.From[line],t]*lines_df.cap[line]**2
                                        +model.current[line,t]*v_min[lines_df.From[line]]-v_min[lines_df.From[line]]*lines_df.cap[line]**2)
        model.over1_constr=Constraint(lines,timeperiods,rule=over1_rule)

        def over2_rule(model,line,t):
            return (model.aux_lv[line,t]<=0+model.current[line,t]*v_max[lines_df.From[line]]-0)
        model.over2_constr=Constraint(lines,timeperiods,rule=over2_rule)

        #This is the SOC relaxation (constr 9 in li,chen,low relax paper.)
        # linearized current_relax_rule:
        def current_relax_rule(model, line, t):
            return (  ## first the sum of the ps intervals
                sum(network_lin_df['CP%d' % step][line] * model.s_real[line, t, step] for step in piecewise_intervals) \
                ## now the qs intervals
                + sum(network_lin_df['CQ%d' % step][line] * model.s_react[line, t, step] for step in piecewise_intervals) \
                ### strengthen this with u
                <= model.aux_lv[line, t])
        model.current_relax_constr = Constraint(lines, timeperiods, rule=current_relax_rule)


        ##next two are for penalization of voltage deviation via an auxilary variable.
        def volt_aux1_rule(model, b, t):
            return (model.aux_v[b, t] >= model.voltage[b, t] - vth_max)
        model.volt_aux1_constr = Constraint(buses, timeperiods, rule=volt_aux1_rule)


        def volt_aux2_rule(model, b, t):
            return (model.aux_v[b, t] >= vth_min - model.voltage[b, t])
        model.volt_aux2_constr = Constraint(buses, timeperiods, rule=volt_aux2_rule)


        # total generation at each bus equals sum of its parts (for P and Q)
        # ie. model.Pbusgen[bus,t]= PV+battery+load shed+ diesels at bus
        def Pbus_gen_rule(model, b, t):  # printing out constraints, this is doing what I want.
            total = 0.
            if b in list(bat_df.Bus):
                for i in range(len(bat_number[b])):
                    total += model.batPT[bat_number[b][i], t]  # the 0 is to get the index value.

            if b in list(PV_df.Bus):
                #total += PV_power[b, t]  # the 0 is to get the index value.
                for i in range(len(PV_number[b])):
                        total+=model.PV_take[PV_number[b][i],t]

            if b in list(DG_df.Bus):
                for i in range(len(DG_number[b])):
                    total += model.dgP[DG_number[b][i], t]  # the 0 is to get the index value.

            if b in list(bat_df.Bus) or b in list(DG_df.Bus) or b in list(PV_df.Bus):
                return (model.Pbusgen[b, t] == total)  # if generation at that bus, return total
            else:
                return (Constraint.Skip)  # if there is no generation at that bus, skip.      
        model.Pbus_gen_constr = Constraint(buses, timeperiods, rule=Pbus_gen_rule)


        def Qbus_gen_rule(model, b, t):
            total = 0.
            if b in list(bat_df.Bus):
                for i in range(len(bat_number[b])):
                    total += model.batQ[bat_number[b][i], t]
            if b in list(PV_df.Bus):
                total += 0  #No PV reactive power

            if b in list(DG_df.Bus):
                for i in range(len(DG_number[b])):
                    total += model.dgQ[DG_number[b][i], t]

            if b in list(bat_df.Bus) or b in list(DG_df.Bus) or b in list(PV_df.Bus):
                return (model.Qbusgen[b, t] == total)  # if generation at that bus, return total
            else:
                return (Constraint.Skip)  # if there is no generation at that bus, skip.
        model.Qbus_gen_constr = Constraint(buses, timeperiods, rule=Qbus_gen_rule)

        ## OBJ for network
        Loss=sum(del_t*model.current[line,t]*lines_df.r[line] for line in lines for t in timeperiods)
        Volt_vio=sum(model.aux_v[b,t] for b in buses for t in timeperiods)

        ################################## DG Constraints ###################################
        # Total Power is sum of parts
        def total_dg_rule(model, gen, t):
            return (
            model.dgP[gen, t] == model.dg1[gen, t] + model.dg2[gen, t] + model.dg3[gen, t] + model.u_it[gen, t] * DG_df.minP[
                gen])
        model.total_dg_constr = Constraint(diesels, timeperiods, rule=total_dg_rule)


        # if gen is off, produces 0
        def dg_gen_rule(model, gen, t):
            return (model.dgP[gen, t] <= DG_df.cap[gen] * model.u_it[gen, t])
        model.dg_gen_constr = Constraint(diesels, timeperiods, rule=dg_gen_rule)

        def dg_offgrid_rule(model, gen, t):
            if GridState[t]==2 or GridState[t]==3 or GridState[t]==4:
                return (model.u_it[gen,t]==1) #If island or off grid or resynch, gen must be ON
            else: return(Constraint.Skip)
        model.dg_offgrid_constr = Constraint(diesels, timeperiods, rule=dg_offgrid_rule)

        # bound reactive power
        def dg_reactL_rule(model, gen, t):
            return (-np.tan(np.arccos(DG_df.pf[gen])) * model.dgP[gen, t] <= model.dgQ[gen, t])
        model.dg_reactL_constr = Constraint(diesels, timeperiods, rule=dg_reactL_rule)


        def dg_reactU_rule(model, gen, t):
            return (model.dgQ[gen, t] <= np.tan(np.arccos(DG_df.pf[gen])) * model.dgP[gen, t])
        model.dg_reactU_constr = Constraint(diesels, timeperiods, rule=dg_reactU_rule)

        # Linearization of power triangle constraint:
        # variables for piecewise power intervals
        def s_dgP_bounds(model, g, time, step):
            return (0, DG_df.cap[g] / no_of_intervals) 
        model.s_dgP = Var(list(diesels), timeperiods, piecewise_intervals, within=NonNegativeReals, bounds=s_dgP_bounds)
        
        def s_dgQ_bounds(model, g, time, step):
            return (0, DG_df.cap[g] / no_of_intervals) 
        model.s_dgQ = Var(list(diesels), timeperiods, piecewise_intervals, within=NonNegativeReals, bounds=s_dgQ_bounds)

        # sum of piecewise equals total power. Q has pos/neg support, so s_dgQ can be non-neg (due to symmetry of Q2)
        def sum_s_dgP_rule(model, gen, t):
            return (sum(model.s_dgP[gen, t, step] for step in piecewise_intervals) == model.dgP[gen, t])
        model.sum_s_dgP_constr = Constraint(diesels, timeperiods, rule=sum_s_dgP_rule)


        def s_dgQ_pos_support_rule(model, gen, t):
            return sum(model.s_dgQ[gen, t, step] for step in piecewise_intervals) >= model.dgQ[gen, t]
        model.s_dgQ_pos_support_constr = Constraint(diesels, timeperiods, rule=s_dgQ_pos_support_rule)


        def s_dgQ_neg_support_rule(model, gen, t):
            return sum(model.s_dgQ[gen, t, step] for step in piecewise_intervals) >= -model.dgQ[gen, t]
        model.s_dgQ_neg_support_constr = Constraint(diesels, timeperiods, rule=s_dgQ_neg_support_rule)


        # power triangle (linearized)
        def dg_triangle_rule(model, gen, t):
            return (  ## first the sum of the ps intervals
                sum(gen_lin_df['CP%d' % step][gen] * model.s_dgP[gen, t, step] for step in piecewise_intervals) \
                ## now the qs intervals
                + sum(gen_lin_df['CQ%d' % step][gen] * model.s_dgQ[gen, t, step] for step in piecewise_intervals) \
                ### strengthen this with u
                <= (DG_df.cap[gen] ** 2) * model.u_it[gen, t])
        model.dg_triangle_constr = Constraint(diesels, timeperiods, rule=dg_triangle_rule)


        #start up indicator
        def dg_startup_rule(model, gen, t):
            if t != 1:
                return (model.dg_SU[gen, t] >= model.u_it[gen, t] - model.u_it[gen, t - 1])  # only 1 if 1-0, ie. starts up.
            else:
                return (Constraint.Skip)
        model.dg_startup_constr = Constraint(diesels, timeperiods, rule=dg_startup_rule)
        
        #gonna use to penalize abs Q in obj
        def Qabs_G1_rule(model,gen,t):
            return(model.Q_Gabs[gen,t]>=model.dgQ[gen, t])
        model.Qabs_G1_constr=Constraint(diesels,timeperiods,rule=Qabs_G1_rule)

        def Qabs_G2_rule(model,gen,t):
            return(model.Q_Gabs[gen,t]>=-model.dgQ[gen, t])
        model.Qabs_G2_constr=Constraint(diesels,timeperiods,rule=Qabs_G2_rule)

        # OBJ dg cost expression
        dgcost = sum(del_t*DG_df.mc1[g] * model.dg1[g, t] for g in diesels for t in timeperiods) \
                  + sum(del_t*DG_df.mc2[g] * model.dg2[g, t] for g in diesels for t in timeperiods) \
                  + sum(del_t*DG_df.mc3[g] * model.dg3[g, t] for g in diesels for t in timeperiods) \
                  + sum(del_t*(DG_df.mc1[g]*100+10) * model.u_it[g, t] for g in diesels for t in timeperiods)\
                  +sum(del_t*DG_df.SUC[g] * model.dg_SU[g, t] for g in diesels for t in timeperiods)\
                  +sum(del_t*model.Q_Gabs[g,t] for g in diesels for t in timeperiods)
                  #DG_df.nlc[g] :hard coded this value in for now CHANGE LATER!!!


        ##################################### Battery Constraints #####################################
        def bat_Cpower_rule(model,bat,t):
            return(model.batPC[bat,t]<=bat_df.Pmax[bat]*model.u_btC[bat,t])                               #double checked, OK
        model.bat_Cpower_constr=Constraint(bats,timeperiods,rule=bat_Cpower_rule)

        def bat_Dpower_rule(model,bat,t):
            return(model.batPD[bat,t]<=bat_df.Pmax[bat]*model.u_btD[bat,t])
        model.bat_Dpower_constr=Constraint(bats,timeperiods,rule=bat_Dpower_rule)

        def upDown_rule(model,bat,t):
            return (model.u_btC[bat,t]+model.u_btD[bat,t]<=1)
        model.upDown_constr=Constraint(bats,timeperiods,rule=upDown_rule)

            ##Battery energy balance
        def B_energy_rule(model,bat,t):
            if t==1:
                return(model.B_energy[bat,t]==Energy_init[bat]+bat_df.chEff[bat]*model.batPC[bat,t]*del_t
                                        -1./bat_df.dchEff[bat]*model.batPD[bat,t]*del_t)
            else:
                return(model.B_energy[bat,t]==model.B_energy[bat,t-1]+bat_df.chEff[bat]*model.batPC[bat,t]*del_t
                                        -1./bat_df.dchEff[bat]*model.batPD[bat,t]*del_t)      
        model.B_energy_constr=Constraint(bats,timeperiods,rule=B_energy_rule) #also look at final_energy_rule from ben's

        # #make sure end SOC is correct.             <<<<<<<<<<<<<<<<<<<<<<<<<<< No end SOC for this model
        # def SOC_end_rule(model,bat):
            # return (model.B_energy[bat,list(timeperiods)[-1]]>=SOCend[bat])
        # model.SOC_end_constr=Constraint(bats,rule=SOC_end_rule)
        
        #Keep track of Extreme SOC
        def energy_min_rule(model,bat,t):
            return(model.extremeSOC[bat,t]>=bat_df.minSOC[bat] * bat_df.Emax[bat] / 100.-model.B_energy[bat,t])
        model.energy_min_constr=Constraint(bats,timeperiods,rule=energy_min_rule)

        def energy_max_rule(model,bat,t):
            return(model.extremeSOC[bat,t]>=model.B_energy[bat,t]-bat_df.maxSOC[bat] * bat_df.Emax[bat] / 100.)
        model.energy_max_constr=Constraint(bats,timeperiods,rule=energy_max_rule)
        
        #total bat power
        def bat_power_rule(model,b,t):
            return(model.batPD[b,t]-model.batPC[b,t]==model.batPT[b,t])
        model.bat_power_constr=Constraint(bats,timeperiods,rule=bat_power_rule)

        # battery triangle
        # def bat_triangle_rule(model,b,t):
        #     return(model.batPT[b,t]**2+model.batQ[b,t]**2<=bat_df.Pmax[b]**2) #p^2+q^2<=s^2
        # model.bat_triangle_constr=Constraint(bats,timeperiods,rule=bat_triangle_rule)

        # Linearization of power triangle constraint:
        # variables for piecewise power intervals
        def s_bP_bounds(model, b, time, step):
            return (0, bat_df.Pmax[b]/bat_df.ESpf[b] / no_of_intervals)
        model.s_bP = Var(list(bats), timeperiods, piecewise_intervals, within=NonNegativeReals, bounds=s_bP_bounds)


        def s_bQ_bounds(model, b, time, step):
            return (0, bat_df.Pmax[b]/bat_df.ESpf[b] / no_of_intervals)  # pmax/espf=smax
        model.s_bQ = Var(list(bats), timeperiods, piecewise_intervals, within=NonNegativeReals, bounds=s_bQ_bounds)


        # sum of piecewise equals total power. Q has pos/neg support, so s_dgQ can be non-neg (due to symmetry of Q2)
        # using total (signed) battery power, so BOTH real/react can be pos or neg.
        def s_bP_pos_support_rule(model, b, t):
            return (sum(model.s_bP[b, t, step] for step in piecewise_intervals) >= model.batPT[b, t])
        model.s_bP_pos_support_constr = Constraint(bats, timeperiods, rule=s_bP_pos_support_rule)


        def s_bP_neg_support_rule(model, b, t):
            return (sum(model.s_bP[b, t, step] for step in piecewise_intervals) >= -model.batPT[b, t])
        model.s_bP_neg_support_constr = Constraint(bats, timeperiods, rule=s_bP_neg_support_rule)


        def s_bQ_pos_support_rule(model, b, t):
            return sum(model.s_bQ[b, t, step] for step in piecewise_intervals) >= model.batQ[b, t]
        model.s_bQ_pos_support_constr = Constraint(bats, timeperiods, rule=s_bQ_pos_support_rule)


        def s_bQ_neg_support_rule(model, b, t):
            return sum(model.s_bQ[b, t, step] for step in piecewise_intervals) >= -model.batQ[b, t]
        model.s_bQ_neg_support_constr = Constraint(bats, timeperiods, rule=s_bQ_neg_support_rule)


        # power triangle (linearized)
        def bat_triangle_rule(model, b, t):
            return (  ## first the sum of the ps intervals
                sum(bat_lin_df['CP%d' % step][b] * model.s_bP[b, t, step] for step in piecewise_intervals) \
                ## now the qs intervals
                + sum(bat_lin_df['CQ%d' % step][b] * model.s_bQ[b, t, step] for step in piecewise_intervals) \
                ### leq cap
                <= (bat_df.Pmax[b]/bat_df.ESpf[b]) ** 2)
        model.bat_triangle_constr = Constraint(bats, timeperiods, rule=bat_triangle_rule)
        
        #gonna use to penalize abs Q in obj
        def Qabs_B1_rule(model,bat,t):
            return(model.Q_Babs[bat,t]>=model.batQ[bat,t])
        model.Qabs_B1_constr=Constraint(bats,timeperiods,rule=Qabs_B1_rule)

        def Qabs_B2_rule(model,bat,t):
            return(model.Q_Babs[bat,t]>=-model.batQ[bat,t])
        model.Qabs_B2_constr=Constraint(bats,timeperiods,rule=Qabs_B2_rule)
        
        #next 2 constraints keep bat power close to last time period if possible
        model.Pdiff_abs=Var(bats,timeperiods,within=NonNegativeReals)
        
        def B_diff1_rule(model,b,t):
            if t==1:
                return(Constraint.Skip)
            else:
                return(model.Pdiff_abs[b,t]>=model.batPT[b,t]-model.batPT[b,t-1])
        model.B_diff1_constr=Constraint(bats,timeperiods,rule=B_diff1_rule)

        def B_diff2_rule(model,b,t):
            if t==1:
                return(Constraint.Skip)
            else:
                return(model.Pdiff_abs[b,t]>=model.batPT[b,t-1]-model.batPT[b,t])
        model.B_diff2_constr=Constraint(bats,timeperiods,rule=B_diff2_rule)

        #OBJ battery cost.
        batCost=sum(del_t*m_cb*(model.batPC[b,t]+model.batPD[b,t]) for b in bats for t in timeperiods)\
                +sum(del_t*model.Q_Babs[b,t] for b in bats for t in timeperiods)\
                +sum(100000*model.extremeSOC[b,t] for b in bats for t in timeperiods)\
                +sum(.0001*model.Pdiff_abs[b,t] for b in bats for t in timeperiods)

        ######################### PCC specific constraints ###########################################

        #getting abs val of PCC power.
        def Pabs_PCC1_rule(model,b,t):
            return(model.P_PCCabs[b,t]>=model.Pbusgen[b,t])
        model.Pabs_PCC1_constr=Constraint(PCC,timeperiods,rule=Pabs_PCC1_rule)

        def Pabs_PCC2_rule(model,b,t):
            return(model.P_PCCabs[b,t]>=-model.Pbusgen[b,t])
        model.Pabs_PCC2_constr=Constraint(PCC,timeperiods,rule=Pabs_PCC2_rule)
        
        def Qabs_PCC1_rule(model,b,t):
            return(model.Q_PCCabs[b,t]>=model.Qbusgen[b,t])
        model.Qabs_PCC1_constr=Constraint(PCC,timeperiods,rule=Qabs_PCC1_rule)

        def Qabs_PCC2_rule(model,b,t):
            return(model.Q_PCCabs[b,t]>=-model.Qbusgen[b,t])
        model.Qabs_PCC2_constr=Constraint(PCC,timeperiods,rule=Qabs_PCC2_rule)

        #bound PCC reactive
        def QPCC_L_rule(model,b,t):
            return(-np.tan(np.arccos(.9))*model.P_PCCabs[b,t]<=model.Qbusgen[b,t])
        model.QPCC_L_const=Constraint(PCC,timeperiods,rule=QPCC_L_rule)

        def QPCC_U_rule(model,b,t):
            return(model.Qbusgen[b,t]<=np.tan(np.arccos(.9))*model.P_PCCabs[b,t])
        model.QPCC_U_const=Constraint(PCC,timeperiods,rule=QPCC_U_rule)

        ##obj PCC cost (cost given from the grid)
        PCCcost=sum(del_t*price_df.cost[t-1]*model.Pbusgen[b,t] for b in PCC for t in timeperiods) #need t-1 b/c price_df indexed with 0 first.
        #Add network cost here
        Q_Exchange=sum(del_t*model.Q_PCCabs[b,t]for b in PCC for t in timeperiods)
        
        ###################### PV Constraints ########################################
            
        #PV we actually use is leq forecasted power (if less, we should be offgrid curtailing)
        def PV_lim_rule(model,pv,t):
            return(model.PV_take[pv,t]<=PV_power[pv,t])
        model.PV_lim_constr=Constraint(PV,timeperiods,rule=PV_lim_rule)
        
        #offgrid/island needs to curtail PV more. Will make constraint above superfluous, but is ok.
        def PV_offgrid_lim_rule(model,pv,t):
            if GridState[t]==2 or GridState[t]==3 or GridState[t]==6: #if Off Grid, Island, Networked
                return(model.PV_take[pv,t]<=curtail[t])
            else: 
                return(Constraint.Skip)
        model.PV_offgrid_curtail_constr=Constraint(PV,timeperiods,rule=PV_offgrid_lim_rule)

        #############Put Obj values together #################################
        #############Creating Objective value stuff....
        #put obj stuff here... dgcost+SUcost+pccCost+batCost+LoadViol+TempViol+voltViol+loss+qthing.
        #model.costfunc=Objective(expr=dgcost)
        model.costfunc = Objective(expr=Cost_Indicator*(dgcost+batCost+PCCcost)
                                    +Loss_Indicator*Loss
                                    +Voltage_Indicator*Volt_vio
                                    +PF_Indicator*Q_Exchange)
                                    
        #print model.costfunc.expr     #will print objective expression
        
                                    
        #SOLVER OPTIONS:
        MIP_GAP = .03 #Stop when gap betwn primal/dual hits this.
        TIME_LIMIT = 300 #seconds
        if printing: print 'set solver options'
        #####################################################################################################
        ####################### SOLVER #####################################################################

        ################################# CBC ###############################
        opt=SolverFactory('cbc') #if can't find solver, can put an explicit path here.
        solver_manager=SolverManagerFactory('serial')
        opt.options['sec'] = str(TIME_LIMIT)
        #opt.options['ratio'] = str(MIP_GAP)

        ###############################################################################################
        ############## Solve and write results #######################################################
        print 'Solving Model...'
        sys.stdout.flush()
        # model.dual = Suffix(direction=Suffix.IMPORT) #For duals
        results = solver_manager.solve(model,opt=opt,tee=False)  # use tee=True if you want to see the solver print-out
        #results.write()  # writing the result to screen
        if printing: print("Total Balanced Optimization time: %s seconds " % (time.time() - start_time))  # stop time here, this is when we are done
        if printing: print ('Solver exited with status %s' %(results.solver.status.key))
        if printing: print('Solver termination condition %s' %results.solver.termination_condition.key)
        Status =results.solver.termination_condition.key
    
        #uncomment to print constraints
        # model.costfunc = Objective(expr=dgcost + batCost + Loss + PCCcost)
        # for con in model.component_map(Constraint).itervalues():
            # con.pprint()
        
        #uncomment to print out variable values    
        # for  v in model.component_objects(Var, active=True):
            # print'variable',v.name
            # varobject=getattr(model,str(v))
            # for index in varobject:
                    # print index,varobject[index].value

    except KeyError as e: 
        print 'UNEXPECTED KeyError', e
        e
        Status='FAIL'
    except IndexError as e: 
        print 'UNEXPECTED IndexError', e
        Status='FAIL'
    except ValueError as e: 
        print 'UNEXPECTED ValueError'
        print e
        Status='FAIL'

    sys.stdout.flush()
     
    ######################## Check if relaxation is exact ####################
    InExCount=0
    diffmax=0
    try:
        for line in lines:
            #print model.current[line, 1].value * lines_df.r[line]
            for t in timeperiods:
                PsqQsq=model.realFlow[line,t].value**2 + model.reactiveFlow[line,t].value**2
                LV=model.current[line,t].value*model.voltage[lines_df.From[line],t].value
                diff=np.abs(LV-PsqQsq) #abs b/c could be negative due to error . Checking how close we are to L*V=PsqQsq
                if diff> diffmax:
                    diffmax=diff
                if sqrt(diff*Sbase) >.1*PLoad_df[0][t-1]*Sbase: #recall diff is pos.
                    print PLoad_df[0][t-1] 
                    #print 'P',model.realFlow[line,t].value
                    print 'Inexact Difference (MW):', diff, 'LV',LV, 'S_sq:', PsqQsq
                    InExCount+=1
        print 'Number of Inexact Timeperiods:', InExCount
        print 'Max Gap (kW):', np.sqrt(diffmax*Sbase) #diffmax is square of error. 
    except: IndexError, TypeError
        
    ########### Get everything in correct format to return results ################
    #multiply by sbase if value was scaled by Sbase at beginning
    negated_net_battery_hold = []
    reactive_hold = []
    SOC_hold = []
    batQ_Arr = []
    generatorpower_hold = []
    generatorreactive_hold = []
    PV_hold = []
    PCC_hold = []
    QCC_hold = []
    voltage_hold = []
    
    #if optimal, populate the arrays we just created. Else, we will send empty ones
    if Status == 'optimal':
        for b in bats:
            batPT_Arr = []
            for t in timeperiods:
                batPT_Arr.append(model.batPT[b, t].value*Sbase)
            negated_net_battery_hold.append(batPT_Arr)
        if printing: 
            try: 
                print('negated_net_battery_hold ES 0',negated_net_battery_hold[0][0])
                print('negated_net_battery_hold ES 1',negated_net_battery_hold[1][0])
            except: IndexError
            
        for b in bats:
            batSOC_Arr=[]
            for t in timeperiods:
                batSOC_Arr.append(((model.B_energy[b, t].value*100.)/bat_df.Emax[b])) #convert energy back to SOC
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
                batQ_Arr.append(model.batQ[b, t].value*Sbase)
            #print 'Q array', batQ_Arr
            reactive_hold.append(batQ_Arr)
        if printing: 
            try: 
                print('reactive_hold battery ES 0',reactive_hold[0][0])
                print('reactive_hold battery ES 1',reactive_hold[1][0])
            except: IndexError
            
            
        
        for g in diesels:
            dgP_Arr = []
            for t in timeperiods:
                dgP_Arr.append(model.dgP[g, t].value*Sbase)
            generatorpower_hold.append(dgP_Arr)
        if printing:
            try: print('generatorpower_hold',generatorpower_hold[0][0])
            except: IndexError
        
        
        for g in diesels:
            dgQ_Arr = []
            for t in timeperiods:
                dgQ_Arr.append(model.dgQ[g, t].value*Sbase)
            generatorreactive_hold.append(dgQ_Arr)
        if printing: 
            try: print('generatorreactive_hold',generatorreactive_hold[0][0])
            except: IndexError

        for p in PV:
            PV_Arr = []
            #print 'PV variable at 0', model.PV_take[p,1].value*Sbase
            for t in timeperiods:
                #PV_Arr.append(PV_power[p, t]*Sbase) #if changing back may need to change 'in pv' to 'in pv_number'
                if GridState[t]==1:
                    PV_Arr.append(PV_df.cap[p])
                else:
                    PV_Arr.append(model.PV_take[p,t].value*Sbase)
            PV_hold.append(PV_Arr)
        if printing: 
            try: print('PV_hold',PV_hold[0][0])
            except: IndexError

        for i in PCC:
            Pbusgen_Arr = []
            for t in timeperiods:
                Pbusgen_Arr.append(model.Pbusgen[i, t].value*Sbase)
            PCC_hold.append(Pbusgen_Arr)
        if printing:
            try: print('PCC_hold',PCC_hold[0][0])
            except: IndexError
            
        for i in PCC:
            Qbusgen_Arr = []
            for t in timeperiods:
                Qbusgen_Arr.append(model.Qbusgen[i, t].value*Sbase)
            QCC_hold.append(Qbusgen_Arr)
        if printing:
            try: print('QCC_hold',QCC_hold[0][0])
            except: IndexError

        for b in buses:
            voltage_Arr = []
            for t in timeperiods:
                if GridState[t]==4: #resynch needs to send PCC voltage
                    voltage_Arr.append(Bus_Voltage_Measured[0])
                else:
                    voltage_Arr.append(np.sqrt(model.voltage[b, t].value))
            voltage_hold.append(voltage_Arr)
        if printing:
            try: print('voltage_hold',voltage_hold[0][0])
            except: IndexError
            
    if Status != 'optimal':
        QCC_hold.append(0) #if optimization failed or infeasible, just set these so we can send back a fail result.
        PCC_hold.append(0)
    
    print 'Returning Optimization Results'    
    sys.stdout.flush()
    time.sleep(10)

    return (negated_net_battery_hold, reactive_hold, generatorpower_hold, generatorreactive_hold, PV_hold,
        PCC_hold[0], QCC_hold[0], ES_VF_Controller, GEN_VF_Controller, voltage_hold, SOC_hold, Status)