function receive_request_PCCrelay_confirm(program_status, home, SCADA_receive)
%[] = receive_request_PCCrelay_confirm(program_status, home, SCADA_receive)
% receives and processes message confirmation from SCADA on islanding
% switch

error_message = 'none';

try 
    %% only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
     create_error_notification(home,Me.message,'set relayisland_receive request PCCrelay confirm_read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
%% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'set relayisland_receive request PCCrelay confirm_read remaining chars.txt');
end;

try
    %% pull message 
   [newstring, message] = stringU8_unbundle(data_information)
catch Me
   create_error_notification(home,Me.message,'set vfcontroller_receive request vf confirm_unbundling message.txt');  
end

try
     %% confirm message as expected.
     if strcmp(message{1}','PCC_relay_set_success')
         update_status(program_status,home,'File Message Received')
         [newstring1, IEDname] = stringU8_unbundle(newstring);
      
     elseif strcmp('PCC_relay_set_failure',message{1}')
            update_status(program_status,home,strcat('Failed setting control'))
            [newstring1, IEDname] = stringU8_unbundle(newstring)
            [newstring2, error_message] = stringU32_unbundle(newstring1)
             file_information = strcat('message:',message{1}','//error message:',error_message);
             create_error_notification(home,file_information,'Set V F controller_error received.txt');
             set_indicator(fault_icon,'Error','red')
      else
             update_status(program_status,home,'Unknown Text')
             file_information = strcat('message:',message{1});
             create_error_notification(home,file_information,'Set V F controller_Unknown text.txt');
             set_indicator(fault_icon,'Error','red')
     end;
catch Me
       create_error_notification(home,Me.message,'set vfcontroller_receive request vf confirm__pulling data.txt');  
end
    
