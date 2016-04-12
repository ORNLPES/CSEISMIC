function initiate_optimization(program_status)
%[] = initiate_optimization(program_status)
% creates the ports for communications to the the optimizer 

global Optimization_Ongrid_receive;
global Optimization_Offgrid_receive;
global Optimization_Ongrid_send;
global Optimization_Offgrid_send;
global home;

%% initializing communications
try 
        
         Optimization_Ongrid_send = tcpip('localhost',4000,'NetworkRole','Server'); 
         Optimization_Ongrid_send.OutputBufferSize = 10^4;
         Optimization_Ongrid_send.InputBufferSize = 10^4;
         Optimization_Ongrid_send.timeout = 10;
         fopen(Optimization_Ongrid_send);

         Optimization_Ongrid_receive = tcpip('localhost',4001,'NetworkRole','Server'); 
         Optimization_Ongrid_receive.OutputBufferSize = 10^4;
         Optimization_Ongrid_receive.InputBufferSize = 10^4;
         Optimization_Ongrid_receive.timeout = 10;
         fopen(Optimization_Ongrid_receive);
         
catch Me
    create_error_notification(home,Me.message,'Initiating Interconnection to Ongrid Optimization_Comm Setup.txt');    
end

 message = 'Ongrid Optimization App Interconnected';
 update_status(program_status,home,message)
        