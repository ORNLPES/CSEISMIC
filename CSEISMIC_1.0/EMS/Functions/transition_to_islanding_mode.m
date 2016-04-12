function transition_to_islanding_mode(handles)
% [] = transition_to_islanding_mode(handles)
% state for transition to island

global system_status;
global SCADA_receive;
global SCADA_send;
global home;

system_status = 3;

update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
set_indicator(handles.fault_icon,'Ok','green')

% % %%%%%%%%%%%%%%%%%%%%%%%%% Collect Forecast Data %%%%%%%%%%%%%

if system_status == 3
    %%%%%%%%%%% collect forecast data %%%%%%%%%%%%%
    try
        update_status(handles.program_status,home,'Obtain forecast data')
        set_indicator(handles.fault_icon,'Processing','yellow')
        get_forecast()
        set_indicator(handles.fault_icon,'Ready','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Forecast Error.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Transition to Island_Forecast Error.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;  
end;

if system_status == 3
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;
% %%%%%%%%%%%%%%%%%%%%%%%%% COLLECT MEASUREMENTS %%%%%%%%%%%%%

if system_status == 3
    %%%%%%%%%%% collect measurements %%%%%%%%%%%%%
    try
        update_status(handles.program_status,home,'Obtain system measurements')
        set_indicator(handles.fault_icon,'Processing','yellow')
        get_system_measurements_trans_island(handles)
        set_indicator(handles.fault_icon,'Ready','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Measurement Error')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Transition to Island_Get System Measurements.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;

if system_status == 3
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%%%%%%%%%%%%%%%%%%%%%%%% Performing Optimization %%%%%%%%%%%%%

if system_status == 3
        %%%%%%%%%%% run optimization %%%%%%%%%%%%%
        try
            update_status(handles.program_status,home,'Run optimization')
            set_indicator(handles.fault_icon,'Processing','yellow')
            [Net_power] = run_optimization_trans_to_island()
            set_indicator(handles.fault_icon,'Ready','green')
        catch Me
            system_status = -1;
            update_status(handles.program_status,home,'Optimization Error.')
            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
            create_error_notification(home,Me.message,'Transition to Island_Optimization Error.txt');
            set_indicator(handles.fault_icon,'Error','red')
        end;
end;

if system_status == 3
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

% %%%%%%%%%%%%%%%%%%%%%%%% SENDING TARGETS %%%%%%%%%%%%%

if system_status == 3
        %%%%%%%%%%% send targets %%%%%%%%%%%%%
        try
            update_status(handles.program_status,home,'Send Targets')
            set_indicator(handles.fault_icon,'Processing','yellow')
            send_targets_trans_to_island(handles,Net_power)
            set_indicator(handles.fault_icon,'Ready','green')
          
        catch Me
            system_status = -1;
            update_status(handles.program_status,home,'Send Target Error.')
            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
            create_error_notification(home,Me.message,'Transition to Island_Send Target Error.txt');
            set_indicator(handles.fault_icon,'Error','red')
        end;
end;       
 
if system_status == 3
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

pause(10);
%%%%%%%%%%%%%%%%%%%%%%%% SENDING ISLAND COMMANDS %%%%%%%%%%%%%

if system_status == 3
        %%%%%%%%%%% send island command %%%%%%%%%%%%%
        try
            update_status(handles.program_status,home,'Send Island Command')
            set_indicator(handles.fault_icon,'Processing','yellow')
            send_island_command(handles)
            set_indicator(handles.fault_icon,'Ready','green')
        catch Me
            system_status = -1;
            update_status(handles.program_status,home,'Send Target Error.')
            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
            create_error_notification(home,Me.message,'Transition to Island_Send Island Command Error.txt');
            set_indicator(handles.fault_icon,'Error','red')
        end;
end;       
 
if system_status == 3
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

cd(fullfile(home))

