function send_sychronize_command(handles)
%[] = send_sychronize_command(handles)
% Sends command and receives comfirmation of sychronization to SCADA
global home;
global SCADA_receive;
global SCADA_send;

%% sends sychronize command to SCADA
try
    send_request_sychronize(handles.program_status, home, SCADA_receive,SCADA_send)
catch Me
    create_error_notification(home,Me.message,'transition to grid mode_send sychronize command_sending request.txt');
end;
  
%% receives and processes confirmation of sychronization from SCADA
try
    receive_grid_connect_confirmation(handles.program_status, home, SCADA_receive)
catch Me
        create_error_notification(home,Me.message,'transition to grid mode_send sychronize command_getting confirmation.txt');
end;


