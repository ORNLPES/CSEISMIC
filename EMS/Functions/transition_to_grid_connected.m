function transition_to_grid_connected(handles)
%[] = transition_to_grid_connected(handles)
% transition to grid connected sequence 
global system_status;
global SCADA_receive;
global SCADA_send;
global home;

%% move system status to 5
system_status = 5;

update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
set_indicator(handles.fault_icon,'Ok','green')

%% SENDING SYCHRONIZE COMMANDS %%%%%%%%%%%%%

if system_status == 5
        
        try
            update_status(handles.program_status,home,'Send Sychronize Command')
            set_indicator(handles.fault_icon,'Processing','yellow')
            SCADA_receive.timeout = 120;
            send_sychronize_command(handles)
            SCADA_receive.timeout = 10;
            set_indicator(handles.fault_icon,'Ready','green')
        catch Me
            system_status = -1;
            update_status(handles.program_status,home,'Send Target Error.')
            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
            create_error_notification(home,Me.message,'Send Island Command Error.txt');
            set_indicator(handles.fault_icon,'Error','red')
        end;
end;       
 
if system_status == 5
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

cd(fullfile(home))

