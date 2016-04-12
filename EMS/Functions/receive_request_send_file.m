function receive_request_send_file(program_status, home, SCADA_receive)
%[message, error_message] = receive_request(string_handle,main_directory_handle,
%SCADA_receive_handle)
% Awaits message on opened TCP_IP connection SCADA_receive_handle. if
% message does not contain an error message that 'none' is returned.

%% read 4 digits of message from SCADA
try 
    % only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength) %#TODO change name to unbundle_fullmessage_length
catch Me
    create_error_notification(home,Me.message,'Initiate SCADA_receive request send file_fread 4 char.txt'); 
end


%% read the rest of the message from SCADA

try
    % read rest of message 
     data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'Initiate SCADA_receive request send file_fread rest of message.txt'); 
end

%% breakout message into information sets
try
    % pull message
    [newstring, message] = stringU8_unbundle(data_information)
    
    % confirm message as expected.
    if strcmp(message{1}','CID_file_received')
        update_status(program_status,home,'File Message Received')
        [newstring1, message] = stringU8_unbundle(newstring)
    elseif strcmp(message{1}','CID_file_error')
             update_status(program_status,home,'File Message Received SCADA error');
             [newstring1, CID_filename] = stringU8_unbundle(newstring)
             [newstring2, error_message] = stringU32_unbundle(newstring1)
             file_message = strcat('message:',message{1}','filename:',CID_filename{1}', 'error_message',error_message{1}');
             create_error_notification(home,file_message,'Initiate SCADA_recieve request send file_SCADA error.txt');
    else
        file_message = strcat('message:',message{1}');
        update_status(program_status,home,'File Message Incorrect');
        create_error_notification(home,file_message,'Initiate SCADA_recieve request send file_File Message Incorrect.txt');
    end;
catch Me
    create_error_notification(home,Me.message,'Initiate SCADA_receive request send file_unbundling message.txt');
end
