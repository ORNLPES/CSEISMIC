function unintentional_island(handles)
% [] =  unintentional_island(handles)
% state for transition to island (unintentional)

global system_status;
global home;

system_status = 4;

update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
set_indicator(handles.fault_icon,'Ok','green')
 
cd(fullfile(home))

