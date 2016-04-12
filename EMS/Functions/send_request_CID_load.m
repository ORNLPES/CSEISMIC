function send_request_CID_load(program_status, home, SCADA_receive,SCADA_send, file_name, IEDname)
%  send_request_CID_load(program_status, home, SCADA_receive,SCADA_send,
%  file_name, IEDname) send CID_load command to SCADA along with deivce
%  name.

%% formatting text 
try 
    message = 'CID_load';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');

    %%%% size of filename(file_name_send)/filename(file_name)
    file_name_bytes = length(file_name);
    file_name_send = cast(typecast(cast(file_name_bytes,'uint8'),'uint8'),'char');

    %%%% size of IED name
    IED_bytes = length(IEDname);
    IED_send = cast(typecast(cast(IED_bytes,'uint8'),'uint8'),'char');

    % size of entire message(new_full_send)
    new_full_message = [message_send,message,file_name_send,file_name,IED_send,IEDname];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;

catch Me
    create_error_notification(home,Me.message,'send request CID_formatting.txt');
end;

%%
try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent_',IEDname))
catch Me
    create_error_notification(home,Me.message,'send request CID_fwrite.txt');
end;