function run_optimization_grid_connected(handles)
%[] = run_optimization_grid_connected(handles)
% runs optimization for grid connection

global home;
global ignore_results;

%% load PCC switch information %%%%%%
try
   cd(fullfile(home,'System Architecture Data','System Configuration'))
   relay_island_controller = importdata('relay_island_controller.txt');  
catch Me
    create_error_notification_ongrid_optimization(home,Me.message,'run optimization grid connected_load PCC.txt');
end
   

%% LOADING DATA SETS %%%%%%%%%%%%%%%%%%%%%

%% load system measurement data for the optimization %%%%%%
try 
    cd(fullfile(home,'System Data','Measurements'))
    [VPCC_pu] = load_measurements_VPCC(relay_island_controller);
catch Me
     create_error_notification_ongrid_optimization(home,Me.message,'run optimization grid connected_PCC voltages.txt'); 
end;    


try
   %% PULLING INPUTS AND RUNNING OPTIMIZATION %%%%%%%%%%%%%%%%%%%%%

    cd(fullfile(home,'System Architecture Data','Optimization Settings'))    
    indicators = load('Optimization_settings.txt')
    [P_g_solution,u_g_solution,Q_g_solution,P_b_solution,u_b_solution,SOC_b_solution,Q_b_solution,P_pcc_solution,Q_pcc_solution,V_n_solution,P_f_solution,Q_f_solution]=EMS_Grid_connected(handles,indicators,mean(VPCC_pu));
catch Me
     disp('optimization_failure')
     set(handles.program_status,'String','Optimization Failed...')
     pause(5);
     create_error_notification_ongrid_optimization(home,Me.message,'run optimization grid connected_optimization failure.txt'); 
end
    
%% SAVING OPTMIZATION RESULTS %%%%%%%%%%%%%%%%%%%%%
if ignore_results == 0
    try 
        cd(fullfile(home,'System Architecture Data'))
        generators_list = importdata('generator_device_list.txt')
        es_list = importdata('ES_device_list.txt')

         for i = 1:length(es_list)
                 P_b_solution(i)
         end;
         
         for i = 1:length(generators_list)
                 P_g_solution(i)
         end;
         
        %%check_optimization_success
 
        cd(fullfile(home,'System Data','Setpoints'))

        %% Ensure file is not open
        setpointcontinue =0;
        while setpointcontinue <1000
            fid = fopen('Setpoints.txt','w')
            if fid == -1
                pause(0.05)
                setpointcontinue = setpointcontinue +1;
                if setpointcontinue > 900
                    disp('stopped at run optimization grid connected')
                end;
            else
                setpointcontinue = 10000;
            end
        end

        try
            for i = 1:length(generators_list)
                fprintf(fid,'%s,Real,%f\n',generators_list{i},P_g_solution(i,1))
                fprintf(fid,'%s,Reactive,%f\n',generators_list{i},Q_g_solution(i,1))
                fprintf(fid,'%s,Voltage,%f\n',generators_list{i},480)
                fprintf(fid,'%s,Frequency,%f\n',generators_list{i},60)
            end;

            for i = 1:length(es_list)
                 fprintf(fid,'%s,Real,%f\n',es_list{i},P_b_solution(i)*1000^2)
                 fprintf(fid,'%s,Reactive,%f\n',es_list{i},Q_b_solution(i)*1000^2)
                 fprintf(fid,'%s,Voltage,%f\n',es_list{i},480)
                 fprintf(fid,'%s,Frequency,%f\n',es_list{i},60) 
            end
        catch
            disp('Error in writing data')
        end;
        fclose(fid)
    catch Me
        disp('Optimization failed, trying again.')
        %%create_error_notification_ongrid_optimization(home,Me.message,'run optimization grid connected_saving setpoints file.txt');
    end
end;

if ignore_results == 0
    try

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cd(fullfile(home,'System Data','Optimized Results'));
        %% ensure file is not in use
        setpointcontinue = 0;
        while setpointcontinue <100
            fid = fopen('Optimization Results.csv','w')
            if fid ==-1
                pause(0.05)
                setpointcontinue = setpointcontinue +1;
            else
                break
            end
        end
       %%

        %% TIME WINDOW OPTIMIZED
        fprintf(fid,'Time (5 minute),time,')

        for i = 1:288
            fprintf(fid,'%f,',i);
        end;

        fprintf(fid,'\n')

        %% ENERGY STORAGE OPTIMIZED RESULTS
        fprintf(fid,'Battery kW,20,')

        for i = 1:length(P_b_solution)
            fprintf(fid,'%f,',P_b_solution(i)*1000^2);
        end;
        fprintf(fid,'\n')
        %% SOC OPTIMIZED RESULTS
        fprintf(fid,'SOC,22,')

        for i = 1:length(SOC_b_solution)
            fprintf(fid,'%f,',(((SOC_b_solution(i)*1000^2)/200000*100))); %convert from MWh to SOC (200kWh unit)
        end;
        fprintf(fid,'\n')

        fclose(fid);
    catch Me
        create_error_notification_ongrid_optimization(home,Me.message,'run optimization grid connected_saving Optimization results.txt');
    end
end;

