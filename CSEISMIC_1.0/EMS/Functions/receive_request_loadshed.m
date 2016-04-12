function receive_request_loadshed(program_status, home, SCADA_receive)
%[message, error_message] = receive_request(string_handle,main_directory_handle,
%SCADA_receive_handle)
% Awaits message on opened TCP_IP connection SCADA_receive_handle. if
% message does not contain an error message that 'none' is returned.

try 
    % only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
     create_error_notification(home,Me.message,'receive request loadshed__read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'receive request loadshed_read remaining chars.txt');
end;

try
    % pull message 
   [newstring, message] = stringU8_unbundle(data_information)
catch Me
   create_error_notification(home,Me.message,'receive request loadshed_unbundling message.txt');  
end

try
     % confirm message as expected.
     if strcmp(message{1}','Shed_set_success')
         update_status(program_status,home,'File Message Received')
         [newstring1, IEDname] = stringU8_unbundle(newstring);
      
     elseif strcmp('Shed_set_failure',message{1}')
            update_status(program_status,home,strcat('Failed setting control'))
            [newstring1, IEDnames] = stringU8_unbundle(newstring)
            [newstring2, error_message] = stringU32_unbundle(newstring1)
             file_information = strcat('message:',message{1}','//error message:',error_message);
             create_error_notification(home,file_information,'receive request loadshed_SCADA error received.txt');
             set_indicator(fault_icon,'Error','red')
      else
             update_status(program_status,home,'Unknown Text')
             file_information = strcat('message:',message{1});
             create_error_notification(home,file_information,'receive request loadshed_Unknown SCADA message.txt');
             set_indicator(fault_icon,'Error','red')
     end;
catch Me
       create_error_notification(home,Me.message,'receive request loadshed_pulling data.txt');  
end
    
