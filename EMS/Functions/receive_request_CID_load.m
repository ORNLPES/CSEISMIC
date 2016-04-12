function receive_request_CID_load(program_status, home, SCADA_receive)
%[message, error_message] = receive_request(string_handle,main_directory_handle,
%SCADA_receive_handle)
% Awaits message on opened TCP_IP connection SCADA_receive_handle. if
% message does not contain an error message that 'none' is returned.

%error_message = 'none';

try 
    % only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
     create_error_notification(home,Me.message,'Device check_receive request CID load_read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'Device check_receive request CID load_read remaining chars.txt');
end;

try
    % pull message 
    [newstring, message] = stringU8_unbundle(data_information)
catch Me
   create_error_notification(home,Me.message,'Device check_receive request CID load_unbundling message.txt');  
end

try
     % confirm message as expected.
     if strcmp(message{1}','CID_load_success')
         update_status(program_status,home,'File Message Received')
         [newstring1, filename] = stringU8_unbundle(newstring)
         [newstring2, IEDname] = stringU8_unbundle(newstring1)
     elseif strcmp(message{1}','CID_load_failure')
         update_status(program_status,home,'File Message Received SCADA error');
         [newstring1, CID_filename] = stringU8_unbundle(newstring)
         [newstring2, IEDname] = stringU8_unbundle(newstring1)
         [newstring3, error_message] = stringU32_unbundle(newstring2)
         file_message = strcat('message:',message{1}','filename:',CID_filename{1}','IEDname:',IEDname{1}', 'error_message:',error_message{1}');
         create_error_notification(home,file_message,'receive request CID load_CID file error.txt'); 
     else
         file_message = strcat('message:',message{1}');
         update_status(program_status,home,'File Message Incorrect');
         create_error_notification(home,file_message,'receive request CID load_File Message Incorrect.txt'); 
     end;
catch Me
       create_error_notification(home,Me.message,'receive request CID load_unbundling data.txt');  
end
    
