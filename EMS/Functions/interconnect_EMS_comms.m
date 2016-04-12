function interconnect_EMS_comms(handles)
%[] = interconnect_EMS_comms(handles)
% sets communications to optimizer

global system_status
global home

%%  STARTING COMMUNICATION TO OPTIMIZERS
try
    update_status(handles.program_status,home,'Starting OG Optimizer')
    set_indicator(handles.fault_icon,'Processing','yellow')
    start_optimization(handles)
    set_indicator(handles.fault_icon,'Ok','green')
catch Me    
    system_status = -1;
    update_status(handles.program_status,home,'Starting OG Optimizer failed.')
    update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
    create_error_notification(home,Me.message,'Failed Initiating Start of OG Optimizer.txt');
    set_indicator(handles.fault_icon,'Error','red')
end;

