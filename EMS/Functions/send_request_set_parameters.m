function send_request_set_parameters(program_status, IED_name,parameter_name,data_type,data)

global home;
global SCADA_send;

    message = 'Device_parameter_set';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');
    
    IED_name_bytes = length(IED_name);
    IED_name_send = cast(typecast(cast(IED_name_bytes,'uint8'),'uint8'),'char');
    
    parameter_name_bytes = length(parameter_name);
    parameter_name_send = cast(typecast(cast(parameter_name_bytes,'uint8'),'uint8'),'char');
    
    data_type_send = cast(typecast(cast(data_type,'uint8'),'uint8'),'char');
    data_send = cast(typecast(cast(data,'uint8'),'uint8'),'char');
    
    % size of entire message(new_full_send)
    new_full_message = [message_send,message, IED_name_send,IED_name,parameter_name_send,parameter_name,data_type_send,data_send];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;

try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent'))
catch Me
    create_error_notification(home,Me.message,'send request set parameter_send message.txt');
end;