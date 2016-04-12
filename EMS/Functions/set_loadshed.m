function set_loadshed(program_status, home,SCADA_send, SCADA_receive, fault_icon)

try
   cd(fullfile(home,'System Architecture Data','System Configuration'))
   loadshed_list = importdata('load_shed_start.txt');
   cd(fullfile(home))
catch Me
    create_error_notification(home,Me.message,'Set loadshed_opening file.txt');
end

try
    send_request_loadshed(program_status, home, SCADA_receive,SCADA_send, loadshed_list)
catch Me
    create_error_notification(home,Me.message,'Set loadshed_sending relay name.txt');
end


try
    receive_request_loadshed(program_status, home, SCADA_receive)
         
catch Me
    create_error_notification(home,Me.message,'Set loadshed__receiving confirmation.txt');
end