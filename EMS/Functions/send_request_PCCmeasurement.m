function send_request_PCCmeasurement(program_status, home, SCADA_receive,SCADA_send, IEDname,measurement_name)
% [] = send_request_PCCmeasurement(program_status, home, SCADA_receive,SCADA_send, IEDname,measurement_name)
% sends SCADA request for measurements on PCC

    %% SCADA message
    message = 'Measurement_get';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');

    %% size of IED name
    IED_bytes = length(IEDname);
    IED_send = cast(typecast(cast(IED_bytes,'uint8'),'uint8'),'char');
    
    %% size of measurement name
    measurement_bytes = length(measurement_name);
    measurement_send = cast(typecast(cast(measurement_bytes,'uint8'),'uint8'),'char');

    %% size of entire message(new_full_send)
    new_full_message = [message_send,message,IED_send,IEDname,measurement_send,measurement_name];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;

try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent'))
catch Me
    create_error_notification(home,Me.message,'get PCCmeasurement_send request PCCmeasurement_fwrite.txt');
end;