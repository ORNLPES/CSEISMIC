function send_request_loadshed(program_status, home, SCADA_receive,SCADA_send, IEDnames)
    
    message = 'Shed_set';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');
 
    %%%% size of IED name
    for i = 1:length(IEDnames)
      if i == 1
          IEDname_hold = IEDnames{i}
      else
          IEDname_hold = [IEDname_hold,',',IEDnames{i}]
      end;
    end;
            
    IED_bytes = length(IEDname_hold);
    IED_send = cast(typecast(cast(IED_bytes,'uint32'),'uint8'),'char');
    
    % size of entire message(new_full_send)
    new_full_message = [message_send,message,IED_send,IEDname_hold];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;

try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent'))
catch Me
    create_error_notification(home,Me.message,'send request loadshed_fwrite.txt');
end;