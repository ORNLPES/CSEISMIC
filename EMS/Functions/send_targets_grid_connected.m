function send_targets_grid_connected(handles)
%[] = send_targets_grid_connected(handles)
% send targets for devices to SCADA

global home;
global SCADA_receive;
global SCADA_send;

%% load setpoints from file (file created by optimizer)
try
    cd(fullfile(home,'System Data','Setpoints'))
    [setpoints,IEDnames,setpointnames] = load_setpoints();
   
catch Me
    create_error_notification(home,Me.message,'on grid mode_send targets grid connected_parsing data.txt');
end

%% sends request for setpoints to SCADA
try
	send_request_setpoints(handles.program_status, home, SCADA_receive,SCADA_send, IEDnames,setpointnames,setpoints)
catch Me
	create_error_notification(home,Me.message,'on grid mode_send targets_sending request.txt');
end;
  
%% decomposes message from SCADA
try
    [IEDname,setpointname] = receive_request_fullsetpoints(handles.program_status, home, SCADA_receive)
catch Me
        create_error_notification(home,Me.message,'on grid mode_send targets_getting confirmation.txt');
end;


