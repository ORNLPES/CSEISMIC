function send_request_island_set(program_status, home, SCADA_receive,SCADA_send, IEDname)
%% [] = send_request_island_set(program_status, home, SCADA_receive,SCADA_send, IEDname)
%% sends 'Island_control_set' message to SCADA with IED name of device

    message = 'Island_control_set';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');

    %%%% size of IED name
    IED_bytes = length(IEDname);
    IED_send = cast(typecast(cast(IED_bytes,'uint8'),'uint8'),'char');

    % size of entire message(new_full_send)
    new_full_message = [message_send,message,IED_send,IEDname];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;

try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent'))
catch Me
    create_error_notification(home,Me.message,'set vfcontroller_send request island set_fwrite.txt');
end;