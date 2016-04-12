function send_targets_off_grid(handles)
%[] = send_targets_off_grid(handles)
% sends SCADA setpoints for devices

global home;
global SCADA_receive;
global SCADA_send;

%% load setpoints from optimization
try
    cd(fullfile(home,'System Data','Setpoints'))
    [setpoints,IEDnames,setpointnames] = load_setpoints_off_grid();
   
catch Me
    create_error_notification(home,Me.message,'island mode_send targets off grid_parsing data.txt');
end

%% send setpoints to SCADA
try
    send_request_setpoints(handles.program_status, home, SCADA_receive,SCADA_send, IEDnames,setpointnames,setpoints)
catch Me
    create_error_notification(home,Me.message,'island mode_send targets off grid_sending request.txt');
end;
 
%% process confirmation from SCADA
try
    [IEDname,setpointname] = receive_request_fullsetpoints(handles.program_status, home, SCADA_receive)
catch Me
        create_error_notification(home,Me.message,'island mode_send targets off grid_getting confirmation.txt');
end;


