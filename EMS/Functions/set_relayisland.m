function set_relayisland(program_status, home,SCADA_send, SCADA_receive, fault_icon)
% [] = set_relayisland(program_status, home,SCADA_send, SCADA_receive, fault_icon)
% sends SCADA the name of the islanding switch

%% pulls the islanding switch name
try
   cd(fullfile(home,'System Architecture Data','System Configuration'))
   relay_controller = importdata('relay_island_controller.txt');
   cd(fullfile(home))
catch Me
    create_error_notification(home,Me.message,'Set relayisland_opening file.txt');
end

%% sends SCADA islanding switch name
try
    send_request_maingrid_relay_set(program_status, home, SCADA_receive,SCADA_send, relay_controller{1})
catch Me
    create_error_notification(home,Me.message,'Set islandrelay_sending relay name.txt');
end

%% receives confirmation from SCADA
try
    receive_request_PCCrelay_confirm(program_status, home, SCADA_receive)
         
catch Me
    create_error_notification(home,Me.message,'Set islandrelay__receiving confirmation.txt');
end