function set_vfcontroller(program_status, home,SCADA_send, SCADA_receive, fault_icon)
%[] = set_vfcontroller(program_status, home,SCADA_send, SCADA_receive, fault_icon)
%% sends the name of the vf controller to SCADA 

%% open file and obtain name of vf controller
try
   cd(fullfile(home,'System Architecture Data','System Configuration'))
   island_controller = importdata('island_controller.txt');
   cd(fullfile(home))
catch Me
    create_error_notification(home,Me.message,'Set V F controller_opening file.txt');
end

%% send name of vf controller to SCADA
try 
    send_request_island_set(program_status, home, SCADA_receive,SCADA_send, island_controller{1})
catch Me
    create_error_notification(home,Me.message,'Set V F controller_sending v f name.txt');
end

%% receive confirmation from SCADA
try 
    receive_request_vf_confirm(program_status, home, SCADA_receive)         
catch Me
    create_error_notification(home,Me.message,'Set V F controller_receiving confirmation.txt');
end