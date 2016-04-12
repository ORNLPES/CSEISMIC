function send_file(program_status, home, SCADA_receive,SCADA_send, filename)
%[] = send_file(string_handle,main_directory_handle,
% SCADA_receive_handle,SCADA_send_handle, filename)
% sends file on opened TCP_IP connection SCADA_send_handle;
% waits for message on opened TCP_IP connection SCADA_receive_handle. 
% This code can be used to send messgaes with different string sizes

 
%%  FULL FILE COLLECTION %%%%%%%%%%%%%%%%%%%%

% open file for data transfer 
try
    file_identification_code = fopen(filename);
catch Me
    create_error_notification(home,Me.message,'Initiate SCADA_send file_file opening error.txt');
end;


%% gets text line by line from file 
try
    % get every line of file and combine %%%%%
    tline = fgets(file_identification_code);
    full_text = tline;
    while ischar(tline)
        tline = fgets(file_identification_code);
        full_text = [full_text,char(10),tline];
    end

    % close file 
    fclose(file_identification_code);
catch Me
    create_error_notification(home,Me.message,'Initiate SCADA_send file_file parsing error.txt');
end;

%% MESSAGING TO SCADA %%%%%%%%%%%%%%%%%%%

try 
    %%%%%%%%% Message contents  %%%%%
    % size of entire message:size of message:message:size of filename:
    % filename: size of file contents: file contents:

    %% size of message(message_send)/message(message)
    message = 'CID_file';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');

    %% size of filename(file_name_send)/filename(file_name)
    file_name = filename
    file_name_bytes = length(file_name);
    file_name_send = cast(typecast(cast(file_name_bytes,'uint8'),'uint8'),'char');

    %% size of contents(file_contents_send)/file contents(file_contents)
    file_contents = full_text;
    file_contents_bytes = length(file_contents);
    file_contents_send = cast(typecast(cast(file_contents_bytes,'uint32'),'uint8'),'char');

    %% size of entire message(new_full_send)
    new_full_message = [message_send,message,file_name_send,file_name,file_contents_send,file_contents];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;
catch Me
        create_error_notification(home,Me.message,'Initiate SCADA_send file_creating message.txt');
end;
 
%% write full message
try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('File_',file_name,'_Sent'))
catch Me
    create_error_notification(home,Me.message,'Initiate SCADA_send file_fwrite.txt');
end;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% %%%%%%%%%%%%%% MESSAGING FROM SCADA %%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try 
     receive_request_send_file(program_status, home, SCADA_receive)
catch Me
      create_error_notification(home,Me.message,'Initiate SCADA_send file_receiving message.txt');
end;

 
 
