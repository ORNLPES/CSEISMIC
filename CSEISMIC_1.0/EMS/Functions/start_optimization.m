function start_optimization(handles)
%[] = start_optimization(handles)
% starts the optimization program

global Optimization_Ongrid_receive;
global Optimization_Offgrid_receive;
global Optimization_Ongrid_send;
global Optimization_Offgrid_send;
global home;

%% initiate optimization comms
try 
     initiate_optimization(handles.program_status)
catch Me
    create_error_notification(home,Me.message,'Start Optimization_initiating comms.txt');    
end

%% saving optimization settings
try 
     save_optimization_settings(handles)
catch Me
    create_error_notification(home,Me.message,'Start Optimization_saving optimization settings.txt');    
end

%% sending start command to optimization
try 
     send_request_start_optimization(handles.program_status, home, Optimization_Ongrid_receive,Optimization_Ongrid_send)
catch Me
    create_error_notification(home,Me.message,'Start Optimization_send command to ongrid.txt');    
end