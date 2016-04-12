function receive_request_start_optimization(program_status, home, SCADA_receive)
%[] = receive_request_start_optimization(program_status, home, SCADA_receive)
% request from EMS to start optimizer

try 
    % only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
    bypass = 1;
catch Me
     bypass = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if bypass == 1;

    try
    % read rest of message 
        data_information = fread(SCADA_receive,message_length,'char');
    catch Me
        create_error_notification(home,Me.message,'receive request start optimization_read remaining chars.txt');
    end;

    try
        % pull message 
       [newstring, message] = stringU8_unbundle(data_information)
    catch Me
       create_error_notification(home,Me.message,'receive request start optimization_unbundling message.txt');  
    end

    try
         % confirm message as expected.
         if strcmp(message{1}','start_optimization')
             update_status(program_status,home,'File Message Received')
         else
             update_status(program_status,home,'Unknown Text')
             file_information = strcat('message:',message{1});
             create_error_notification(home,file_information,'receive request start optimization_Unknown EMS message.txt');
         end;
    catch Me
           create_error_notification(home,Me.message,'receive request start optimization_pulling data.txt');  
    end
end;
