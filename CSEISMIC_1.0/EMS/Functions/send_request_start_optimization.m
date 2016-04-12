function send_request_start_optimization(program_status, home, SCADA_receive,SCADA_send)
%[] = send_request_start_optimization(program_status, home, SCADA_receive,SCADA_send)
% send request to optimizer to start

    % message
    message = 'start_optimization';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');

    % size of entire message(new_full_send)
    new_full_message = [message_send,message];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;

try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent'))
catch Me
    create_error_notification(home,Me.message,'send request start optimization_fwrite.txt');
end;