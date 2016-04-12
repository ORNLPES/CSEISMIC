function [do_not_stop] = receive_request_emergency(program_status, home, SCADA_emergency)
%[] = receive_request_emergency(program_status, home, SCADA_emergency)
% processes message from SCADA upon emergency

do_not_stop = 0;

%% only read size of entire message
try  
    datalength = fread(SCADA_emergency,4,'char');
    if isempty(datalength)
        do_not_stop = 1;
    else
        [message_length] = unbundle_fullmessage(datalength)
    end;
catch Me
     create_error_notification(home,Me.message,'receive request emergency_read first 4 chars.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if do_not_stop == 0
%% read rest of message
    try
        data_information = fread(SCADA_emergency,message_length,'char');
    catch Me
        create_error_notification(home,Me.message,'receive request emergency_read remaining chars.txt');
    end;
    
%% pull message 
    try
        
       [newstring, message] = stringU8_unbundle(data_information)
    catch Me
       create_error_notification(home,Me.message,'receive request emergency_unbundling message.txt');  
    end
    
 %% confirm message as expected.
    try
         cd(fullfile(home,'Emergency Cache'))
         fid = fopen('Emergency_issued.txt','w')
    
         if strcmp(message{1}','Fatal_error')
             [newstring2, data] = stringU8_unbundle(newstring)
             update_status(program_status,home,'Fault Detected')
             fprintf(fid,'%s',message{1}')
             do_not_stop = 2;

         elseif strcmp(message{1}','Islanded')
            update_status(program_status,home,strcat('Unintentional Island Detected'));
            fprintf(fid,'%s',message{1}')
         else
             update_status(program_status,home,'Unknown Text');
             fprintf(fid,'%s',message{1}')
             create_error_notification(home,file_information,'receive request emergency_Unknown text.txt');
             set_indicator(fault_icon,'Error','red');
             do_not_stop = 2;
         end;

         fclose(fid);

    catch Me
           create_error_notification(home,Me.message,'receive request emergency_pulling data.txt');  
           do_not_stop = 2;   
           try
               fclose(fid)
           catch
           end;
    end
end;

