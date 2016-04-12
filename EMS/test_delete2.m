clear all;
clc;

 %echotcpip('on',50001)
 SCADA_send = tcpip('localhost',5001,'NetworkRole','Server'); 
 fopen(SCADA_send);
 
 pause(2);
 
 SCADA_receive = tcpip('localhost',5002,'NetworkRole','Client'); 
 fopen(SCADA_receive);
 SCADA_receive.timeout = 100;
 
  disp('Comms set')
  
   disp('sending message')
   
message = 'CID_file_send';
message_bytes = length(message);
message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');

file_name = 'garbage.cid';
file_name_bytes = length(file_name);
file_name_send = cast(typecast(cast(file_name_bytes,'uint8'),'uint8'),'char');

file_contents = 'abcdefghijklmnopqrstuvwxyz';
file_contents_bytes = length(file_contents);
file_contents_send = cast(typecast(cast(file_contents_bytes,'uint32'),'uint8'),'char');

new_full_message = [message_send,message,file_name_send,file_name,file_contents_send,file_contents];
new_full_bytes = length(new_full_message);
new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
new_full_message_full = [new_full_send, new_full_message] ;

try 
     echotcpip('off')
catch
end
 
 fwrite(SCADA_send,new_full_message_full,'char');
 
    disp('message sent')
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 datalength = fread(SCADA_receive,4,'char');
 
message_char = char(datalength);

fullmessage_conv = cast(message_char,'uint8');
fullmessage_receive = typecast(fullmessage_conv,'uint32');
fullmessage_size = cast(fullmessage_receive,'double');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 data_information = fread(SCADA_receive,fullmessage_size,'char');
 
 %%%%%%%%% get the EMS/SCADA message %%%%%
 size_of_message = char(data_information(1));
 size_of_message_conv = cast(size_of_message,'uint8');
 size_of_message_receive = typecast(size_of_message_conv,'uint8');
 size_of_message_size = cast(size_of_message_receive,'double');

 message = {char([data_information(2:size_of_message_size+1)])};
 end_length = size_of_message_size+1;
 %%%%%%%%% get the filename %%%%%
  
 size_of_filename = char(data_information(end_length+1));
 size_of_message_conv = cast(size_of_filename,'uint8');
 size_of_filename_receive = typecast(size_of_message_conv,'uint8');
 size_of_filename_size = cast(size_of_filename_receive,'double');

 filename = {char([data_information(end_length+2:end_length+1+size_of_filename_size)])};
   
disp('message received')

 fclose(SCADA_send);
 fclose(SCADA_receive);