function send_island_command(handles)
%[] = send_island_command(handles)
% sends command to SCADA to perform islanding action

global home;
global SCADA_receive;
global SCADA_send;

%% send islanding command to SCADA
try
    send_request_island(handles.program_status, home, SCADA_receive,SCADA_send)
catch Me
    create_error_notification(home,Me.message,'transition to islanding mode_send island command_sending request.txt');
end;
  
%% process confirmation from SCADA
try
    receive_island_confirmation(handles.program_status, home, SCADA_receive)
catch Me
        create_error_notification(home,Me.message,'on grid mode_send targets_getting confirmation.txt');
end;


