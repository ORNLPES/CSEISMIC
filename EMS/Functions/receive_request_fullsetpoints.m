function [IEDname,setpointname] = receive_request_fullsetpoints(program_status, home, SCADA_receive)
%[IEDname,setpointname] = receive_request_fullsetpoints(program_status, home, SCADA_receive)
% unbundles text from SCADA to confirm request of setpoints.

try 
    %% only read size of entire message 
    datalength = fread(SCADA_receive,4,'char');
    [message_length] = unbundle_fullmessage(datalength)
catch Me
     create_error_notification(home,Me.message,'grid mode_send targets grid connected_receive request full setpoints_read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    %% read rest of message 
    data_information = fread(SCADA_receive,message_length,'char');
catch Me
    create_error_notification(home,Me.message,'grid mode_send targets grid connected_receive request full setpoints_read remaining chars.txt');
end;

try
    %% pull message 
 [newstring, message] = stringU8_unbundle(data_information)
catch Me
   create_error_notification(home,Me.message,'grid mode_send targets grid connected_receive request full setpoints_unbundling message.txt');  
end

try
     %% confirm message as expected.
     if strcmp(message{1}','Setpoint_multiple_set_success')
         update_status(program_status,home,'Data Received')
         [newstring1, IEDname] = stringU32_unbundle(newstring);
         [newstring2, setpointname] = stringU32_unbundle(newstring1);
       
      elseif strcmp(message{1}','Setpoint_multiple_set_failure')
         update_status(program_status,home,'File Message Received SCADA error');
         [newstring1, IEDname] = stringU32_unbundle(newstring);
         [newstring2, setpointname] = stringU32_unbundle(newstring1);
         [newstring3, error_message] = stringU32_unbundle(newstring2);         
         file_message = strcat('message:',message{1}','IEDname:',IEDname{1}','Setpoints:',setpointname{1}','error_message',error_message{1}');
         create_error_notification(home,file_message,'grid mode_send targets grid connected_receive request full setpoints_SCADA error.txt'); 
     else
         file_message = strcat('message:',message{1}');
         update_status(program_status,home,'File Message Incorrect');
         create_error_notification(home,file_message,'grid mode_send targets grid connected_receive request full setpoints_File Message Incorrect.txt'); 
     end;
catch Me
       create_error_notification(home,Me.message,'grid mode_send targets grid connected_receive request full setpoints_unbundling data.txt');  
end
    
