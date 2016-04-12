
function startup_sequence(handles)
%startup_sequence(handles) runs the initital startup sequence for
%initiating the microgrid 

%reinitialize global variables
global home;
global system_status;
global SCADA_receive;
global SCADA_send;

% provide information on current status

update_status(handles.program_status,home,'Initiating Master Controller Startup Sequence')
update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
set_indicator(handles.fault_icon,'Ok','green')

%% STARTING COMMUNICATIONS TO SCADA %%%%%%%%%%%%%
%%%%%% Create the initial port opening
%%%%%% Import and pass the CID files to labview

try
    update_status(handles.program_status,home,'Initiating Interconnection to SCADA')
    set_indicator(handles.fault_icon,'Processing','yellow')
    [SCADA_send,SCADA_receive] = initiate_SCADA(handles.program_status, home, handles.testing_checkbox)
    set_indicator(handles.fault_icon,'Ok','green')
catch Me    
    system_status = -1;
    update_status(handles.program_status,home,'Initiation to SCADA failed.')
    update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
    create_error_notification(home,Me.message,'Failed Initiating Interconnection to SCADA.txt');
    set_indicator(handles.fault_icon,'Error','red')
end;

if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;



%% IDENTIFYING DEVICES FROM LOCAL FILES %%%%%%%%%%%%%
% Create local list of devices and information for optimization
% purposes and communications from .CID files. 

if system_status == 1 || system_status == 4
    try
        update_status(handles.program_status,home,'Identifying Devices From Files')
        set_indicator(handles.fault_icon,'Processing','yellow')
        getIDS(handles.program_status, home)
        set_indicator(handles.fault_icon,'Ok','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Identification failed.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Identifying Devices From Files.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;

if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% CHECKING DEVICE STATUS
% Ensure that the devices are all active. If not, provide an indication on
% which device has failed and provide a warning to user.

if system_status == 1 || system_status == 4
    try
        update_status(handles.program_status,home,'Checking Device Status')
        set_indicator(handles.fault_icon,'Processing','yellow')
        device_check(handles.program_status, home,SCADA_send,SCADA_receive,handles.fault_icon)
        set_indicator(handles.fault_icon,'Ok','green')
    catch Me   
         system_status = -1;
         update_status(handles.program_status,home,'Status Check Failed.')
         update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
         create_error_notification(home,Me.message,'Checking Device Status.txt');
         set_indicator(handles.fault_icon,'Error','red')
    end;
end;

if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% SETTING V/F CONTROLLER

if system_status == 1 || system_status == 4
    try
        update_status(handles.program_status,home,'Set V/F controller')
        set_indicator(handles.fault_icon,'Processing','yellow')
        set_vfcontroller(handles.program_status, home, SCADA_send, SCADA_receive,handles.fault_icon)
        set_indicator(handles.fault_icon,'Ok','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Set V/F controller failed.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Set V/F controller.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;

if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% SETTING ISLANDING RELAY

if system_status == 1 || system_status == 4
    try
        update_status(handles.program_status,home,'Set Microgrid Switch')
        set_indicator(handles.fault_icon,'Processing','yellow')
        set_relayisland(handles.program_status, home, SCADA_send, SCADA_receive,handles.fault_icon)
        set_indicator(handles.fault_icon,'Ok','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Set island relay failed.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'Set relayisland.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;

if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% SETTING LOAD SHED
% % 
% % if system_status == 0
% %     try
% %         update_status(handles.program_status,home,'Set Load Shed Schem')
% %         set_indicator(handles.fault_icon,'Processing','yellow')
% %         set_loadshed(handles.program_status, home, SCADA_send, SCADA_receive,handles.fault_icon)
% %         set_indicator(handles.fault_icon,'Ok','green')
% %     catch Me
% %         system_status = -1;
% %         update_status(handles.program_status,home,'Set Load Shed Schem failed.')
% %         update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
% %         create_error_notification(home,Me.message,'Set loadshed_scheme.txt');
% %         set_indicator(handles.fault_icon,'Error','red')
% %     end;
% % end;
% % 
% % if system_status == 0
% %     [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
% % end;
% % 
% % 
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%% GETTING INFO ON DEVICES %%%%%%%%%%%%%
% %%%%%%% Get information on devices from locally stored data.
% 
% % if system_status == 0
% %     try
% %         update_status(handles.program_status,home,'Gathering Device Info')
% %         set_indicator(handles.fault_icon,'Processing','yellow')
% %         %get_device_info(handles.program_status, home,SCADA_send,SCADA_receive,handles.fault_icon)
% %         set_indicator(handles.fault_icon,'Ok','green')
% %     catch Me    
% %         system_status = -1;
% %         update_status(handles.program_status,home,'Gathering Device Info Failed.')
% %         update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
% %         create_error_notification(home,Me.message,'Gathering Device Info.txt');
% %         set_indicator(handles.fault_icon,'Error','red')
% %     end;
% % end;
% 
% % if system_status == 0
% %     [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
% % end;
% 
% %%%%%%%%%%%%%%%%%%%%%%%% SENDING CONFIGURATION INFORMATION %%%%%%%%%%%%%
% %%%%%% Set information on devices from locally stored data.
% 
% if system_status == 0
%     try
%         update_status(handles.program_status,home,'Adjusting Device Settings')
%         set_indicator(handles.fault_icon,'Processing','yellow')
%         set_device_info(handles.program_status, handles.fault_icon)
%         set_indicator(handles.fault_icon,'Ok','green')
%     catch Me    
%         system_status = -1;
%         update_status(handles.program_status,home,'Adjusting Device Settings Failed.')
%         update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
%         create_error_notification(home,Me.message,'Adjusting Device Settings.txt');
%         set_indicator(handles.fault_icon,'Error','red')
%     end;
% end;
% 
% if system_status == 0
%     [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
% end;

%% GETTING MEASUREMENTS
% Getting device measurements to confirm on-grid connection

if system_status == 1 || system_status == 4
    try
        update_status(handles.program_status,home,'Obtaining Device Measurements')
        set_indicator(handles.fault_icon,'Processing','yellow')
        get_PCCmeasurement(handles.program_status, home,SCADA_send, SCADA_receive, handles.fault_icon)
        set_indicator(handles.fault_icon,'Ok','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Obtaining Device Measurements failed.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'get_PCC measurement.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;

if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;

%% CHECKING MEASUREMENTS
% Checking grid voltage to ensure available for activation.

if system_status == 1 || system_status == 4
    try
        update_status(handles.program_status,home,'Checking Device Measurements')
        set_indicator(handles.fault_icon,'Processing','yellow')
        check_PCC_measurement(handles)
        set_indicator(handles.fault_icon,'Ok','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Checking Device Measurements failed.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'check_PCC measurement.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;


if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;
% 
%% CLEARING OPTIMIZATION RESULTS
% Checking grid voltage to ensure available for activation.

if system_status == 1 || system_status == 4
    try
        update_status(handles.program_status,home,'Clearing Optimization Results')
        set_indicator(handles.fault_icon,'Processing','yellow')
        clear_setpoints(handles)
        set_indicator(handles.fault_icon,'Ok','green')
    catch Me
        system_status = -1;
        update_status(handles.program_status,home,'Clearing Optimization Results failed.')
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
        create_error_notification(home,Me.message,'clear optimization results.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;


if system_status == 1 || system_status == 4
    [system_status] = emergency_check(handles.program_status, home, system_status, handles.system_status,handles.fault_icon)
end;


%% STARTUP FAILURE
% If any of the above sequence steps fails notify that the system 
% did not start correctly.

if system_status == -1
    update_status(handles.program_status,home,'Startup Failed')
    set_indicator(handles.fault_icon,'Error','red')
elseif system_status == 4
    update_status(handles.program_status,home,'Grid Voltage Issue')
    set_indicator(handles.fault_icon,'Warning','orange')  
else    
    update_status(handles.program_status,home,'Startup Successfully Completed')
    set_indicator(handles.fault_icon,'Ready','green')
    system_status = 1;
end;
cd(fullfile(home))
