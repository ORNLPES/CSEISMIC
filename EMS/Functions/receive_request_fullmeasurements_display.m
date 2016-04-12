function [IEDname,Measurementname,measurement_actual] = receive_request_fullmeasurements_display(program_status, home, SCADA_receive)
%[IEDname,Measurementname,measurement_actual] = receive_request_fullmeasurements_display(program_status, home, SCADA_receive)
% collects data from SCADA on device measurements

measurement_actual = 0;

try 
    %% only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
%% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
end;

try
    %% pull message 
 [newstring, message] = stringU8_unbundle(data_information)
catch Me
end

try
     %% confirm message as expected.
     if strcmp(message{1}','Measurement_get_multiple_success')
         update_status(program_status,home,'Data Received')
         [newstring1, IEDname] = stringU32_unbundle(newstring);
         [newstring2, Measurementname] = stringU32_unbundle(newstring1);
         [measurement_actual] = string_double_unbundle(newstring2);
       
      elseif strcmp(message{1}','Measurement_get_multiple_failure')
         update_status(program_status,home,'File Message Received SCADA error');
         [newstring1, IEDname] = stringU32_unbundle(newstring);
         [newstring2, Measurementname] = stringU32_unbundle(newstring1);
         [newstring3, error_message] = stringU32_unbundle(newstring2);         
         file_message = strcat('message:',message{1}','IEDname:',IEDname{1}','Measurementnames:',Measurementname{1}','error_message',error_message{1}');
     else
         file_message = strcat('message:',message{1}');
         update_status(program_status,home,'File Message Incorrect');
     end;
catch Me
end
    
