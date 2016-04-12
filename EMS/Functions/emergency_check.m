function [system_status] = emergency_check(program_status, home, system_status, system_status_handle,fault_icon)
%[system_status] = emergency_check(program_status, home, system_status, system_status_handle,fault_icon)
% checks to see if a file is in the emergency cache folder. If yes, imports
% data and checks for message.

global system_status;

cd(fullfile(home,'Emergency Cache'))

list_files = dir('*.txt');

%% processing messages
if length(list_files) > 0
    information = importdata(list_files(1).name)
    
    if strcmp(information,'Fatal_error')
        create_error_notification(home,'See Emergency Cache','Fatal Error Received From SCADA.txt');
        set_indicator(fault_icon,'Stop','red')
        system_status = -1;
    elseif strcmp(information,'Islanded')
        delete('Emergency_issued.txt')
        system_status = 8;
    else
        create_error_notification(home,'See Emergency Cache','Unknown Error Received From SCADA.txt');
        set_indicator(fault_icon,'Stop','red')
        system_status = -1;  
    end;
end;
cd(fullfile(home))

    