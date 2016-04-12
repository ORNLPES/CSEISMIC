function [measurement_actual] = receive_request_measurement(program_status, home, SCADA_receive)
%[measurement_actual] = receive_request_measurement(program_status, home, SCADA_receive)
% processes message from SCADA for measurements
measurement_actual = 0;

try 
    %% only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
     create_error_notification(home,Me.message,'Get PCCmeasurement_receive request measurement_read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    %% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'Get PCCmeasurement_receive request measurement_read remaining chars.txt');
end;

try
    %% pull message 
 [newstring, message] = stringU8_unbundle(data_information)
catch Me
   create_error_notification(home,Me.message,'Get PCCmeasurement_receive request measurement_unbundling message.txt');  
end

try
     %% confirm message as expected.
     if strcmp(message{1}','Measurement_get_success')
         update_status(program_status,home,'Data Received')
         [newstring1, IEDname] = stringU8_unbundle(newstring)
         [newstring2, Measurementname] = stringU8_unbundle(newstring1)
         [measurement_actual] = string_double_unbundle(newstring2)
         
     elseif strcmp(message{1}','Measurement_get_failure')
         update_status(program_status,home,'File Message Received SCADA error');
         [newstring1, IEDname] = stringU8_unbundle(newstring)
         [newstring2, Measurementname] = stringU8_unbundle(newstring1)
         [newstring3, error_message] = stringU32_unbundle(newstring2)
         file_message = strcat('message:',message{1}','IEDname:',IEDname{1}','Measurement name:',Measurementname{1}', 'error_message',error_message{1}');
         create_error_notification(home,file_message,'Initiate SCADA_Send File_SCADA error.txt'); 
     else
         file_message = strcat('message:',message{1}');
         update_status(program_status,home,'File Message Incorrect');
         create_error_notification(home,file_message,'Get PCCmeasurement_receive request measurement_File Message Incorrect.txt'); 
     end;
catch Me
       create_error_notification(home,Me.message,'Get PCCmeasurement_receive request measurement_unbundling data.txt');  
end
    
