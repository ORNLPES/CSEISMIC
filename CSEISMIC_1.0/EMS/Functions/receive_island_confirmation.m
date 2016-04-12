function receive_island_confirmation(program_status, home, SCADA_receive)
%[] = receive_island_confirmation(program_status, home, SCADA_receive)
% processes SCADA confirmation on islanding

global system_status

try 
    %% only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
     create_error_notification(home,Me.message,'transition to island_send island command_receive island confirmation_read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    %% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'transition to island_send island command_receive island confirmation_read remaining chars.txt');
end;

try
    % pull message 
   [newstring, message] = stringU8_unbundle(data_information)
catch Me
   create_error_notification(home,Me.message,'transition to island_send island command_receive island confirmation_unbundling message.txt');  
end

try
     %% confirm message as expected.
     if strcmp(message{1}','Island_success')
         update_status(program_status,home,'File Message Received')
         system_status = 4;
      
     elseif strcmp('Island_failure',message{1}')
            update_status(program_status,home,strcat('Failed islanding'));
            [newstring2, error_message] = stringU32_unbundle(newstring);
             file_information = strcat('message:',message{1}','//error message:',error_message);
             create_error_notification(home,file_information,'transition to island_send island command_receive island confirmation_SCADA error received.txt');
             set_indicator(fault_icon,'Error','red');
     else
             update_status(program_status,home,'Unknown Text');
             file_information = strcat('message:',message{1});
             create_error_notification(home,file_information,'transition to island_send island command_receive island confirmation_Unknown text.txt');
             set_indicator(fault_icon,'Error','red');
     end;
catch Me
       create_error_notification(home,Me.message,'transition to island_send island command_receive island confirmation_pulling data.txt');  
end
    
