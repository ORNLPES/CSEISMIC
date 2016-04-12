function blackstart(handles)
% [] = blackstart(handles)
% initiates blackstart and communication to SCADA

global system_status
global home
global SCADA_receive;
global SCADA_send;

try
    %% awaiting blackstart button click
    while system_status == 6
        update_status(handles.program_status,home,'Awaiting Blackstart Command...')
        pause(.1)
    end;
    
    %% ensure blackstart button was selected
    if system_status == 4
    %% pull vf for blackstart
        try
            cd(fullfile(home,'System Architecture Data','System Configuration'))
            island_controller = importdata('island_controller.txt');
            cd(fullfile(home))
        catch Me
            create_error_notification(home,Me.message,'blackstart_pull vf controller.txt');
        end;
    end;

    if system_status == 4
        [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
    end;

    if system_status == 4
    %% pull device list for blackstart
        try
            cd(fullfile(home,'System Architecture Data','System Configuration'))
            other_devices = importdata('blackstart_devices.txt');
            cd(fullfile(home))
        catch Me
            create_error_notification(home,Me.message,'blackstart_pull other devices.txt');
        end;
    end;

    if system_status == 4
        [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
    end;

   if system_status == 4
   %% send blackstart command with device list
        try
            send_request_blackstart(handles.program_status, home, SCADA_receive,SCADA_send,island_controller, other_devices)
        catch Me
            create_error_notification(home,Me.message,'blackstart_send blackstart command.txt');
        end;
    end;

    if system_status == 4
        [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
    end;

    if system_status == 4
   %% send blackstart command with device list
        try
            receive_request_blackstart(handles.program_status, home, SCADA_receive)
        catch Me
            create_error_notification(home,Me.message,'blackstart_send blackstart command.txt');
        end;
    end;

    if system_status == 4
        [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
    end; 
 
catch
   create_error_notification(home,Me.message,'blackstart_loop.txt');
end;