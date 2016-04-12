%% Low voltage microgrid energy management optimizer
% Programmed by Guodong Liu
% November 3, 2014, Version 1.00
%clear
function [P_b,P_g,SOC,load_data]=LV_EMS(Pload,P_PV,P_ES,SOC_rcvd,start_time, home, program_status)
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read date form RTDS
% P_pv;
% P_load; SOC P_battery
% write it into txt. as history
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format long g
tic;

%% Turbine Generator data

%         P_min  P_max     a_i        b_i        c_i
Quad_cost=[0	  150	   1.3    	0.0304	    0.00104];
NG=size(Quad_cost,1);
quad_mbtu=Quad_cost(1,3:5);

try 
    set(program_status,'String','Fuel Price Loading')
    pause(.01);
    cd(fullfile(home,'Fuel_price'))
    fuel_price=load('Fuel_price.txt');
    cd(fullfile(home))
catch
    set(program_status,'String','Fuel Price Loading Fail in Optimization')
    pause(.01);
        
    cd(fullfile(home,'Functions'))
    say_old('Fuel price loading fail');
    cd(fullfile(home))
    
    cd(fullfile(home,'Debugging'))
    fid = fopen(strcat('Fuel_price_fail_',datestr(clock,'yyyy_mm_dd_HH_MM_SS')),'w');
    fclose(fid)
    cd(fullfile(home))
    return
    
end;

quad_cost=quad_mbtu*fuel_price;% cost function ($)
Pmin=Quad_cost(:,1);
Pmax=Quad_cost(:,2);
% Piecewise cost function data
e1=(Pmax-Pmin)/3+Pmin;
e2=(Pmax-Pmin)/3*2+Pmin;

MC_1=(quad_cost(2)*e1+quad_cost(3)*(e1)^2-quad_cost(2)*Pmin-quad_cost(3)*(Pmin)^2)/((Pmax-Pmin)/3);
MC_2=(quad_cost(2)*e2+quad_cost(3)*(e2)^2-quad_cost(2)*e1-quad_cost(3)*(e1)^2)/((Pmax-Pmin)/3);
MC_3=(quad_cost(2)*Pmax+quad_cost(3)*(Pmax)^2-quad_cost(2)*e2-quad_cost(3)*(e2)^2)/((Pmax-Pmin)/3);
Piece_cost=[Pmin e1 e2 Pmax MC_1 MC_2 MC_3];
    
% fprintf('P_min   e1    e2    P_max       mc1       mc2       mc3')
% Piece_cost

%% Load Data
% getting load data for the next 24 hours


time1 = datevec(datenum(clock)-2);
year1 = num2str(time1(1));
month1 = num2str(time1(2),'%02.0f');
day1 = num2str(time1(3),'%02.0f');

try
    set(program_status,'String','Load Data Loading')
    pause(.01);
    filename = strcat(year1,'_',month1,'_',day1);
    filename_load =  strcat(year1,'_',month1,'_',day1);
    P_load_48per_min=load(strcat('C:\Users\admin\Desktop\Data\Results\Historian\',filename_load,'\Load_Bank_RTDS_',filename_load,'.txt')); % 
catch
    set(program_status,'String','Load Data Loading Fail')
    pause(.01);
        
    cd(fullfile(home,'Functions'))
    say_old('Load Data loading fail');
    cd(fullfile(home))
    
        
    cd(fullfile(home,'Debugging'))
    fid = fopen(strcat('Load_Data_fail_',datestr(clock,'yyyy_mm_dd_HH_MM_SS')),'w');
    fclose(fid)
    cd(fullfile(home))
    
    return    
end;
    
    
[Num_row,Num_col]=size(P_load_48per_min);
NT=Num_row/10;
for i=1:Num_row
  for j=1:Num_col
    if isnan(P_load_48per_min(i,j))
        P_load_48per_min(i,j)=0;
    end
  end
end
P_load_48per_min_vec=zeros(Num_row,1);
for i=1:Num_row
    P_load_48per_min_vec(i)=sum(P_load_48per_min(i,6:9));
end


P_load_48per5min=zeros(Num_row/5,1);
for i=1:Num_row/5
    P_load_48per5min(i)=mean(P_load_48per_min_vec((i-1)*5+1:5*i))/1000;
end

load_data=P_load_48per5min(start_time:287+start_time)*0.6;%% scale the load to match DECC 
%Index exceeds matrix dimensions
load_data(1)=Pload;

% t=1:NT;
% plot(t,load_data);
% hold on
% grid on
% xlabel('Hours')
% ylabel('Load Forecast (W)')

%% Dayahead Price

try 
    set(program_status,'String','Day Ahead Price Loading')
    pause(.01);
    DA_price_48=load('.\DA_price\DA_price.txt')';
    DA_price = DA_price_48(start_time:start_time+287)';
catch
    set(program_status,'String','Day Ahead Price Loading Fail')
    pause(.01);
        
    cd(fullfile(home,'Functions'))
    say_old('Day Ahead Price loading fail');
    cd(fullfile(home))
    
    cd(fullfile(home,'Debugging'))
    fid = fopen(strcat('Day_Ahead_Price_fail_',datestr(clock,'yyyy_mm_dd_HH_MM_SS')),'w');
    fclose(fid);
    cd(fullfile(home))
    
    return  
end;


% t=1:24;
% plot(t,DA_price);
% hold on
% grid on
% xlabel('Hours')
% ylabel('Prices ($/kWh)')
% title('Day-ahead Market Prices (ct/kWh)')
P_gmin=-400;
P_gmax=400;


%% PV data
try 
    set(program_status,'String','PV Data Loading')
    pause(.01);
    P_pv_48per_min=load(strcat('C:\Users\admin\Desktop\Data\Results\Historian\',filename,'\PV Output_',filename,'.txt'));
catch
    set(program_status,'String','PV Data Loading Fail')
    pause(.01);
        
    cd(fullfile(home,'Functions'))
    say_old('Day Ahead Price loading fail');
    cd(fullfile(home))
    
    cd(fullfile(home,'Debugging'))
    fid = fopen(strcat('PV_Data_fail_',datestr(clock,'yyyy_mm_dd_HH_MM_SS')),'w');
    fclose(fid)
    cd(fullfile(home))
    
    return  
end

[Num_row,Num_col]=size(P_pv_48per_min);
for i=1:Num_row
  for j=1:Num_col
    if isnan(P_pv_48per_min(i,j))
        P_pv_48per_min(i,j)=0;
    end
  end
end
P_pv_48per_min(:,1)=sum(P_pv_48per_min,2);
P_pv_48per_min(:,2)=[];
P_pv_48per5min=zeros(Num_row/5,1);
for i=1:Num_row/5
    P_pv_48per5min(i)=mean(P_pv_48per_min((i-1)*5+1:5*i))/1000;
end
    
% t=1:NT;
% plot(t,Miu_irradiance);
% hold on
% grid on
% xlabel('Hours')
% ylabel('Solar Irradiance')
% calculate PV power output using irradiance and ambient temperature

P_pv = P_pv_48per5min(start_time:start_time+287)*4;  % scale the PV power to match the 50kW PV in DECC

P_pv(1) = P_PV*1000;
% t=1:NT;
% plot(t,P_pv);
% hold on 
% grid on
% xlabel('Hours')
% ylabel('PV Power Output (W)')

%%Battery
battery_data=load('.\Battery_Data.txt');
yita=battery_data(1);%efficiency of battery
Cap=battery_data(2);% battery capacity 10Wh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial SOC/measured data
% SOC0=0.5*Cap;

SOC0=SOC_rcvd*Cap/100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SOC_end=battery_data(3)*Cap;% End SOC
SOC_max=battery_data(4)*Cap;
SOC_min=battery_data(5)*Cap;

P_bmax=battery_data(6);% maximum discharging power

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%P_ES
% measured charging/discharging power
P_b0 = P_ES*1000;
% P_b0 = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Data Preperation Finished
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Optimization Begind

P_1=zeros(NT,1); %first segment of turbine generation 
P_2=zeros(NT,1);% second segment of turbine generation 
P_3=zeros(NT,1);% third segment of turbine generation 
P_t=zeros(NT,1);% total generation of Turbine unit
P_b_c=zeros(NT,1);% Battery charging Power 
P_b_dc=zeros(NT,1);% Battery discharging Power
u_b_c=zeros(NT,1);% Battery charging indicator
u_b_dc=zeros(NT,1);% Battery discharging indicator
P_g=zeros(NT,1);% Grid buy(+)/sell(-) power
SOC=zeros(NT,1);% Battery State of charge (SOC)
X=[P_1,P_2,P_3,P_t,P_b_c,P_b_dc,u_b_c,u_b_dc,P_g,SOC];% optimizating variables
%      P_1             P_2             P_3             P_t         P_b_c        P_b_dc    u_b_c                 u_b_dc          P_g      SOC
f=[MC_1*ones(NT,1);MC_2*ones(NT,1);MC_3*ones(NT,1);zeros(NT,1);zeros(NT,1);zeros(NT,1);zeros(NT,1)*0.0;zeros(NT,1)*0.0;DA_price;zeros(NT,1)]; % cost coefficient

%%%---lower bound---%%%
P_1_lb=zeros(NT,1);
P_2_lb=zeros(NT,1);
P_3_lb=zeros(NT,1);
P_t_lb=zeros(NT,1);
P_b_c_lb=zeros(NT,1);
P_b_dc_lb=zeros(NT,1);
u_b_c_lb=zeros(NT,1);
u_b_dc_lb=zeros(NT,1);
P_g_lb=ones(NT,1)*P_gmin;
SOC_lb=ones(NT,1)*SOC_min;

lb=[P_1_lb;P_2_lb;P_3_lb;P_t_lb;P_b_c_lb;P_b_dc_lb;u_b_c_lb;u_b_dc_lb;P_g_lb;SOC_lb];

%%%---upper bound---%%%

P_1_ub=ones(NT,1)*(e1-Pmin);
P_2_ub=ones(NT,1)*(e2-e1);
P_3_ub=ones(NT,1)*(Pmax-e2);
P_t_ub=ones(NT,1)*Pmax;
P_b_c_ub=ones(NT,1)*P_bmax;
P_b_dc_ub=ones(NT,1)*P_bmax;
u_b_c_ub=ones(NT,1);
u_b_dc_ub=ones(NT,1);
P_g_ub=ones(NT,1)*P_gmax;
SOC_ub=ones(NT,1)*SOC_max;

ub=[P_1_ub;P_2_ub;P_3_ub;P_t_ub;P_b_c_ub;P_b_dc_ub;u_b_c_ub;u_b_dc_ub;P_g_ub;SOC_ub];


%% Equality Constraint
%--- 1) P_t=P_1+P_2+P_3  for any t

Aeq1_P_1=diag(ones(NT,1));
Aeq1_P_2=diag(ones(NT,1));
Aeq1_P_3=diag(ones(NT,1));
Aeq1_P_t=-1*diag(ones(NT,1));
Aeq1_P_b_c=zeros(NT);
Aeq1_P_b_dc=zeros(NT);
Aeq1_u_b_c=zeros(NT);
Aeq1_u_b_dc=zeros(NT);
Aeq1_P_g=zeros(NT);
Aeq1_SOC=zeros(NT);

Aeq1=[Aeq1_P_1,Aeq1_P_2,Aeq1_P_3,Aeq1_P_t,Aeq1_P_b_c,Aeq1_P_b_dc,Aeq1_u_b_c,Aeq1_u_b_dc,Aeq1_P_g,Aeq1_SOC];
beq1=zeros(NT,1);

%--- 2) P_t+P_b_dc-P_d_c+P_g=load_data-P_pv   for any t   
Aeq2_P_1=zeros(NT);
Aeq2_P_2=zeros(NT);
Aeq2_P_3=zeros(NT);
Aeq2_P_t=diag(ones(NT,1));
Aeq2_P_b_c=-1*diag(ones(NT,1));
Aeq2_P_b_dc=diag(ones(NT,1));
Aeq2_u_b_c=zeros(NT);
Aeq2_u_b_dc=zeros(NT);
Aeq2_P_g=diag(ones(NT,1));
Aeq2_SOC=zeros(NT);

Aeq2=[Aeq2_P_1,Aeq2_P_2,Aeq2_P_3,Aeq2_P_t,Aeq2_P_b_c,Aeq2_P_b_dc,Aeq2_u_b_c,Aeq2_u_b_dc,Aeq2_P_g,Aeq2_SOC];
beq2=load_data-P_pv;

%--- 3) SOC(end)=SOC0  

Aeq3_P_1=zeros(1,NT);
Aeq3_P_2=zeros(1,NT);
Aeq3_P_3=zeros(1,NT);
Aeq3_P_t=zeros(1,NT);
Aeq3_P_b_c=zeros(1,NT);
Aeq3_P_b_dc=zeros(1,NT);
Aeq3_u_b_c=zeros(1,NT);
Aeq3_u_b_dc=zeros(1,NT);
Aeq3_P_g=zeros(1,NT);
Aeq3_SOC=[zeros(1,NT-1),1];

Aeq3=[Aeq3_P_1,Aeq3_P_2,Aeq3_P_3,Aeq3_P_t,Aeq3_P_b_c,Aeq3_P_b_dc,Aeq3_u_b_c,Aeq3_u_b_dc,Aeq3_P_g,Aeq3_SOC];
beq3=SOC_end;

%--- 4) SOC(t)=SOC(t-1)+P_b_c*yita*del_t-P_b_dc/yita*del_t  for all t  

Aeq4_P_1=zeros(NT);
Aeq4_P_2=zeros(NT);
Aeq4_P_3=zeros(NT);
Aeq4_P_t=zeros(NT);
Aeq4_P_b_c=-1*yita*diag(ones(NT,1))*5/60;
Aeq4_P_b_dc=1/yita*diag(ones(NT,1))*5/60;
Aeq4_u_b_c=zeros(NT);
Aeq4_u_b_dc=zeros(NT);
Aeq4_P_g=zeros(NT);
Aeq4_SOC=diag(ones(NT,1));
for i=1:(NT-1)
    Aeq4_SOC(i+1,i)=-1;
end

Aeq4=[Aeq4_P_1,Aeq4_P_2,Aeq4_P_3,Aeq4_P_t,Aeq4_P_b_c,Aeq4_P_b_dc,Aeq4_u_b_c,Aeq4_u_b_dc,Aeq4_P_g,Aeq4_SOC];
beq4=[SOC0;zeros(NT-1,1)];

%--- 1)P_b_c<=P_bmax*u_b_c
Aineq1_P_1=zeros(NT);
Aineq1_P_2=zeros(NT);
Aineq1_P_3=zeros(NT);
Aineq1_P_t=zeros(NT);
Aineq1_P_b_c=diag(ones(NT,1));
Aineq1_P_b_dc=zeros(NT);
Aineq1_u_b_c=-P_bmax*diag(ones(NT,1));
Aineq1_u_b_dc=zeros(NT);
Aineq1_P_g=zeros(NT);
Aineq1_SOC=zeros(NT);

Aineq1=[Aineq1_P_1,Aineq1_P_2,Aineq1_P_3,Aineq1_P_t,Aineq1_P_b_c,Aineq1_P_b_dc,Aineq1_u_b_c,Aineq1_u_b_dc,Aineq1_P_g,Aineq1_SOC];
bineq1=zeros(NT,1);

%--- 2)P_b_dc<=P_bmax*u_b_dc
Aineq2_P_1=zeros(NT);
Aineq2_P_2=zeros(NT);
Aineq2_P_3=zeros(NT);
Aineq2_P_t=zeros(NT);
Aineq2_P_b_c=zeros(NT);
Aineq2_P_b_dc=diag(ones(NT,1));
Aineq2_u_b_c=zeros(NT);
Aineq2_u_b_dc=-P_bmax*diag(ones(NT,1));
Aineq2_P_g=zeros(NT);
Aineq2_SOC=zeros(NT);

Aineq2=[Aineq2_P_1,Aineq2_P_2,Aineq2_P_3,Aineq2_P_t,Aineq2_P_b_c,Aineq2_P_b_dc,Aineq2_u_b_c,Aineq2_u_b_dc,Aineq2_P_g,Aineq2_SOC];
bineq2=zeros(NT,1);


%--- 3)u_b_c+u_b_dc<=1
Aineq3_P_1=zeros(NT);
Aineq3_P_2=zeros(NT);
Aineq3_P_3=zeros(NT);
Aineq3_P_t=zeros(NT);
Aineq3_P_b_c=zeros(NT);
Aineq3_P_b_dc=zeros(NT);
Aineq3_u_b_c=diag(ones(NT,1));
Aineq3_u_b_dc=diag(ones(NT,1));
Aineq3_P_g=zeros(NT);
Aineq3_SOC=zeros(NT);

Aineq3=[Aineq3_P_1,Aineq3_P_2,Aineq3_P_3,Aineq3_P_t,Aineq3_P_b_c,Aineq3_P_b_dc,Aineq3_u_b_c,Aineq3_u_b_dc,Aineq3_P_g,Aineq3_SOC];
bineq3=ones(NT,1);
%--- Finally, assemble A Aeq b beq

Aeq=[Aeq1;Aeq2;Aeq3;Aeq4];
beq=[beq1;beq2;beq3;beq4];
Aineq=[Aineq1;Aineq2;Aineq3];
bineq=[bineq1;bineq2;bineq3];
intcon=NT*6+1:NT*8;

[x,fval,exitflag,output] = intlinprog(f,intcon,Aineq,bineq,Aeq,beq,lb,ub);

P_1=x(1:NT);
P_2=x(NT+1:NT*2);
P_3=x(NT*2+1:NT*3);
P_t=x(NT*3+1:NT*4);
P_b_c=x(NT*4+1:NT*5);
P_b_dc=x(NT*5+1:NT*6);
u_b_c=x(NT*6+1:NT*7);
u_b_dc=x(NT*7+1:NT*8);
P_g=x(NT*8+1:NT*9);
SOC=x(NT*9+1:NT*10)/Cap*100;
toc;

P_b=P_b_dc-P_b_c;
% positive--discharging
% negative--charging

% %%Battery
% battery_data(3)=SOC(1)/Cap;
% battery_data(8)=P_b(1);
% fid=fopen('.\Battery_Data.txt','w');
% fprintf(fid,'%.4f\r\n',battery_data);
% fclose(fid);


% Write Result into xlsx File
filename = 'RTDS_Energy_Management_Results.xlsx';
A = cell(NT+1,7);
A(1,:)={'Load','Day-ahead Market Prices (ct/kWh)','PV Power Output (W)',...
        'Turbine Power Output (W)','Battery Charging(-)/Discharging(+) Power (W)','Grid buy(+)/sell(-) power (W)','Battery SOC(Wh)'};
    
for i=1:NT
   A(i+1,1)={load_data(i)};
   A(i+1,2)={DA_price(i)*1000};
   A(i+1,3)={P_pv(i)};
   A(i+1,4)={P_t(i)};
   A(i+1,5)={P_b_dc(i)-P_b_c(i)};
   A(i+1,6)={P_g(i)};
   A(i+1,7)={SOC(i)};
end
sheet = 1;
xlRange = 'A1';
[status]=xlswrite(filename,A,sheet,xlRange);
if status==1
    disp('Results has been successfully written into the Excel file')
else
    disp('Error in writing the results into the Excel file')
end

% Write results into txt file
fileID = fopen('.\Results\RTDS_Energy_Management_Results.txt','w');
fprintf(fileID,'%12s %20s %20s %20s %40s %30s %12s\r\n','Load','DA Market Prices (ct/kWh)','PV Power(W)',...
        'Turbine Power (W)','Battery Charging(-)/Discharging(+) Power (W)','Grid buy(+)/sell(-) power (W)','Battery SOC(Wh)');
for i=1:NT
   fprintf(fileID,'%12.4f',load_data(i)); 
   fprintf(fileID,'%20.4f',DA_price(i));
   fprintf(fileID,'%20.4f',P_pv(i));
   fprintf(fileID,'%20.4f',P_t(i));
   fprintf(fileID,'%40.4f',P_b_dc(i)-P_b_c(i));
   fprintf(fileID,'%30.4f',P_g(i));
   fprintf(fileID,'%12.4f\r\n',SOC(i));
end
fclose(fileID);








% Write Result into csv File
%  fid = fopen(fullfile(home,'Low Voltage Microgrid Energy Management Results.csv'),'w');
%  fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s\n','Load','Day-ahead Market Prices (ct/kWh)','Wind Generation Output (W)','PV Power Output (W)',...
%               'Turbine Power Output (W)','Battery Charging(-)/Discharging(+) Power (W)','Grid buy(+)/sell(-) power (W)','Battery SOC(Wh)');
%      
%  for i=1:NT
%      fprintf(fid,' %12.8f, %12.8f, %12.8f, %12.8f, %12.8f, %12.8f, %12.8f, %12.8f\n',load_data(i),DA_price(i)*1000,P_w(i),P_pv(i),P_t(i),P_b(i),P_g(i),SOC(i));
%  end
%  
%  fclose(fid);
% jtcp('close',JTCPOBJ);




