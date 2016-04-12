function on_grid_mode(handles)
% [] = on_grid_mode(handles)
% runs the state of on-grid mode

global home;
global system_status;
global SCADA_receive;
global SCADA_send;

%% collect forecast data
if system_status == 2
    try
        update_status(handles.program_status,home,'Obtain forecast data')
        set_indicator(handles.fault_icon,'Processing','yellow')
        get_forecast()
        set_indicator(handles.fault_icon,'Ready','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Forecast Error.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Forecast Error.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;  
end;

if system_status == 2
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% collect pricing data
if system_status == 2
    try
        update_status(handles.program_status,home,'Obtain pricing data')
        set_indicator(handles.fault_icon,'Processing','yellow')
        get_cost()
        set_indicator(handles.fault_icon,'Ready','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Price Error.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Price Error.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;  
end;

if system_status == 2
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% collect measurements
if system_status == 2
    try
        update_status(handles.program_status,home,'Obtain system measurements')
        set_indicator(handles.fault_icon,'Processing','yellow')
        get_system_measurements(handles)
        set_indicator(handles.fault_icon,'Ready','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Measurement Error')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Get System Measurements.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;
 
if system_status == 2
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% save SOC
if system_status == 2
    try
        update_status(handles.program_status,home,'Obtain system measurements')
        set_indicator(handles.fault_icon,'Processing','yellow')
        pull_and_save_energy_storage_SOCs()
        set_indicator(handles.fault_icon,'Ready','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'SOC Error')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Save SOC.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;
 
if system_status == 2
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% send targets
if system_status == 2
        try
            update_status(handles.program_status,home,'Send Targets')
            set_indicator(handles.fault_icon,'Processing','yellow')
            send_targets_grid_connected(handles)
            set_indicator(handles.fault_icon,'Ready','green')
        catch
            system_status = -1;
            update_status(handles.program_status,home,'Send Target Error.')
            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
            create_error_notification(home,'Send Target Error','Send Target Error.txt');
            set_indicator(handles.fault_icon,'Error','red')
        end;
end;       
 
if system_status == 2
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;