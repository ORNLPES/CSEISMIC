function send_targets_trans_to_island(handles,Net_power)
%[] = send_targets_trans_to_island(handles,Net_power)
% sends setpoints for devices to SCADA for transitioning to island

global home;
global SCADA_receive;
global SCADA_send;

%% obtain v/f controller
try
    cd(fullfile(home,'System Architecture Data','System Configuration'))
    vf_name = importdata('island_controller.txt');
    IEDnames = vf_name;
    setpointnames{1} = 'Real';
    setpointnames = setpointnames'
    setpoints = Net_power;
catch Me
    create_error_notification(home,Me.message,'send targets trans to island_load vf.txt');
end

%% sends setpoints to SCADA 
try
	send_request_setpoints_trans_island(handles.program_status, home, SCADA_receive,SCADA_send, IEDnames,setpointnames,setpoints)
catch Me
	create_error_notification(home,Me.message,'send targets trans to island_sending request.txt');
end;
  
%% receives confirmation from SCADA
try
    [IEDname,setpointname] = receive_request_fullsetpoints(handles.program_status, home, SCADA_receive)
catch Me
        create_error_notification(home,Me.message,'send targets trans to islands_getting confirmation.txt');
end;


