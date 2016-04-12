function islanded_mode(handles)
%[] = islanded_mode(handles)
% state of off-grid mode. Runs sequence of collect forecast, collect
% measurements, send setpoints.

global system_status;
global SCADA_receive;
global SCADA_send;
global home;

disp('islanded')
pause(1);

if system_status == 4
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
        create_error_notification(home,Me.message,'Forecast Error.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;  
end;

if system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

if system_status == 4
    %%%%%%%%%%% collect measurements %%%%%%%%%%%%%
    try
        update_status(handles.program_status,home,'Obtain system measurements')
        set_indicator(handles.fault_icon,'Processing','yellow')
        get_system_measurements_island(handles)
        set_indicator(handles.fault_icon,'Ready','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Measurement Error')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Get System Measurements.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;
 
if system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;
% 

if system_status == 4
        %%%%%%%%%%% send targets %%%%%%%%%%%%%
        try
            update_status(handles.program_status,home,'Send Targets')
            set_indicator(handles.fault_icon,'Processing','yellow')
            send_targets_off_grid(handles)
            set_indicator(handles.fault_icon,'Ready','green')
        catch Me
            system_status = -1;
            update_status(handles.program_status,home,'Send Target Error.')
            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
            create_error_notification(home,Me.message,'Send Target Error.txt');
            set_indicator(handles.fault_icon,'Error','red')
        end;
end;       
 
if system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;