clear all;
clc;

home = cd;
addpath(fullfile(home,'Functions'))
 SCADA_send = tcpip('localhost',4013,'NetworkRole','Server'); 
 SCADA_send.OutputBufferSize = 10^4;
 fopen(SCADA_send);

 SCADA_receive = tcpip('localhost',4012,'NetworkRole','Server'); 
 fopen(SCADA_receive);
 SCADA_receive.timeout = 10;
 
 program_status = 10;

 send_request(program_status, home, SCADA_send,'message', 'data')
[message,data] = receive_request(program_status, home, SCADA_receive)