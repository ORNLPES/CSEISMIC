function device_check(program_status, home, SCADA_send,SCADA_receive,fault_icon)
% device_check(program_status, home, SCADA_send,SCADA_receive,fault_icon)
%%%%%% Ensure that the devices are all active. If not, provide an
%%%%%% indication on which device has failed and provide a warning to
%%%%%% user.

cd(fullfile(home,'System Architecture Data'))

%% pulling file names from stored files
try 
    device_names = importdata('Device_names.txt');
    file_names = importdata('Modbus_File_names_located.txt');

catch Me
    create_error_notification(home,Me.message,'Device check_missing files.txt');
end;

cd(fullfile(home))


for i = 1:length(device_names)
   
    try
        %% send load command of CID files to SCADA
        send_request_CID_load(program_status, home, SCADA_receive,SCADA_send, file_names{i},device_names{i})
    catch Me
        create_error_notification(home,Me.message,'Device check_sending message.txt');
    end;
    
    try
        %% receive confirmation from SCADA on CID files 
         receive_request_CID_load(program_status, home, SCADA_receive)
    catch Me
         create_error_notification(home,Me.message,'Device check_receiving message.txt');
    end;
    
end;
