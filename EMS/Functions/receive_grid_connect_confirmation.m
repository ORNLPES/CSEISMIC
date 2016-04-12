function receive_grid_connect_confirmation(program_status, home, SCADA_receive)
%[] = receive_grid_connect_confirmation(program_status, home, SCADA_receive)\
% receives and processes confirmation of sychronization from SCADA 

global system_status

try 
    %% only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
     create_error_notification(home,Me.message,'transition to grid connect_send grid connect command_receive grid connect confirmation_read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    %% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'transition to grid connect_send grid connect command_receive grid connect confirmation_read remaining chars.txt');
end;

try
    %% pull message 
   [newstring, message] = stringU8_unbundle(data_information)
catch Me
   create_error_notification(home,Me.message,'transition to grid connect_send grid connect command_receive grid connect confirmation_unbundling message.txt');  
end

try
     %% confirm message as expected.
     if strcmp(message{1}','Synchronize_success')
         update_status(program_status,home,'File Message Received')
         system_status = 2;
      
     elseif strcmp('Synchronize_failure',message{1}')
            update_status(program_status,home,strcat('Failed sychronization'));
            [newstring2, error_message] = stringU32_unbundle(newstring);
             file_information = strcat('message:',message{1}','//error message:',error_message);
             create_error_notification(home,file_information,'transition to grid connect_send grid connect command_receive grid connect confirmation_SCADA error received.txt');
             set_indicator(fault_icon,'Error','red');
     else
             update_status(program_status,home,'Unknown Text');
             file_information = strcat('message:',message{1});
             create_error_notification(home,file_information,'transition to grid connect_send grid connect command_receive grid connect confirmation_Unknown text.txt');
             set_indicator(fault_icon,'Error','red');
     end;
catch Me
       create_error_notification(home,Me.message,'transition to grid connect_send grid connect command_receive grid connect confirmation_pulling data.txt');  
end
    
