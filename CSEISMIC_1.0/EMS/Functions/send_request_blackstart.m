function send_request_blackstart(program_status, home, SCADA_receive,SCADA_send, vf, other_devices)
%[] = send_request_blackstart(program_status, home, SCADA_receive,SCADA_send, vf, other_devices)
% send SCADA request to blackstart
try
    %% create basic message
    message = 'Black_start';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');
    
    %% put vf controller in first part of message
    message_vf = strcat(vf{1});
    new_full_current = [message_vf];
    
    %% add other devices in message
    for i = 1:length(other_devices)
        message_otherdevices = other_devices{i};   
        new_full_current = [new_full_current,',',message_otherdevices]
        
    end;
    
    message_device_bytes = length(new_full_current);
    message_device_send = cast(typecast(cast(message_device_bytes,'uint32'),'uint8'),'char');
   
    %% compile full message
    new_full_main_message = [message_send,message,message_device_send,new_full_current];
    new_full_bytes = length(new_full_main_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_main_message];
catch Me
    create_error_notification(home,Me.message,'send request blackstart_building message.txt');  
end;

try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent'))
catch Me
    create_error_notification(home,Me.message,'send request blackstart_sending message.txt');
end;