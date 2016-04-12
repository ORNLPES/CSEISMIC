function [P_g_solution,u_g_solution,Q_g_solution,P_b_solution,u_b_solution,SOC_b_solution,Q_b_solution,P_pcc_solution,Q_pcc_solution,V_n_solution,P_f_solution,Q_f_solution]=EMS_Grid_connected(handles,indicators,V_PCC)
%% Read date form paralell folders
global home;
global ignore_results;
ignore_results = 0;
% Microgrid Energy Management optimizer for Grid Connected Mode
% Programmed by Guodong Liu, Oak Ridge National Laboratory
% September 20, 2015, Version 1.0

% 

Sbase=1000; % Sbase=1000kVA

try 
    update_status(handles.program_status,home,'Reading Data')
    Cost_Indicator = indicators(1);
    PF_Indicator = indicators(2);
    Dmd_Crg_Indicator = indicators(3);
    Loss_Indicator = indicators(4);
    Voltage_Indicator = indicators(5);
    Commit_Indicator = indicators(6);
 
catch Me
        create_error_notification_ongrid_optimization(home,Me.message,'EMS Grid Connected_retrieve indicators.txt');   
end;

%% Read CSV files

if ignore_results == 0
	try 
		%% Read Generator Parameter
		cd(fullfile(home,'System Architecture Data','Network Model','Generator'))
			
		fid = fopen('Generator Parameter.csv');
		data = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','Delimiter',',');
		fclose(fid);

		generators = zeros(length(data{1})-1,length(data));
		for i = 1:length(data{1})-1
			for j = 1:length(data)
				generators(i,j) = str2double(data{j}(i+1));
			end
		end
		NG=length(generators(:,1));
		Smax_g=generators(:,4)/Sbase;
		Pmin_g=generators(:,5)/Sbase;
		Pmax_g=generators(:,6)/Sbase;
		PFmax_g=generators(:,7);
		PFmin_g=generators(:,8);
		e1=generators(:,9)/Sbase;
		e2=generators(:,10)/Sbase;
		nlc=generators(:,11);
		mc1=generators(:,12)*Sbase;
		mc2=generators(:,13)*Sbase;
		mc3=generators(:,14)*Sbase;

	catch Me
		disp('EMS Grid Connected_Read Generator Parameter')
		disp(Me.message)   
		ignore_results = 1;
	end;
end;

% Piece_cost=[Pmin_g e1 e2 Pmax_g mc1 mc2 mc3];
% fprintf('P_min   e1    e2    P_max       mc1       mc2       mc3')
% Piece_cost

%% Read Load Data
if ignore_results == 0
	try
		cd(fullfile(home,'System Architecture Data','Network Model','Load'))
		 
		fid = fopen('Load_config.csv');
		data = textscan(fid,'%s%s%s','Delimiter',',');
		fclose(fid);
		NL=length(data{1})-1;% Get the number of load, load priority can also be get here
		loads_bus =zeros(NL,1);
		for i = 1:NL
		   loads_bus(i) = str2double(data{2}(i+1));
		end

		%%%%%%%%%%%%%% Load Power Consumption Forecast Data %%%%%%%%%%%%%%%
		setpointcontinue =0;
		
		while setpointcontinue <100
			fid = fopen('P_Load.csv')
			if fid ==-1
				pause(0.05)
				setpointcontinue = setpointcontinue +1;
			else
				break
			end
		end
			   
		string_count = '%s';
		for i = 1:288
			string_count = strcat(string_count,'%s');
		end;
		
		data = textscan(fid,string_count,'Delimiter',',');
		fclose(fid);

		NL_load=length(data)-1;% Get the number of loads in the config file, load priority must also be set  here
		P_loads =zeros(NL_load,length(data{1})-1);
		for i = 1:NL_load
			for k = 1:length(data{1})-1
				P_loads(i,k) = str2double(data{i+1}(k+1))/Sbase;
			end;
		end
		
		%%%%%%%%%%%%%% Load Reactive Consumption Forecast Data %%%%%%%%%%%%%%%
		
		setpointcontinue =0;
		
		while setpointcontinue <100
			fid = fopen('Q_load.csv')
			if fid ==-1
				pause(0.05)
				setpointcontinue = setpointcontinue +1;
			else
				break
			end
		end
		
		   
		string_count = '%s';
		for i = 1:288
			string_count = strcat(string_count,'%s');
		end;
		
		data = textscan(fid,string_count,'Delimiter',',');
		fclose(fid);

		NL_load=length(data)-1;% Get the number of loads in the config file, load priority must also be set  here
		Q_loads =zeros(NL_load,length(data{1})-1);
		for i = 1:NL_load
			for k = 1:length(data{1})-1
				Q_loads(i,k) = str2double(data{i+1}(k+1))/Sbase;
			end;
		end
		
		NT=length(P_loads(:,1));
		del_t=24/NT;
	catch Me
		disp('EMS Grid Connected_Read Load Parameter')
		disp(Me.message) 
		ignore_results = 1;		
	end;
end;

if ignore_results == 0

	try 
		%% Dayahead Tariff
		cd(fullfile(home,'System Data','Price Data','Electricity Tariff'))
		
		
		setpointcontinue =0;
		
		while setpointcontinue <100
			fid = fopen('Tariff.csv')
			if fid ==-1
				pause(0.05)
				setpointcontinue = setpointcontinue +1;
			else
				break
			end
		end
		
		
		data = textscan(fid,'%s%s','Delimiter',',');
		fclose(fid);

		DA_price = zeros(length(data{1})-1,length(data)-1);
		for i = 1:length(data{1})-1
			for j = 1:length(data)-1
				DA_price(i,j) = str2double(data{j+1}(i+1))*Sbase;
			end
		end
	catch Me
		
		disp('EMS Grid Connected_Read Tariff Parameter')
		disp(Me.message) 
		ignore_results = 1;
				 
	end;
end;

if ignore_results == 0

	try 
		%% PV data
		cd(fullfile(home,'System Architecture Data','Network Model','PV'))
		fid = fopen('Solar_config.csv');
		data = textscan(fid,'%s%s','Delimiter',',');
		fclose(fid);
		NPV=length(data{1})-1;% Get the number of load, load priority can also be get here
		PV_bus =zeros(NPV,1);
		for i = 1:NPV
		   PV_bus(i) = str2double(data{2}(i+1));
		end

		
		temp='%s';
		for i=1:NPV
		temp=strcat(temp,'%s');
		end

		setpointcontinue =0;
		 while setpointcontinue <100
			fid = fopen('Solar Data.csv')
			if fid ==-1
				pause(0.05)
				setpointcontinue = setpointcontinue +1;
			else
				break
			end
		end
		
		
		string_count = '%s';
		for i = 1:288
			string_count = strcat(string_count,'%s');
		end;
		
		data = textscan(fid,string_count,'Delimiter',',');
		fclose(fid);
		
		NV_load=length(data)-1;
		PV = zeros(NV_load,length(data{1})-1)
		for i = 1:NV_load
			for k = 1:length(data{1})-1
				PV(i,k) =  str2double(data{i+1}(k+1))/Sbase;
			end
		end
	catch Me
		disp('EMS Grid Connected_Read PV Data')
		disp(Me.message) 
		ignore_results = 1;
	end;
end;
	
	
if ignore_results == 0	
	try   
		%% Battery
		cd(fullfile(home,'System Architecture Data','Network Model','Battery'))
		
		
	      setpointcontinue =0;
		 while setpointcontinue <100
			fid = fopen('Battery Parameter.csv')
			if fid ==-1
				pause(0.05)
				setpointcontinue = setpointcontinue +1;
			else
				break
			end
		end
		
		data = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s','Delimiter',',');
		fclose(fid);

		batteries = zeros(length(data{1})-1,length(data));
		for i = 1:length(data{1})-1
			for j = 1:length(data)
				batteries(i,j) = str2double(data{j}(i+1));
			end
		end

		NB=length(batteries(:,1));% number of batteries
		Smax_b=batteries(:,4)/Sbase;
		Emax_b=batteries(:,5)/Sbase;
		Pmax_b=batteries(:,4)/Sbase;
		PFmax_b=batteries(:,7);
		PFmin_b=batteries(:,8);
		SOC_min=batteries(:,9).*Emax_b/100;
		SOC_max=batteries(:,10).*Emax_b/100;

		yita_ch=batteries(:,11);%efficiency of battery charging
		yita_dch=batteries(:,12);%efficiency of battery discharging

		SOC0=batteries(:,13).*Emax_b/100;% Initial SOC can be directly claimed from measurements

		SOCend=batteries(:,14).*Emax_b/100;% Initial/End SOC
	catch Me
		disp('EMS Grid Connected_Read Battery Data')
		disp(Me.message) 
		ignore_results = 1;      
	end;
end;

if ignore_results == 0	
	try 
		%% Dayahead Commitment
		cd(fullfile(home,'System Data','Price Data','Commitment'))
		fid = fopen('Commitment_P.csv');
		data = textscan(fid,'%s%s','Delimiter',',');
		fclose(fid);

		DA_commit_P = zeros(length(data{1})-1,length(data)-1);
		for i = 1:length(data{1})-1
			for j = 1:length(data)-1
				DA_commit_P(i,j) = str2double(data{j+1}(i+1))/Sbase;
			end
		end

		fid = fopen('Commitment_Q.csv');
		data = textscan(fid,'%s%s','Delimiter',',');
		fclose(fid);

		DA_commit_Q = zeros(length(data{1})-1,length(data)-1);
		for i = 1:length(data{1})-1
			for j = 1:length(data)-1
				DA_commit_Q(i,j) = str2double(data{j+1}(i+1))/Sbase;
			end
		end
	catch Me
		disp('EMS Grid Connected_Read Commitment Data')
		disp(Me.message) 
		ignore_results = 1;       
	end;
end;

if ignore_results == 0; 
	try 
		%% Dayahead Commitment
		cd(fullfile(home,'System Data','Price Data','Demand Charge'))
		Dmd_Crg = load('Demand Charge.txt');
	catch Me
		disp('EMS Grid Connected_Read Demand Charge')
		disp(Me.message) 
		ignore_results = 1;     
	end;  
end;

if ignore_results == 0; 
	try
		%% Cables and Parameters
		cd(fullfile(home,'System Architecture Data','Network Model','Cable and Transformer'))
		fid = fopen('Cable_and_Transformer_Parameters.csv');
		data = textscan(fid,'%s%s%s%s%s%s%s%s%s%s','Delimiter',',');
		fclose(fid);

		Cables = zeros(length(data{1})-1,length(data));
		for i = 1:length(data{1})-1
			for j = 1:length(data)
				Cables(i,j) = str2double(data{j}(i+1));
			end
		end
		NC=length(Cables(:,1));% # of cables and transformers
		NN=NC+1; %radial system total bus# = total branch# + 1
		Cables(:,7)=[];
		Cables(:,6)=[];
		Cables(:,4)=[];
		% calculate per unit value
		V_base=Cables(1,4);
		Zbase= V_base^2/1000000;% base voltage 13.8 kV; base power 1 kW
		Cables(:,5)=Cables(:,5)/Sbase;
		for i=1:NC
		   Cables(i,6)=Cables(i,6)*(V_base/Cables(i,4))^2/Zbase;
		   Cables(i,7)=Cables(i,7)*(V_base/Cables(i,4))^2/Zbase;
		end
	catch Me
		disp('EMS Grid Connected_Read Cable and Transformer')
		disp(Me.message) 
		ignore_results = 1;     
	end;   
end;
    
if ignore_results == 0
	try
		%Data Preperation Finished
		update_status(handles.program_status,home,'Data Read Successful!')
		update_status(handles.program_status,home,'Start Formulating Optimization Model...')
		clear data;
	catch Me
			disp('EMS Grid Connected_Display')
			disp(Me.message)   
			ignore_results = 1;     
	end;
end;

if ignore_results == 0
	try 
		%% Determine costs
		MC_1=zeros(NG*NT,1);% marginal cost of segment 1
		for t=1:NT
			 MC_1((t-1)*NG+1:t*NG)=mc1*del_t;
		end

		MC_2=zeros(NG*NT,1);% marginal cost of segment 2
		for t=1:NT
			 MC_2((t-1)*NG+1:t*NG)=mc2*del_t;
		end

		MC_3=zeros(NG*NT,1);% marginal cost of segment 3
		for t=1:NT
			 MC_3((t-1)*NG+1:t*NG)=mc3*del_t;
		end
		 
		NLC=zeros(NG*NT,1);% non-linear cost of units
		for t=1:NT
			 NLC((t-1)*NG+1:t*NG)=nlc*del_t;
		end

		K_sc=zeros(NG*NT,1);% start-up cost of units
		for t=1:NT
			 K_sc((t-1)*NG+1:t*NG)=generators(:,16);
		end
	catch Me
		disp('EMS Grid Connected_Cost Analysis')
		disp(Me.message)   
		ignore_results = 1;           
	end;
end;
	
	
if ignore_results == 0
	try
		%% Linearize P_f Q_f
		small_number=0.00001;
		large_number=1e6;
		C_B_c=ones(NB*NT,1)*small_number;
		C_B_dc=ones(NB*NT,1)*small_number;

		% linearize P_f^2
		c_p_f1=zeros(NC,1);
		c_p_f2=zeros(NC,1);
		c_p_f3=zeros(NC,1);
		p_f_e1=Cables(:,5)/3;
		p_f_e2=Cables(:,5)/3*2;
		for i=1:NC
			c_p_f1(i)=(p_f_e1(i)^2-0)/(Cables(i,5)/3)*Cables(i,6);
		end
		for i=1:NC
			c_p_f2(i)=(p_f_e2(i)^2-p_f_e1(i)^2)/(Cables(i,5)/3)*Cables(i,6);
		end
		for i=1:NC
			c_p_f3(i)=(Cables(i,5)^2-(p_f_e2(i))^2)/(Cables(i,5)/3)*Cables(i,6);
		end

		% linearize Q_f^2
		c_q_f1=zeros(NC,1);
		c_q_f2=zeros(NC,1);
		c_q_f3=zeros(NC,1);
		q_f_e1=Cables(:,5)/3;
		q_f_e2=Cables(:,5)/3*2;
		for i=1:NC
			c_q_f1(i)=(q_f_e1(i)^2-0)/(Cables(i,5)/3)*Cables(i,6);
		end
		for i=1:NC
			c_q_f2(i)=(q_f_e2(i)^2-q_f_e1(i)^2)/(Cables(i,5)/3)*Cables(i,6);
		end
		for i=1:NC
			c_q_f3(i)=(Cables(i,5)^2-(q_f_e2(i))^2)/(Cables(i,5)/3)*Cables(i,6);
		end
	catch Me
			disp('EMS Grid Connected_Linearize P_f Q_f')
			disp(Me.message)   
			ignore_results = 1;         
	end
end;

if ignore_results == 0
	try
		%% Calculation of P_g Q_g
		% power loss calculation r*P^2
		C_P_f1=zeros(NC*NT,1);% power loss calculation
		for t=1:NT
			 C_P_f1((t-1)*NC+1:t*NC)=c_p_f1*del_t;
		end
		C_P_f2=zeros(NC*NT,1);% power loss calculation
		for t=1:NT
			 C_P_f2((t-1)*NC+1:t*NC)=c_p_f2*del_t;
		end
		C_P_f3=zeros(NC*NT,1);% power loss calculation
		for t=1:NT
			 C_P_f3((t-1)*NC+1:t*NC)=c_p_f3*del_t;
		end

		% power loss calculation r*Q^2
		C_Q_f1=zeros(NC*NT,1);% power loss calculation
		for t=1:NT
			 C_Q_f1((t-1)*NC+1:t*NC)=c_q_f1*del_t;
		end
		C_Q_f2=zeros(NC*NT,1);% power loss calculation
		for t=1:NT
			 C_Q_f2((t-1)*NC+1:t*NC)=c_q_f2*del_t;
		end
		C_Q_f3=zeros(NC*NT,1);% power loss calculation
		for t=1:NT
			 C_Q_f3((t-1)*NC+1:t*NC)=c_q_f3*del_t;
		end

		% linearize P_g^2
		c_p_g1=zeros(NG,1);
		c_p_g2=zeros(NG,1);
		c_p_g3=zeros(NG,1);
		p_g_e1=e1;
		p_g_e2=e2;
		for i=1:NG
			c_p_g1(i)=(p_g_e1(i)^2-Pmin_g(i)^2)/(p_g_e1(i)-Pmin_g(i));
		end
		for i=1:NG
			c_p_g2(i)=(p_g_e2(i)^2-p_g_e1(i)^2)/(p_g_e2(i)-p_g_e1(i));
		end
		for i=1:NG
			c_p_g3(i)=(Pmax_g(i)^2-(p_g_e2(i))^2)/(Pmax_g(i)-p_g_e2(i));
		end
		% calculation P_g^2
		C_P_g1=zeros(NG*NT,1);% 
		for t=1:NT
			 C_P_g1((t-1)*NG+1:t*NG)=c_p_g1;
		end
		C_P_g2=zeros(NG*NT,1);%
		for t=1:NT
			 C_P_g2((t-1)*NG+1:t*NG)=c_p_g2;
		end
		C_P_g3=zeros(NG*NT,1);% 
		for t=1:NT
			 C_P_g3((t-1)*NG+1:t*NG)=c_p_g3;
		end
		% linearize Q_g^2
		c_q_g1=zeros(NG,1);
		c_q_g2=zeros(NG,1);
		c_q_g3=zeros(NG,1);
		q_g_e1=Smax_g/3;
		q_g_e2=Smax_g/3*2;
		for i=1:NG
			c_q_g1(i)=(q_g_e1(i)^2-0)/(Smax_g(i)/3);
		end
		for i=1:NG
			c_q_g2(i)=(q_g_e2(i)^2-q_g_e1(i)^2)/(Smax_g(i)/3);
		end
		for i=1:NG
			c_q_g3(i)=(Smax_g(i)^2-(q_g_e2(i))^2)/(Smax_g(i)/3);
		end
		% calculation Q_g^2
		C_Q_g1=zeros(NG*NT,1);% 
		for t=1:NT
			 C_Q_g1((t-1)*NG+1:t*NG)=c_q_g1;
		end
		C_Q_g2=zeros(NG*NT,1);%
		for t=1:NT
			 C_Q_g2((t-1)*NG+1:t*NG)=c_q_g2;
		end
		C_Q_g3=zeros(NG*NT,1);% 
		for t=1:NT
			 C_Q_g3((t-1)*NG+1:t*NG)=c_q_g3;
		end
	catch Me
		disp('EMS Grid Connected_Calculation of P_g Q_g')
		disp(Me.message)   
		ignore_results = 1;  
	end;
end;

if ignore_results == 0
	try
    %% Calculation of P_b Q_b
    % linearize Q_b^2
    c_q_b1=zeros(NB,1);
    c_q_b2=zeros(NB,1);
    c_q_b3=zeros(NB,1);
    q_b_e1=Smax_b/3;
    q_b_e2=Smax_b/3*2;
    for i=1:NB
        c_q_b1(i)=(q_b_e1(i)^2-0)/(Smax_b(i)/3);
    end
    for i=1:NB
        c_q_b2(i)=(q_b_e2(i)^2-q_b_e1(i)^2)/(Smax_b(i)/3);
    end
    for i=1:NB
        c_q_b3(i)=(Smax_b(i)^2-(q_b_e2(i))^2)/(Smax_b(i)/3);
    end
    % calculation Q_b^2
    C_Q_b1=zeros(NB*NT,1);% 
    for t=1:NT
         C_Q_b1((t-1)*NB+1:t*NB)=c_q_b1;
    end
    C_Q_b2=zeros(NB*NT,1);%
    for t=1:NT
         C_Q_b2((t-1)*NB+1:t*NB)=c_q_b2;
    end
    C_Q_b3=zeros(NB*NT,1);% 
    for t=1:NT
         C_Q_b3((t-1)*NB+1:t*NB)=c_q_b3;
    end

    % linearize P_b^2
    c_p_b1=zeros(NB,1);
    c_p_b2=zeros(NB,1);
    c_p_b3=zeros(NB,1);
    p_b_e1=Smax_b/3;
    p_b_e2=Smax_b/3*2;
    for i=1:NB
        c_p_b1(i)=(p_b_e1(i)^2-0)/(Smax_b(i)/3);
    end
    for i=1:NB
        c_p_b2(i)=(p_b_e2(i)^2-p_b_e1(i)^2)/(Smax_b(i)/3);
    end
    for i=1:NB
        c_p_b3(i)=(Smax_b(i)^2-(p_b_e2(i))^2)/(Smax_b(i)/3);
    end
    % calculation P_b^2
    C_P_b1=zeros(NB*NT,1);% 
    for t=1:NT
         C_P_b1((t-1)*NB+1:t*NB)=c_p_b1;
    end
    C_P_b2=zeros(NB*NT,1);%
    for t=1:NT
         C_P_b2((t-1)*NB+1:t*NB)=c_p_b2;
    end
    C_P_b3=zeros(NB*NT,1);% 
    for t=1:NT
         C_P_b3((t-1)*NB+1:t*NB)=c_p_b3;
    end
	catch Me
			disp('EMS Grid Connected_Calculation of P_b Q_b')
			disp(Me.message)   
			ignore_results = 1;  
			       
	end;
end;

if ignore_results == 0
	try
		%demand charge
		%   P1,                     P2,                 P3,                    P_g,            u_g,            SC_g,             Q_g,            Q_g1,         Q_g2,          Q_g3,         P_b_c,          P_b_dc,   u_b_c, u_b_dc,     SOC_b,       Q_b,         Q_b1,          Q_b2,           Q_b3,           P_b1,         P_b2,          P_b3,                 P_pcc,                      P_pcc_peak,        Q_pcc,       Q_pcc_ab,
		f=[MC_1*Cost_Indicator;MC_2*Cost_Indicator;MC_3*Cost_Indicator;zeros(NT*NG,1);NLC*Cost_Indicator;K_sc*Cost_Indicator;zeros(NT*NG,1);zeros(NT*NG,1);zeros(NT*NG,1);zeros(NT*NG,1);zeros(NT*NB,1);zeros(NT*NB,1);C_B_c;C_B_dc;zeros(NT*NB,1);zeros(NT*NB,1);zeros(NT*NB,1);zeros(NT*NB,1);zeros(NT*NB,1);zeros(NT*NB,1);zeros(NT*NB,1);zeros(NT*NB,1);DA_price*del_t*Cost_Indicator;Dmd_Crg*Dmd_Crg_Indicator;zeros(NT,1);ones(NT,1)*PF_Indicator;...
		   ones(NT*NN,1)*Voltage_Indicator;zeros(NT*NN,1);zeros(NT*NC,1);C_P_f1*Loss_Indicator;C_P_f2*Loss_Indicator;C_P_f3*Loss_Indicator;zeros(NT*NC,1);C_Q_f1*Loss_Indicator;C_Q_f2*Loss_Indicator;C_Q_f3*Loss_Indicator;zeros(NT*NN,1);zeros(NT*NN,1)]; % cost coefficient
		%  Aux_v_n,                              v_n,          P_f,            P_f1,                P_f2,                   P_f3,               Q_f,            Q_f1,                 Q_f2,                Q_f3,               P_n,           Q_n
	catch Me
    		disp('EMS Grid Connected_objective function')
			disp(Me.message)   
			ignore_results = 1;  
	end;			
end;

if ignore_results == 0
	try 
		%% bound definitions
		%%%---lower bound---%%%
		P1_lb=zeros(NT*NG,1);
		P2_lb=zeros(NT*NG,1);
		P3_lb=zeros(NT*NG,1);
		P_g_lb=zeros(NT*NG,1);
		u_g_lb=zeros(NT*NG,1);
		SC_g_lb=zeros(NT*NG,1);
		Q_g_lb=zeros(NT*NG,1);% 
		for t=1:NT
			 Q_g_lb((t-1)*NG+1:t*NG)=-Smax_g;
		end
		Q_g1_lb=zeros(NT*NG,1);
		Q_g2_lb=zeros(NT*NG,1);
		Q_g3_lb=zeros(NT*NG,1);
		P_b_c_lb=zeros(NT*NB,1);
		P_b_dc_lb=zeros(NT*NB,1);
		u_b_c_lb=zeros(NT*NB,1);
		u_b_dc_lb=zeros(NT*NB,1);
		SOC_lb=zeros(NT*NB,1);
		for t=1:NT-1
			 SOC_lb((t-1)*NB+1:t*NB)=SOC_min;
		end
		SOC_lb((NT-1)*NB+1:end)=SOCend;
		Q_b_lb=zeros(NT*NB,1);
		for t=1:NT
			 Q_b_lb((t-1)*NB+1:t*NB)=-Smax_b;
		end
		Q_b1_lb=zeros(NT*NB,1);
		Q_b2_lb=zeros(NT*NB,1);
		Q_b3_lb=zeros(NT*NB,1);
		P_b1_lb=zeros(NT*NB,1);
		P_b2_lb=zeros(NT*NB,1);
		P_b3_lb=zeros(NT*NB,1);
		P_pcc_lb=-1*ones(NT,1)*Cables(1,5);
		if Commit_Indicator==1
		   for i=1:NT
			   if isnan(DA_commit_P(i))
				   P_pcc_lb(i)=-1*Cables(1,5);
			   else
				   P_pcc_lb(i)=DA_commit_P(i);
			   end
			end
		end
		P_pcc_peak_lb=0;
		Q_pcc_lb=-1*ones(NT,1)*Cables(1,5);
		if Commit_Indicator==1
		   for i=1:NT
			   if isnan(DA_commit_Q(i))
				   Q_pcc_lb(i)=-1*Cables(1,5);
			   else
				   Q_pcc_lb(i)=DA_commit_Q(i);
			   end
			end
		end
		Q_pcc_ab_lb=zeros(NT,1);
		Aux_v_n_lb=zeros(NT*NN,1);
		v_n_lb=ones(NT*NN,1)*0.95^2;
		P_f_lb=zeros(NT*NC,1);
		for t=1:NT
			 P_f_lb((t-1)*NC+1:t*NC)=-Cables(:,5);
		end
		P_f1_lb=zeros(NT*NC,1);
		P_f2_lb=zeros(NT*NC,1);
		P_f3_lb=zeros(NT*NC,1);
		Q_f_lb=zeros(NT*NC,1);
		for t=1:NT
			 Q_f_lb((t-1)*NC+1:t*NC)=-Cables(:,5);
		end
		Q_f1_lb=zeros(NT*NC,1);
		Q_f2_lb=zeros(NT*NC,1);
		Q_f3_lb=zeros(NT*NC,1);
		P_n_lb=-1*ones(NT*NN,1)*large_number;
		Q_n_lb=-1*ones(NT*NN,1)*large_number;

		lb=[P1_lb;P2_lb;P3_lb;P_g_lb;u_g_lb;SC_g_lb;Q_g_lb;Q_g1_lb;Q_g2_lb;Q_g3_lb;P_b_c_lb;P_b_dc_lb;u_b_c_lb;u_b_dc_lb;SOC_lb;Q_b_lb;Q_b1_lb;Q_b2_lb;Q_b3_lb;P_b1_lb;P_b2_lb;P_b3_lb;P_pcc_lb;P_pcc_peak_lb;...
			Q_pcc_lb;Q_pcc_ab_lb;Aux_v_n_lb;v_n_lb;P_f_lb;P_f1_lb;P_f2_lb;P_f3_lb;Q_f_lb;Q_f1_lb;Q_f2_lb;Q_f3_lb;P_n_lb;Q_n_lb];

		%%%---upper bound---%%%

		P1_ub=zeros(NT*NG,1);
		for t=1:NT
			 P1_ub((t-1)*NG+1:t*NG)=e1-Pmin_g;
		end
		P2_ub=zeros(NT*NG,1);
		for t=1:NT
			 P2_ub((t-1)*NG+1:t*NG)=e2-e1;
		end
		P3_ub=zeros(NT*NG,1);
		for t=1:NT
			 P3_ub((t-1)*NG+1:t*NG)=Pmax_g-e2;
		end
		P_g_ub=zeros(NT*NG,1);
		for t=1:NT
			 P_g_ub((t-1)*NG+1:t*NG)=Pmax_g;
		end
		u_g_ub=ones(NT*NG,1);
		SC_g_ub=ones(NT*NG,1);
		Q_g_ub=zeros(NT*NG,1);% 
		for t=1:NT
			 Q_g_ub((t-1)*NG+1:t*NG)=Smax_g;
		end
		Q_g1_ub=zeros(NT*NG,1);
		for t=1:NT
			 Q_g1_ub((t-1)*NG+1:t*NG)=q_g_e1;
		end
		Q_g2_ub=zeros(NT*NG,1);
		for t=1:NT
			 Q_g2_ub((t-1)*NG+1:t*NG)=q_g_e2-q_g_e1;
		end
		Q_g3_ub=zeros(NT*NG,1);
		for t=1:NT
			 Q_g3_ub((t-1)*NG+1:t*NG)=Smax_g-q_g_e2;
		end

		P_b_c_ub=zeros(NT*NB,1);
		for t=1:NT
			P_b_c_ub((t-1)*NB+1:t*NB)=Smax_b;
		end
		P_b_dc_ub=P_b_c_ub;
		u_b_c_ub=ones(NT*NB,1);
		u_b_dc_ub=ones(NT*NB,1);
		SOC_ub=zeros(NT*NB,1);
		for t=1:NT-1
			 SOC_ub((t-1)*NB+1:t*NB)=SOC_max;
		end
		SOC_ub((NT-1)*NB+1:end)=SOCend;
		Q_b_ub=P_b_c_ub;
		Q_b1_ub=zeros(NT*NB,1);
		for t=1:NT
			 Q_b1_ub((t-1)*NB+1:t*NB)=q_b_e1;
		end
		Q_b2_ub=zeros(NT*NB,1);
		for t=1:NT
			 Q_b2_ub((t-1)*NB+1:t*NB)=q_b_e2-q_b_e1;
		end
		Q_b3_ub=zeros(NT*NB,1);
		for t=1:NT
			 Q_b3_ub((t-1)*NB+1:t*NB)=Smax_b-q_b_e2;
		end
		P_b1_ub=Q_b1_ub;
		P_b2_ub=Q_b2_ub;
		P_b3_ub=Q_b3_ub;
		P_pcc_ub=ones(NT,1)*Cables(1,5);
		if Commit_Indicator==1
		   for i=1:NT
			   if isnan(DA_commit_P(i))
				   P_pcc_ub(i)=Cables(1,5);
			   else
				   P_pcc_ub(i)=DA_commit_P(i);
			   end
			end
		end
		P_pcc_peak_ub=Cables(1,5);
		Q_pcc_ub=ones(NT,1)*Cables(1,5);
		if Commit_Indicator==1
		   for i=1:NT
			   if isnan(DA_commit_Q(i))
				   Q_pcc_ub(i)=Cables(1,5);
			   else
				   Q_pcc_ub(i)=DA_commit_Q(i);
			   end
			end
		end
		Q_pcc_ab_ub=ones(NT,1)*Cables(1,5);

		Aux_v_n_ub=ones(NT*NN,1);
		v_n_ub=ones(NT*NN,1)*1.05^2;
		P_f_ub=-P_f_lb;
		P_f1_ub=zeros(NT*NC,1);
		for t=1:NT
			 P_f1_ub((t-1)*NC+1:t*NC)=p_f_e1;
		end
		P_f2_ub=zeros(NT*NC,1);
		for t=1:NT
			 P_f2_ub((t-1)*NC+1:t*NC)=p_f_e2-p_f_e1;
		end
		P_f3_ub=zeros(NT*NC,1);
		for t=1:NT
			 P_f3_ub((t-1)*NC+1:t*NC)=Cables(:,5)-p_f_e2;
		end
		Q_f_ub=-Q_f_lb;
		Q_f1_ub=zeros(NT*NC,1);
		for t=1:NT
			 Q_f1_ub((t-1)*NC+1:t*NC)=q_f_e1;
		end
		Q_f2_ub=zeros(NT*NC,1);
		for t=1:NT
			 Q_f2_ub((t-1)*NC+1:t*NC)=q_f_e2-q_f_e1;
		end
		Q_f3_ub=zeros(NT*NC,1);
		for t=1:NT
			 Q_f3_ub((t-1)*NC+1:t*NC)=Cables(:,5)-q_f_e2;
		end
		P_n_ub=ones(NT*NN,1)*large_number;
		Q_n_ub=ones(NT*NN,1)*large_number;

		ub=[P1_ub;P2_ub;P3_ub;P_g_ub;u_g_ub;SC_g_ub;Q_g_ub;Q_g1_ub;Q_g2_ub;Q_g3_ub;P_b_c_ub;P_b_dc_ub;u_b_c_ub;u_b_dc_ub;SOC_ub;Q_b_ub;Q_b1_ub;Q_b2_ub;Q_b3_ub;P_b1_ub;P_b2_ub;P_b3_ub;P_pcc_ub;P_pcc_peak_ub;...
			Q_pcc_ub;Q_pcc_ab_ub;Aux_v_n_ub;v_n_ub;P_f_ub;P_f1_ub;P_f2_ub;P_f3_ub;Q_f_ub;Q_f1_ub;Q_f2_ub;Q_f3_ub;P_n_ub;Q_n_ub];
	catch Me
		disp('EMS Grid Connected_Defining Bounds')
		disp(Me.message)   
		ignore_results = 1;            
	end;
end;

if ignore_results == 0
	try
		%% Equality
		%--- 1) Pit=P_1it+P_2it+P_3it+Pmin*Uit
		Aeq1_P1=sparse(diag(ones(NT*NG,1)));
		Aeq1_P2=sparse(diag(ones(NT*NG,1)));
		Aeq1_P3=sparse(diag(ones(NT*NG,1)));
		Aeq1_P=sparse(-1*diag(ones(NT*NG,1)));
		Aeq1_U_vec=zeros(NT*NG,1);
		for t=1:NT
			 Aeq1_U_vec((t-1)*NG+1:t*NG)=Pmin_g;
		end
		Aeq1_U=sparse(diag(Aeq1_U_vec));
		Aeq1_SC=sparse(zeros(NT*NG,NT*NG));
		Aeq1_Q_g=sparse(zeros(NT*NG,NT*NG));% 
		Aeq1_Q_g1=sparse(zeros(NT*NG,NT*NG));% 
		Aeq1_Q_g2=sparse(zeros(NT*NG,NT*NG));% 
		Aeq1_Q_g3=sparse(zeros(NT*NG,NT*NG));% 
		Aeq1_P_b_c=sparse(zeros(NT*NG,NT*NB));
		Aeq1_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		Aeq1_u_b_c=sparse(zeros(NT*NG,NT*NB));
		Aeq1_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		Aeq1_SOC=sparse(zeros(NT*NG,NT*NB));
		Aeq1_Q_b=sparse(zeros(NT*NG,NT*NB));
		Aeq1_Q_b1=sparse(zeros(NT*NG,NT*NB));
		Aeq1_Q_b2=sparse(zeros(NT*NG,NT*NB));
		Aeq1_Q_b3=sparse(zeros(NT*NG,NT*NB));
		Aeq1_P_b1=sparse(zeros(NT*NG,NT*NB));
		Aeq1_P_b2=sparse(zeros(NT*NG,NT*NB));
		Aeq1_P_b3=sparse(zeros(NT*NG,NT*NB));
		Aeq1_P_pcc=sparse(zeros(NT*NG,NT));
		Aeq1_P_pcc_peak=sparse(zeros(NT*NG,1));
		Aeq1_Q_pcc=sparse(zeros(NT*NG,NT));
		Aeq1_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		Aeq1_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		Aeq1_v_n=sparse(zeros(NT*NG,NT*NN));
		Aeq1_P_f=sparse(zeros(NT*NG,NT*NC));
		Aeq1_P_f1=sparse(zeros(NT*NG,NT*NC));
		Aeq1_P_f2=sparse(zeros(NT*NG,NT*NC));
		Aeq1_P_f3=sparse(zeros(NT*NG,NT*NC));
		Aeq1_Q_f=sparse(zeros(NT*NG,NT*NC));
		Aeq1_Q_f1=sparse(zeros(NT*NG,NT*NC));
		Aeq1_Q_f2=sparse(zeros(NT*NG,NT*NC));
		Aeq1_Q_f3=sparse(zeros(NT*NG,NT*NC));
		Aeq1_P_n=sparse(zeros(NT*NG,NT*NN));
		Aeq1_Q_n=sparse(zeros(NT*NG,NT*NN));
		Aeq1=sparse([Aeq1_P1,Aeq1_P2,Aeq1_P3,Aeq1_P,Aeq1_U,Aeq1_SC,Aeq1_Q_g,Aeq1_Q_g1,Aeq1_Q_g2,Aeq1_Q_g3,Aeq1_P_b_c,Aeq1_P_b_dc,Aeq1_u_b_c,Aeq1_u_b_dc,Aeq1_SOC,Aeq1_Q_b,Aeq1_Q_b1,Aeq1_Q_b2,Aeq1_Q_b3,Aeq1_P_b1,Aeq1_P_b2,Aeq1_P_b3,...
					 Aeq1_P_pcc,Aeq1_P_pcc_peak,Aeq1_Q_pcc,Aeq1_Q_pcc_ab,Aeq1_Aux_v_n,Aeq1_v_n,Aeq1_P_f,Aeq1_P_f1,Aeq1_P_f2,Aeq1_P_f3,Aeq1_Q_f,Aeq1_Q_f1,Aeq1_Q_f2,Aeq1_Q_f3,Aeq1_P_n,Aeq1_Q_n]);
		beq1=zeros(NT*NG,1);
		clear Aeq1_P1;clear Aeq1_P2;clear Aeq1_P3;clear Aeq1_P;clear Aeq1_U;clear Aeq1_SC;clear Aeq1_Q_g;clear Aeq1_Q_g1;clear Aeq1_Q_g2;clear Aeq1_Q_g3;clear Aeq1_P_b_c;clear Aeq1_P_b_dc;clear Aeq1_u_b_c;clear Aeq1_u_b_dc;clear Aeq1_SOC;
		clear Aeq1_Q_b;clear Aeq1_Q_b1;clear Aeq1_Q_b2;clear  Aeq1_Q_b3;clear Aeq1_P_b1;clear Aeq1_P_b2;clear Aeq1_P_b3;clear Aeq1_P_pcc;clear Aeq1_P_pcc_peak;clear Aeq1_Q_pcc;clear Aeq1_Q_pcc_ab;
		clear Aeq1_Aux_v_n;clear Aeq1_v_n;clear Aeq1_P_f;clear Aeq1_P_f1;clear Aeq1_P_f2;clear Aeq1_P_f3;clear Aeq1_Q_f;clear Aeq1_Q_f1;clear Aeq1_Q_f2;clear Aeq1_Q_f3;clear Aeq1_P_n;clear Aeq1_Q_n;

		%--- 2) SOC(t)=SOC(t-1)+P_b_c*yita*del_t-P_b_dc/yita*del_t  for all t  
		Aeq2_P1=sparse(zeros(NT*NB,NT*NG));
		Aeq2_P2=sparse(zeros(NT*NB,NT*NG));
		Aeq2_P3=sparse(zeros(NT*NB,NT*NG));
		Aeq2_P=sparse(zeros(NT*NB,NT*NG));
		Aeq2_U=sparse(zeros(NT*NB,NT*NG));
		Aeq2_SC=sparse(zeros(NT*NB,NT*NG));
		Aeq2_Q_g=sparse(zeros(NT*NB,NT*NG));
		Aeq2_Q_g1=sparse(zeros(NT*NB,NT*NG));
		Aeq2_Q_g2=sparse(zeros(NT*NB,NT*NG)); 
		Aeq2_Q_g3=sparse(zeros(NT*NB,NT*NG));% 
		Aeq2_P_b_c_vec=zeros(NT*NB,1);
		for t=1:NT
			 Aeq2_P_b_c_vec((t-1)*NB+1:t*NB)=-1*yita_ch*del_t;
		end
		Aeq2_P_b_c=sparse(diag(Aeq2_P_b_c_vec));
		Aeq2_P_b_dc_vec=zeros(NT*NB,1);
		for t=1:NT
			 Aeq2_P_b_dc_vec((t-1)*NB+1:t*NB)=1./yita_dch*del_t;
		end
		Aeq2_P_b_dc=sparse(diag(Aeq2_P_b_dc_vec));
		Aeq2_u_b_c=sparse(zeros(NT*NB,NT*NB));
		Aeq2_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		Aeq2_SOC=diag(ones(NT*NB,1));
		for i=1:(NT-1)*NB
			Aeq2_SOC(i+NB,i)=-1;
		end
		Aeq2_SOC=sparse(Aeq2_SOC);
		Aeq2_Q_b=sparse(zeros(NT*NB,NT*NB));
		Aeq2_Q_b1=sparse(zeros(NT*NB,NT*NB));
		Aeq2_Q_b2=sparse(zeros(NT*NB,NT*NB));
		Aeq2_Q_b3=sparse(zeros(NT*NB,NT*NB));
		Aeq2_P_b1=sparse(zeros(NT*NB,NT*NB));
		Aeq2_P_b2=sparse(zeros(NT*NB,NT*NB));
		Aeq2_P_b3=sparse(zeros(NT*NB,NT*NB));
		Aeq2_P_pcc=sparse(zeros(NT*NB,NT));
		Aeq2_P_pcc_peak=sparse(zeros(NT*NB,1));
		Aeq2_Q_pcc=sparse(zeros(NT*NB,NT));
		Aeq2_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		Aeq2_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		Aeq2_v_n=sparse(zeros(NT*NB,NT*NN));
		Aeq2_P_f=sparse(zeros(NT*NB,NT*NC));
		Aeq2_P_f1=sparse(zeros(NT*NB,NT*NC));
		Aeq2_P_f2=sparse(zeros(NT*NB,NT*NC));
		Aeq2_P_f3=sparse(zeros(NT*NB,NT*NC));
		Aeq2_Q_f=sparse(zeros(NT*NB,NT*NC));
		Aeq2_Q_f1=sparse(zeros(NT*NB,NT*NC));
		Aeq2_Q_f2=sparse(zeros(NT*NB,NT*NC));
		Aeq2_Q_f3=sparse(zeros(NT*NB,NT*NC));
		Aeq2_P_n=sparse(zeros(NT*NB,NT*NN));
		Aeq2_Q_n=sparse(zeros(NT*NB,NT*NN));
		Aeq2=sparse([Aeq2_P1,Aeq2_P2,Aeq2_P3,Aeq2_P,Aeq2_U,Aeq2_SC,Aeq2_Q_g,Aeq2_Q_g1,Aeq2_Q_g2,Aeq2_Q_g3,Aeq2_P_b_c,Aeq2_P_b_dc,Aeq2_u_b_c,Aeq2_u_b_dc,Aeq2_SOC,Aeq2_Q_b,Aeq2_Q_b1,Aeq2_Q_b2,Aeq2_Q_b3,Aeq2_P_b1,Aeq2_P_b2,Aeq2_P_b3,...
					 Aeq2_P_pcc,Aeq2_P_pcc_peak,Aeq2_Q_pcc,Aeq2_Q_pcc_ab,Aeq2_Aux_v_n,Aeq2_v_n,Aeq2_P_f,Aeq2_P_f1,Aeq2_P_f2,Aeq2_P_f3,Aeq2_Q_f,Aeq2_Q_f1,Aeq2_Q_f2,Aeq2_Q_f3,Aeq2_P_n,Aeq2_Q_n]);
		beq2=[SOC0;zeros((NT-1)*NB,1)];
		clear Aeq2_P1;clear Aeq2_P2;clear Aeq2_P3;clear Aeq2_P;clear Aeq2_U;clear Aeq2_SC;clear Aeq2_Q_g;clear Aeq2_Q_g1;clear Aeq2_Q_g2;clear Aeq2_Q_g3;clear Aeq2_P_b_c;clear Aeq2_P_b_dc;clear Aeq2_u_b_c;clear Aeq2_u_b_dc;clear Aeq2_SOC;
		clear Aeq2_Q_b;clear Aeq2_Q_b1;clear Aeq2_Q_b2;clear  Aeq2_Q_b3;clear Aeq2_P_b1;clear Aeq2_P_b2;clear Aeq2_P_b3;clear Aeq2_P_pcc;clear Aeq2_P_pcc_peak;clear Aeq2_Q_pcc;clear Aeq2_Q_pcc_ab;
		clear Aeq2_Aux_v_n;clear Aeq2_v_n;clear Aeq2_P_f;clear Aeq2_P_f1;clear Aeq2_P_f2;clear Aeq2_P_f3;clear Aeq2_Q_f;clear Aeq2_Q_f1;clear Aeq2_Q_f2;clear Aeq2_Q_f3;clear Aeq2_P_n;clear Aeq2_Q_n;

		%--- 3) v_n^2-v_n+1^2=2(r_f*P_ft+x_f*Q_ft)  for all t  
		Aeq3_P1=sparse(zeros(NT*NC,NT*NG));
		Aeq3_P2=sparse(zeros(NT*NC,NT*NG));
		Aeq3_P3=sparse(zeros(NT*NC,NT*NG));
		Aeq3_P=sparse(zeros(NT*NC,NT*NG));
		Aeq3_U=sparse(zeros(NT*NC,NT*NG));
		Aeq3_SC=sparse(zeros(NT*NC,NT*NG));
		Aeq3_Q_g=sparse(zeros(NT*NC,NT*NG));
		Aeq3_Q_g1=sparse(zeros(NT*NC,NT*NG));
		Aeq3_Q_g2=sparse(zeros(NT*NC,NT*NG)); 
		Aeq3_Q_g3=sparse(zeros(NT*NC,NT*NG));% 
		Aeq3_P_b_c=sparse(zeros(NT*NC,NT*NB));
		Aeq3_P_b_dc=sparse(zeros(NT*NC,NT*NB));
		Aeq3_u_b_c=sparse(zeros(NT*NC,NT*NB));
		Aeq3_u_b_dc=sparse(zeros(NT*NC,NT*NB));
		Aeq3_SOC=sparse(zeros(NT*NC,NT*NB));
		Aeq3_Q_b=sparse(zeros(NT*NC,NT*NB));
		Aeq3_Q_b1=sparse(zeros(NT*NC,NT*NB));
		Aeq3_Q_b2=sparse(zeros(NT*NC,NT*NB));
		Aeq3_Q_b3=sparse(zeros(NT*NC,NT*NB));
		Aeq3_P_b1=sparse(zeros(NT*NC,NT*NB));
		Aeq3_P_b2=sparse(zeros(NT*NC,NT*NB));
		Aeq3_P_b3=sparse(zeros(NT*NC,NT*NB));
		Aeq3_P_pcc=sparse(zeros(NT*NC,NT));
		Aeq3_P_pcc_peak=sparse(zeros(NT*NC,1));
		Aeq3_Q_pcc=sparse(zeros(NT*NC,NT));
		Aeq3_Q_pcc_ab=sparse(zeros(NT*NC,NT));
		Aeq3_Aux_v_n=sparse(zeros(NT*NC,NT*NN));
		Aeq3_v_n=zeros(NT*NC,NT*NN);
		Aeq3_v_n_sq=zeros(NC,NN);
		for i=1:NC
			Aeq3_v_n_sq(i,Cables(i,2))=1; 
			Aeq3_v_n_sq(i,Cables(i,3))=-1;
		end
		for t=1:NT
			Aeq3_v_n((t-1)*NC+1:t*NC,(t-1)*NN+1:t*NN)=Aeq3_v_n_sq; 
		end
		Aeq3_v_n=sparse(Aeq3_v_n);
		Aeq3_P_f_vec=zeros(NT*NC,1);
		for t=1:NT
			Aeq3_P_f_vec((t-1)*NC+1:t*NC)=-2*Cables(:,6);
		end
		Aeq3_P_f=sparse(diag(Aeq3_P_f_vec));
		Aeq3_P_f1=sparse(zeros(NT*NC,NT*NC));
		Aeq3_P_f2=sparse(zeros(NT*NC,NT*NC));
		Aeq3_P_f3=sparse(zeros(NT*NC,NT*NC));
		Aeq3_Q_f_vec=zeros(NT*NC,1);
		for t=1:NT
			Aeq3_Q_f_vec((t-1)*NC+1:t*NC)=-2*Cables(:,7);
		end
		Aeq3_Q_f=sparse(diag(Aeq3_Q_f_vec));
		Aeq3_Q_f1=sparse(zeros(NT*NC,NT*NC));
		Aeq3_Q_f2=sparse(zeros(NT*NC,NT*NC));
		Aeq3_Q_f3=sparse(zeros(NT*NC,NT*NC));
		Aeq3_P_n=sparse(zeros(NT*NC,NT*NN));
		Aeq3_Q_n=sparse(zeros(NT*NC,NT*NN));
		Aeq3=sparse([Aeq3_P1,Aeq3_P2,Aeq3_P3,Aeq3_P,Aeq3_U,Aeq3_SC,Aeq3_Q_g,Aeq3_Q_g1,Aeq3_Q_g2,Aeq3_Q_g3,Aeq3_P_b_c,Aeq3_P_b_dc,Aeq3_u_b_c,Aeq3_u_b_dc,Aeq3_SOC,Aeq3_Q_b,Aeq3_Q_b1,Aeq3_Q_b2,Aeq3_Q_b3,Aeq3_P_b1,Aeq3_P_b2,Aeq3_P_b3,...
					 Aeq3_P_pcc,Aeq3_P_pcc_peak,Aeq3_Q_pcc,Aeq3_Q_pcc_ab,Aeq3_Aux_v_n,Aeq3_v_n,Aeq3_P_f,Aeq3_P_f1,Aeq3_P_f2,Aeq3_P_f3,Aeq3_Q_f,Aeq3_Q_f1,Aeq3_Q_f2,Aeq3_Q_f3,Aeq3_P_n,Aeq3_Q_n]);
		beq3=zeros(NT*NC,1);
		clear Aeq3_P1;clear Aeq3_P2;clear Aeq3_P3;clear Aeq3_P;clear Aeq3_U;clear Aeq3_SC;clear Aeq3_Q_g;clear Aeq3_Q_g1;clear Aeq3_Q_g2;clear Aeq3_Q_g3;clear Aeq3_P_b_c;clear Aeq3_P_b_dc;clear Aeq3_u_b_c;clear Aeq3_u_b_dc;clear Aeq3_SOC;
		clear Aeq3_Q_b;clear Aeq3_Q_b1;clear Aeq3_Q_b2;clear  Aeq3_Q_b3;clear Aeq3_P_b1;clear Aeq3_P_b2;clear Aeq3_P_b3;clear Aeq3_P_pcc;clear Aeq3_P_pcc_peak;clear Aeq3_Q_pcc;clear Aeq3_Q_pcc_ab;
		clear Aeq3_Aux_v_n;clear Aeq3_v_n;clear Aeq3_P_f;clear Aeq3_P_f1;clear Aeq3_P_f2;clear Aeq3_P_f3;clear Aeq3_Q_f;clear Aeq3_Q_f1;clear Aeq3_Q_f2;clear Aeq3_Q_f3;clear Aeq3_P_n;clear Aeq3_Q_n;

		%--- 4) A*Pf=P_n  for all t  
		Aeq4_P1=sparse(zeros(NT*NN,NT*NG));
		Aeq4_P2=sparse(zeros(NT*NN,NT*NG));
		Aeq4_P3=sparse(zeros(NT*NN,NT*NG));
		Aeq4_P=sparse(zeros(NT*NN,NT*NG));
		Aeq4_U=sparse(zeros(NT*NN,NT*NG));
		Aeq4_SC=sparse(zeros(NT*NN,NT*NG));
		Aeq4_Q_g=sparse(zeros(NT*NN,NT*NG));
		Aeq4_Q_g1=sparse(zeros(NT*NN,NT*NG));
		Aeq4_Q_g2=sparse(zeros(NT*NN,NT*NG)); 
		Aeq4_Q_g3=sparse(zeros(NT*NN,NT*NG));% 
		Aeq4_P_b_c=sparse(zeros(NT*NN,NT*NB));
		Aeq4_P_b_dc=sparse(zeros(NT*NN,NT*NB));
		Aeq4_u_b_c=sparse(zeros(NT*NN,NT*NB));
		Aeq4_u_b_dc=sparse(zeros(NT*NN,NT*NB));
		Aeq4_SOC=sparse(zeros(NT*NN,NT*NB));
		Aeq4_Q_b=sparse(zeros(NT*NN,NT*NB));
		Aeq4_Q_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq4_Q_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq4_Q_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq4_P_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq4_P_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq4_P_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq4_P_pcc=sparse(zeros(NT*NN,NT));
		Aeq4_P_pcc_peak=sparse(zeros(NT*NN,1));
		Aeq4_Q_pcc=sparse(zeros(NT*NN,NT));
		Aeq4_Q_pcc_ab=sparse(zeros(NT*NN,NT));
		Aeq4_Aux_v_n=sparse(zeros(NT*NN,NT*NN));
		Aeq4_v_n=sparse(zeros(NT*NN,NT*NN));

		Aeq4_P_f_sq=zeros(NN,NC);
		for i=1:NC
			Aeq4_P_f_sq(i+1,i)=1;
		end
		for i=1:NN
			temp_connect=find(Cables(:,2)==i);
			if ~isempty(temp_connect)    
				for n=1:length(temp_connect)        
					Aeq4_P_f_sq(i,temp_connect(n))=-1; 
				end       
			end 
		end
		for t=1:NT
			Aeq4_P_f((t-1)*NN+1:t*NN,(t-1)*NC+1:t*NC)=Aeq4_P_f_sq; 
		end
		Aeq4_P_f=sparse(Aeq4_P_f);
		Aeq4_P_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq4_P_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq4_P_f3=sparse(zeros(NT*NN,NT*NC));
		Aeq4_Q_f=sparse(zeros(NT*NN,NT*NC));
		Aeq4_Q_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq4_Q_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq4_Q_f3=sparse(zeros(NT*NN,NT*NC));
		Aeq4_P_n=sparse(diag(ones(NT*NN,1)));
		Aeq4_Q_n=sparse(zeros(NT*NN,NT*NN));
		Aeq4=sparse([Aeq4_P1,Aeq4_P2,Aeq4_P3,Aeq4_P,Aeq4_U,Aeq4_SC,Aeq4_Q_g,Aeq4_Q_g1,Aeq4_Q_g2,Aeq4_Q_g3,Aeq4_P_b_c,Aeq4_P_b_dc,Aeq4_u_b_c,Aeq4_u_b_dc,Aeq4_SOC,Aeq4_Q_b,Aeq4_Q_b1,Aeq4_Q_b2,Aeq4_Q_b3,Aeq4_P_b1,Aeq4_P_b2,Aeq4_P_b3,...
					 Aeq4_P_pcc,Aeq4_P_pcc_peak,Aeq4_Q_pcc,Aeq4_Q_pcc_ab,Aeq4_Aux_v_n,Aeq4_v_n,Aeq4_P_f,Aeq4_P_f1,Aeq4_P_f2,Aeq4_P_f3,Aeq4_Q_f,Aeq4_Q_f1,Aeq4_Q_f2,Aeq4_Q_f3,Aeq4_P_n,Aeq4_Q_n]);
		beq4=zeros(NT*NN,1);
		clear Aeq4_P1;clear Aeq4_P2;clear Aeq4_P3;clear Aeq4_P;clear Aeq4_U;clear Aeq4_SC;clear Aeq4_Q_g;clear Aeq4_Q_g1;clear Aeq4_Q_g2;clear Aeq4_Q_g3;clear Aeq4_P_b_c;clear Aeq4_P_b_dc;clear Aeq4_u_b_c;clear Aeq4_u_b_dc;clear Aeq4_SOC;
		clear Aeq4_Q_b;clear Aeq4_Q_b1;clear Aeq4_Q_b2;clear  Aeq4_Q_b3;clear Aeq4_P_b1;clear Aeq4_P_b2;clear Aeq4_P_b3;clear Aeq4_P_pcc;clear Aeq4_P_pcc_peak;clear Aeq4_Q_pcc;clear Aeq4_Q_pcc_ab;
		clear Aeq4_Aux_v_n;clear Aeq4_v_n;clear Aeq4_P_f;clear Aeq4_P_f1;clear Aeq4_P_f2;clear Aeq4_P_f3;clear Aeq4_Q_f;clear Aeq4_Q_f1;clear Aeq4_Q_f2;clear Aeq4_Q_f3;clear Aeq4_P_n;clear Aeq4_Q_n;

		%--- 5) A*Qf=Q_n  for all t  
		Aeq5_P1=sparse(zeros(NT*NN,NT*NG));
		Aeq5_P2=sparse(zeros(NT*NN,NT*NG));
		Aeq5_P3=sparse(zeros(NT*NN,NT*NG));
		Aeq5_P=sparse(zeros(NT*NN,NT*NG));
		Aeq5_U=sparse(zeros(NT*NN,NT*NG));
		Aeq5_SC=sparse(zeros(NT*NN,NT*NG));
		Aeq5_Q_g=sparse(zeros(NT*NN,NT*NG));
		Aeq5_Q_g1=sparse(zeros(NT*NN,NT*NG));
		Aeq5_Q_g2=sparse(zeros(NT*NN,NT*NG)); 
		Aeq5_Q_g3=sparse(zeros(NT*NN,NT*NG));% 
		Aeq5_P_b_c=sparse(zeros(NT*NN,NT*NB));
		Aeq5_P_b_dc=sparse(zeros(NT*NN,NT*NB));
		Aeq5_u_b_c=sparse(zeros(NT*NN,NT*NB));
		Aeq5_u_b_dc=sparse(zeros(NT*NN,NT*NB));
		Aeq5_SOC=sparse(zeros(NT*NN,NT*NB));
		Aeq5_Q_b=sparse(zeros(NT*NN,NT*NB));
		Aeq5_Q_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq5_Q_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq5_Q_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq5_P_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq5_P_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq5_P_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq5_P_pcc=sparse(zeros(NT*NN,NT));
		Aeq5_P_pcc_peak=sparse(zeros(NT*NN,1));
		Aeq5_Q_pcc=sparse(zeros(NT*NN,NT));
		Aeq5_Q_pcc_ab=sparse(zeros(NT*NN,NT));
		Aeq5_Aux_v_n=sparse(zeros(NT*NN,NT*NN));
		Aeq5_v_n=sparse(zeros(NT*NN,NT*NN));
		Aeq5_P_f=sparse(zeros(NT*NN,NT*NC));
		Aeq5_P_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq5_P_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq5_P_f3=sparse(zeros(NT*NN,NT*NC));

		Aeq5_Q_f_sq=zeros(NN,NC);
		for i=1:NC
			Aeq5_Q_f_sq(i+1,i)=1;
		end
		for i=1:NN
			temp_connect=find(Cables(:,2)==i);
			if ~isempty(temp_connect)    
				for n=1:length(temp_connect)        
					Aeq5_Q_f_sq(i,temp_connect(n))=-1; 
				end       
			end 
		end
		for t=1:NT
			Aeq5_Q_f((t-1)*NN+1:t*NN,(t-1)*NC+1:t*NC)=Aeq5_Q_f_sq; 
		end
		Aeq5_Q_f=sparse(Aeq5_Q_f);
		Aeq5_Q_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq5_Q_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq5_Q_f3=sparse(zeros(NT*NN,NT*NC));
		Aeq5_P_n=sparse(zeros(NT*NN,NT*NN));
		Aeq5_Q_n=sparse(diag(ones(NT*NN,1)));
		Aeq5=sparse([Aeq5_P1,Aeq5_P2,Aeq5_P3,Aeq5_P,Aeq5_U,Aeq5_SC,Aeq5_Q_g,Aeq5_Q_g1,Aeq5_Q_g2,Aeq5_Q_g3,Aeq5_P_b_c,Aeq5_P_b_dc,Aeq5_u_b_c,Aeq5_u_b_dc,Aeq5_SOC,Aeq5_Q_b,Aeq5_Q_b1,Aeq5_Q_b2,Aeq5_Q_b3,Aeq5_P_b1,Aeq5_P_b2,Aeq5_P_b3,...
					 Aeq5_P_pcc,Aeq5_P_pcc_peak,Aeq5_Q_pcc,Aeq5_Q_pcc_ab,Aeq5_Aux_v_n,Aeq5_v_n,Aeq5_P_f,Aeq5_P_f1,Aeq5_P_f2,Aeq5_P_f3,Aeq5_Q_f,Aeq5_Q_f1,Aeq5_Q_f2,Aeq5_Q_f3,Aeq5_P_n,Aeq5_Q_n]);
		beq5=zeros(NT*NN,1);
		clear Aeq5_P1;clear Aeq5_P2;clear Aeq5_P3;clear Aeq5_P;clear Aeq5_U;clear Aeq5_SC;clear Aeq5_Q_g;clear Aeq5_Q_g1;clear Aeq5_Q_g2;clear Aeq5_Q_g3;clear Aeq5_P_b_c;clear Aeq5_P_b_dc;clear Aeq5_u_b_c;clear Aeq5_u_b_dc;clear Aeq5_SOC;
		clear Aeq5_Q_b;clear Aeq5_Q_b1;clear Aeq5_Q_b2;clear  Aeq5_Q_b3;clear Aeq5_P_b1;clear Aeq5_P_b2;clear Aeq5_P_b3;clear Aeq5_P_pcc;clear Aeq5_P_pcc_peak;clear Aeq5_Q_pcc;clear Aeq5_Q_pcc_ab;
		clear Aeq5_Aux_v_n;clear Aeq5_v_n;clear Aeq5_P_f;clear Aeq5_P_f1;clear Aeq5_P_f2;clear Aeq5_P_f3;clear Aeq5_Q_f;clear Aeq5_Q_f1;clear Aeq5_Q_f2;clear Aeq5_Q_f3;clear Aeq5_P_n;clear Aeq5_Q_n;

		%--- 6) P_n=P_g+P_dch-P_ch-P_l+P_pv  for all t ,n 
		Aeq6_P1=sparse(zeros(NT*NN,NT*NG));
		Aeq6_P2=sparse(zeros(NT*NN,NT*NG));
		Aeq6_P3=sparse(zeros(NT*NN,NT*NG));
		Aeq6_P_sq=zeros(NN,NG);
		for i=1:NG
			Aeq6_P_sq(generators(i,2),i)=-1;
		end
		for t=1:NT
			Aeq6_P((t-1)*NN+1:t*NN,(t-1)*NG+1:t*NG)=Aeq6_P_sq; 
		end
		Aeq6_P=sparse(Aeq6_P);
		Aeq6_U=sparse(zeros(NT*NN,NT*NG));
		Aeq6_SC=sparse(zeros(NT*NN,NT*NG));
		Aeq6_Q_g=sparse(zeros(NT*NN,NT*NG));
		Aeq6_Q_g1=sparse(zeros(NT*NN,NT*NG));
		Aeq6_Q_g2=sparse(zeros(NT*NN,NT*NG)); 
		Aeq6_Q_g3=sparse(zeros(NT*NN,NT*NG));% 

		Aeq6_P_b_c_sq=zeros(NN,NB);
		for i=1:NB
			Aeq6_P_b_c_sq(batteries(i,2),i)=1;
		end
		for t=1:NT
			Aeq6_P_b_c((t-1)*NN+1:t*NN,(t-1)*NB+1:t*NB)= Aeq6_P_b_c_sq; 
		end
		Aeq6_P_b_c=sparse(Aeq6_P_b_c);

		Aeq6_P_b_dc_sq=zeros(NN,NB);
		for i=1:NB
			Aeq6_P_b_dc_sq(batteries(i,2),i)=-1;
		end
		for t=1:NT
			Aeq6_P_b_dc((t-1)*NN+1:t*NN,(t-1)*NB+1:t*NB)= Aeq6_P_b_dc_sq; 
		end
		Aeq6_P_b_dc=sparse(Aeq6_P_b_dc);

		Aeq6_u_b_c=sparse(zeros(NT*NN,NT*NB));
		Aeq6_u_b_dc=sparse(zeros(NT*NN,NT*NB));
		Aeq6_SOC=sparse(zeros(NT*NN,NT*NB));
		Aeq6_Q_b=sparse(zeros(NT*NN,NT*NB));
		Aeq6_Q_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq6_Q_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq6_Q_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq6_P_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq6_P_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq6_P_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq6_P_pcc=zeros(NT*NN,NT);
		for t=1:NT
			Aeq6_P_pcc((t-1)*NN+1,t)=-1;
		end
		Aeq6_P_pcc=sparse(Aeq6_P_pcc);
		Aeq6_P_pcc_peak=sparse(zeros(NT*NN,1));
		Aeq6_Q_pcc=sparse(zeros(NT*NN,NT));
		Aeq6_Q_pcc_ab=sparse(zeros(NT*NN,NT));
		Aeq6_Aux_v_n=sparse(zeros(NT*NN,NT*NN));
		Aeq6_v_n=sparse(zeros(NT*NN,NT*NN));
		Aeq6_P_f=sparse(zeros(NT*NN,NT*NC));
		Aeq6_P_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq6_P_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq6_P_f3=sparse(zeros(NT*NN,NT*NC));
		Aeq6_Q_f=sparse(zeros(NT*NN,NT*NC));
		Aeq6_Q_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq6_Q_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq6_Q_f3=sparse(zeros(NT*NN,NT*NC));
		Aeq6_P_n=sparse(diag(ones(NT*NN,1)));
		Aeq6_Q_n=sparse(zeros(NT*NN,NT*NN));
		Aeq6=sparse([Aeq6_P1,Aeq6_P2,Aeq6_P3,Aeq6_P,Aeq6_U,Aeq6_SC,Aeq6_Q_g,Aeq6_Q_g1,Aeq6_Q_g2,Aeq6_Q_g3,Aeq6_P_b_c,Aeq6_P_b_dc,Aeq6_u_b_c,Aeq6_u_b_dc,Aeq6_SOC,Aeq6_Q_b,Aeq6_Q_b1,Aeq6_Q_b2,Aeq6_Q_b3,Aeq6_P_b1,Aeq6_P_b2,Aeq6_P_b3,...
					 Aeq6_P_pcc,Aeq6_P_pcc_peak,Aeq6_Q_pcc,Aeq6_Q_pcc_ab,Aeq6_Aux_v_n,Aeq6_v_n,Aeq6_P_f,Aeq6_P_f1,Aeq6_P_f2,Aeq6_P_f3,Aeq6_Q_f,Aeq6_Q_f1,Aeq6_Q_f2,Aeq6_Q_f3,Aeq6_P_n,Aeq6_Q_n]);
		beq6=zeros(NT*NN,1);
		Temp_align_load=zeros(NN,NL);
		for i=1:NL
			Temp_align_load(loads_bus(i),i)=-1;
		end
		Temp_align_PV=zeros(NN,NPV);
		for i=1:NPV
			Temp_align_PV(PV_bus(i),i)=1;
		end
		for t=1:NT
			if NPV==0
				beq6((t-1)*NN+1:t*NN)=Temp_align_load*P_loads(t,:)';
			else
				beq6((t-1)*NN+1:t*NN)=Temp_align_load*P_loads(t,:)'+Temp_align_PV*PV(t,:)';
			end
		end

		clear Aeq6_P1;clear Aeq6_P2;clear Aeq6_P3;clear Aeq6_P;clear Aeq6_U;clear Aeq6_SC;clear Aeq6_Q_g;clear Aeq6_Q_g1;clear Aeq6_Q_g2;clear Aeq6_Q_g3;clear Aeq6_P_b_c;clear Aeq6_P_b_dc;clear Aeq6_u_b_c;clear Aeq6_u_b_dc;clear Aeq6_SOC;
		clear Aeq6_Q_b;clear Aeq6_Q_b1;clear Aeq6_Q_b2;clear  Aeq6_Q_b3;clear Aeq6_P_b1;clear Aeq6_P_b2;clear Aeq6_P_b3;clear Aeq6_P_pcc;clear Aeq6_P_pcc_peak;clear Aeq6_Q_pcc;clear Aeq6_Q_pcc_ab;
		clear Aeq6_Aux_v_n;clear Aeq6_v_n;clear Aeq6_P_f;clear Aeq6_P_f1;clear Aeq6_P_f2;clear Aeq6_P_f3;clear Aeq6_Q_f;clear Aeq6_Q_f1;clear Aeq6_Q_f2;clear Aeq6_Q_f3;clear Aeq6_P_n;clear Aeq6_Q_n;

		%--- 7) Q_n=Q_g+Q_b-Q_l  for all t ,n 
		Aeq7_P1=sparse(zeros(NT*NN,NT*NG));
		Aeq7_P2=sparse(zeros(NT*NN,NT*NG));
		Aeq7_P3=sparse(zeros(NT*NN,NT*NG));
		Aeq7_P=sparse(zeros(NT*NN,NT*NG));
		Aeq7_U=sparse(zeros(NT*NN,NT*NG));
		Aeq7_SC=sparse(zeros(NT*NN,NT*NG));

		Aeq7_Q_g_sq=zeros(NN,NG);
		for i=1:NG
			Aeq7_Q_g_sq(generators(i,2),i)=-1;
		end
		for t=1:NT
			Aeq7_Q_g((t-1)*NN+1:t*NN,(t-1)*NG+1:t*NG)=Aeq7_Q_g_sq; 
		end
		Aeq7_Q_g=sparse(Aeq7_Q_g);
		Aeq7_Q_g1=sparse(zeros(NT*NN,NT*NG));
		Aeq7_Q_g2=sparse(zeros(NT*NN,NT*NG)); 
		Aeq7_Q_g3=sparse(zeros(NT*NN,NT*NG));% 
		Aeq7_P_b_c=sparse(zeros(NT*NN,NT*NB));
		Aeq7_P_b_dc=sparse(zeros(NT*NN,NT*NB));
		Aeq7_u_b_c=sparse(zeros(NT*NN,NT*NB));
		Aeq7_u_b_dc=sparse(zeros(NT*NN,NT*NB));
		Aeq7_SOC=sparse(zeros(NT*NN,NT*NB));
		Aeq7_Q_b_sq=zeros(NN,NB);
		for i=1:NB
			Aeq7_Q_b_sq(batteries(i,2),i)=-1;
		end
		for t=1:NT
			Aeq7_Q_b((t-1)*NN+1:t*NN,(t-1)*NB+1:t*NB)= Aeq7_Q_b_sq; 
		end
		Aeq7_Q_b=sparse(Aeq7_Q_b);
		Aeq7_Q_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq7_Q_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq7_Q_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq7_P_b1=sparse(zeros(NT*NN,NT*NB));
		Aeq7_P_b2=sparse(zeros(NT*NN,NT*NB));
		Aeq7_P_b3=sparse(zeros(NT*NN,NT*NB));
		Aeq7_P_pcc=sparse(zeros(NT*NN,NT));
		Aeq7_P_pcc_peak=sparse(zeros(NT*NN,1));
		Aeq7_Q_pcc=zeros(NT*NN,NT);
		for t=1:NT
			Aeq7_Q_pcc((t-1)*NN+1,t)=-1;
		end
		Aeq7_Q_pcc=sparse(Aeq7_Q_pcc);
		Aeq7_Q_pcc_ab=sparse(zeros(NT*NN,NT));
		Aeq7_Aux_v_n=sparse(zeros(NT*NN,NT*NN));
		Aeq7_v_n=sparse(zeros(NT*NN,NT*NN));
		Aeq7_P_f=sparse(zeros(NT*NN,NT*NC));
		Aeq7_P_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq7_P_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq7_P_f3=sparse(zeros(NT*NN,NT*NC));
		Aeq7_Q_f=sparse(zeros(NT*NN,NT*NC));
		Aeq7_Q_f1=sparse(zeros(NT*NN,NT*NC));
		Aeq7_Q_f2=sparse(zeros(NT*NN,NT*NC));
		Aeq7_Q_f3=sparse(zeros(NT*NN,NT*NC));
		Aeq7_P_n=sparse(zeros(NT*NN,NT*NN));
		Aeq7_Q_n=sparse(diag(ones(NT*NN,1)));
		Aeq7=sparse([Aeq7_P1,Aeq7_P2,Aeq7_P3,Aeq7_P,Aeq7_U,Aeq7_SC,Aeq7_Q_g,Aeq7_Q_g1,Aeq7_Q_g2,Aeq7_Q_g3,Aeq7_P_b_c,Aeq7_P_b_dc,Aeq7_u_b_c,Aeq7_u_b_dc,Aeq7_SOC,Aeq7_Q_b,Aeq7_Q_b1,Aeq7_Q_b2,Aeq7_Q_b3,Aeq7_P_b1,Aeq7_P_b2,Aeq7_P_b3,...
					 Aeq7_P_pcc,Aeq7_P_pcc_peak,Aeq7_Q_pcc,Aeq7_Q_pcc_ab,Aeq7_Aux_v_n,Aeq7_v_n,Aeq7_P_f,Aeq7_P_f1,Aeq7_P_f2,Aeq7_P_f3,Aeq7_Q_f,Aeq7_Q_f1,Aeq7_Q_f2,Aeq7_Q_f3,Aeq7_P_n,Aeq7_Q_n]);
		beq7=zeros(NT*NN,1);

		for t=1:NT
		   beq7((t-1)*NN+1:t*NN)=Temp_align_load*Q_loads(t,:)';
		end

		clear Aeq7_P1;clear Aeq7_P2;clear Aeq7_P3;clear Aeq7_P;clear Aeq7_U;clear Aeq7_SC;clear Aeq7_Q_g;clear Aeq7_Q_g1;clear Aeq7_Q_g2;clear Aeq7_Q_g3;clear Aeq7_P_b_c;clear Aeq7_P_b_dc;clear Aeq7_u_b_c;clear Aeq7_u_b_dc;clear Aeq7_SOC;
		clear Aeq7_Q_b;clear Aeq7_Q_b1;clear Aeq7_Q_b2;clear  Aeq7_Q_b3;clear Aeq7_P_b1;clear Aeq7_P_b2;clear Aeq7_P_b3;clear Aeq7_P_pcc;clear Aeq7_P_pcc_peak;clear Aeq7_Q_pcc;clear Aeq7_Q_pcc_ab;
		clear Aeq7_Aux_v_n;clear Aeq7_v_n;clear Aeq7_P_f;clear Aeq7_P_f1;clear Aeq7_P_f2;clear Aeq7_P_f3;clear Aeq7_Q_f;clear Aeq7_Q_f1;clear Aeq7_Q_f2;clear Aeq7_Q_f3;clear Aeq7_P_n;clear Aeq7_Q_n;

		%--- 8) V_n(n=pcc)=V_PCC  for all t 
		Aeq8_P1=sparse(zeros(NT,NT*NG));
		Aeq8_P2=sparse(zeros(NT,NT*NG));
		Aeq8_P3=sparse(zeros(NT,NT*NG));
		Aeq8_P=sparse(zeros(NT,NT*NG));
		Aeq8_U=sparse(zeros(NT,NT*NG));
		Aeq8_SC=sparse(zeros(NT,NT*NG));
		Aeq8_Q_g=sparse(zeros(NT,NT*NG));
		Aeq8_Q_g1=sparse(zeros(NT,NT*NG));
		Aeq8_Q_g2=sparse(zeros(NT,NT*NG)); 
		Aeq8_Q_g3=sparse(zeros(NT,NT*NG));
		Aeq8_P_b_c=sparse(zeros(NT,NT*NB));
		Aeq8_P_b_dc=sparse(zeros(NT,NT*NB));
		Aeq8_u_b_c=sparse(zeros(NT,NT*NB));
		Aeq8_u_b_dc=sparse(zeros(NT,NT*NB));
		Aeq8_SOC=sparse(zeros(NT,NT*NB));
		Aeq8_Q_b=sparse(zeros(NT,NT*NB));
		Aeq8_Q_b1=sparse(zeros(NT,NT*NB));
		Aeq8_Q_b2=sparse(zeros(NT,NT*NB));
		Aeq8_Q_b3=sparse(zeros(NT,NT*NB));
		Aeq8_P_b1=sparse(zeros(NT,NT*NB));
		Aeq8_P_b2=sparse(zeros(NT,NT*NB));
		Aeq8_P_b3=sparse(zeros(NT,NT*NB));
		Aeq8_P_pcc=sparse(zeros(NT,NT));
		Aeq8_P_pcc_peak=sparse(zeros(NT,1));
		Aeq8_Q_pcc=sparse(zeros(NT,NT));
		Aeq8_Q_pcc_ab=sparse(zeros(NT,NT));
		Aeq8_Aux_v_n=sparse(zeros(NT,NT*NN));
		Aeq8_v_n=zeros(NT,NT*NN);
		for t=1:NT
			Aeq8_v_n(t,(t-1)*NN+1)=1;
		end
		Aeq8_v_n=sparse(Aeq8_v_n);
		Aeq8_P_f=sparse(zeros(NT,NT*NC));
		Aeq8_P_f1=sparse(zeros(NT,NT*NC));
		Aeq8_P_f2=sparse(zeros(NT,NT*NC));
		Aeq8_P_f3=sparse(zeros(NT,NT*NC));
		Aeq8_Q_f=sparse(zeros(NT,NT*NC));
		Aeq8_Q_f1=sparse(zeros(NT,NT*NC));
		Aeq8_Q_f2=sparse(zeros(NT,NT*NC));
		Aeq8_Q_f3=sparse(zeros(NT,NT*NC));
		Aeq8_P_n=sparse(zeros(NT,NT*NN));
		Aeq8_Q_n=sparse(zeros(NT,NT*NN));
		Aeq8=sparse([Aeq8_P1,Aeq8_P2,Aeq8_P3,Aeq8_P,Aeq8_U,Aeq8_SC,Aeq8_Q_g,Aeq8_Q_g1,Aeq8_Q_g2,Aeq8_Q_g3,Aeq8_P_b_c,Aeq8_P_b_dc,Aeq8_u_b_c,Aeq8_u_b_dc,Aeq8_SOC,Aeq8_Q_b,Aeq8_Q_b1,Aeq8_Q_b2,Aeq8_Q_b3,Aeq8_P_b1,Aeq8_P_b2,Aeq8_P_b3,...
					 Aeq8_P_pcc,Aeq8_P_pcc_peak,Aeq8_Q_pcc,Aeq8_Q_pcc_ab,Aeq8_Aux_v_n,Aeq8_v_n,Aeq8_P_f,Aeq8_P_f1,Aeq8_P_f2,Aeq8_P_f3,Aeq8_Q_f,Aeq8_Q_f1,Aeq8_Q_f2,Aeq8_Q_f3,Aeq8_P_n,Aeq8_Q_n]);
		beq8=ones(NT,1)*V_PCC;

		clear Aeq8_P1;clear Aeq8_P2;clear Aeq8_P3;clear Aeq8_P;clear Aeq8_U;clear Aeq8_SC;clear Aeq8_Q_g;clear Aeq8_Q_g1;clear Aeq8_Q_g2;clear Aeq8_Q_g3;clear Aeq8_P_b_c;clear Aeq8_P_b_dc;clear Aeq8_u_b_c;clear Aeq8_u_b_dc;clear Aeq8_SOC;
		clear Aeq8_Q_b;clear Aeq8_Q_b1;clear Aeq8_Q_b2;clear  Aeq8_Q_b3;clear Aeq8_P_b1;clear Aeq8_P_b2;clear Aeq8_P_b3;clear Aeq8_P_pcc;clear Aeq8_P_pcc_peak;clear Aeq8_Q_pcc;clear Aeq8_Q_pcc_ab;
		clear Aeq8_Aux_v_n;clear Aeq8_v_n;clear Aeq8_P_f;clear Aeq8_P_f1;clear Aeq8_P_f2;clear Aeq8_P_f3;clear Aeq8_Q_f;clear Aeq8_Q_f1;clear Aeq8_Q_f2;clear Aeq8_Q_f3;clear Aeq8_P_n;clear Aeq8_Q_n;
	catch Me
		disp('EMS Grid Connected_Defining Equalities')
		disp(Me.message)   
		ignore_results = 1;         
	end;
end;

if ignore_results == 0
	try
		%% Inequalities
		%--- 1)SCit>=Uit-Uit-1
		A1_P1=sparse(zeros(NT*NG,NT*NG));
		A1_P2=sparse(zeros(NT*NG,NT*NG));
		A1_P3=sparse(zeros(NT*NG,NT*NG));
		A1_P=sparse(zeros(NT*NG,NT*NG));
		A1_U=diag(ones(NT*NG,1));
		for i=1:(NT-1)*NG
			A1_U(i+NG,i)=-1;
		end
		A1_U=sparse(A1_U);
		A1_SC=sparse(-1*diag(ones(NT*NG,1)));
		A1_Q_g=sparse(zeros(NT*NG,NT*NG));
		A1_Q_g1=sparse(zeros(NT*NG,NT*NG));
		A1_Q_g2=sparse(zeros(NT*NG,NT*NG)); 
		A1_Q_g3=sparse(zeros(NT*NG,NT*NG));% 
		A1_P_b_c=sparse(zeros(NT*NG,NT*NB));
		A1_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		A1_u_b_c=sparse(zeros(NT*NG,NT*NB));
		A1_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		A1_SOC=sparse(zeros(NT*NG,NT*NB));
		A1_Q_b=sparse(zeros(NT*NG,NT*NB));
		A1_Q_b1=sparse(zeros(NT*NG,NT*NB));
		A1_Q_b2=sparse(zeros(NT*NG,NT*NB));
		A1_Q_b3=sparse(zeros(NT*NG,NT*NB));
		A1_P_b1=sparse(zeros(NT*NG,NT*NB));
		A1_P_b2=sparse(zeros(NT*NG,NT*NB));
		A1_P_b3=sparse(zeros(NT*NG,NT*NB));
		A1_P_pcc=sparse(zeros(NT*NG,NT));
		A1_P_pcc_peak=sparse(zeros(NT*NG,1));
		A1_Q_pcc=sparse(zeros(NT*NG,NT));
		A1_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		A1_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		A1_v_n=sparse(zeros(NT*NG,NT*NN));
		A1_P_f=sparse(zeros(NT*NG,NT*NC));
		A1_P_f1=sparse(zeros(NT*NG,NT*NC));
		A1_P_f2=sparse(zeros(NT*NG,NT*NC));
		A1_P_f3=sparse(zeros(NT*NG,NT*NC));
		A1_Q_f=sparse(zeros(NT*NG,NT*NC));
		A1_Q_f1=sparse(zeros(NT*NG,NT*NC));
		A1_Q_f2=sparse(zeros(NT*NG,NT*NC));
		A1_Q_f3=sparse(zeros(NT*NG,NT*NC));
		A1_P_n=sparse(zeros(NT*NG,NT*NN));
		A1_Q_n=sparse(zeros(NT*NG,NT*NN));
		A1=sparse([A1_P1,A1_P2,A1_P3,A1_P,A1_U,A1_SC,A1_Q_g,A1_Q_g1,A1_Q_g2,A1_Q_g3,A1_P_b_c,A1_P_b_dc,A1_u_b_c,A1_u_b_dc,A1_SOC,A1_Q_b,A1_Q_b1,A1_Q_b2,A1_Q_b3,A1_P_b1,A1_P_b2,A1_P_b3,...
					 A1_P_pcc,A1_P_pcc_peak,A1_Q_pcc,A1_Q_pcc_ab,A1_Aux_v_n,A1_v_n,A1_P_f,A1_P_f1,A1_P_f2,A1_P_f3,A1_Q_f,A1_Q_f1,A1_Q_f2,A1_Q_f3,A1_P_n,A1_Q_n]);
		b1=[generators(:,17);zeros((NT-1)*NG,1)];

		clear A1_P1;clear A1_P2;clear A1_P3;clear A1_P;clear A1_U;clear A1_SC;clear A1_Q_g;clear A1_Q_g1;clear A1_Q_g2;clear A1_Q_g3;clear A1_P_b_c;clear A1_P_b_dc;clear A1_u_b_c;clear A1_u_b_dc;clear A1_SOC;
		clear A1_Q_b;clear A1_Q_b1;clear A1_Q_b2;clear  A1_Q_b3;clear A1_P_b1;clear A1_P_b2;clear A1_P_b3;clear A1_P_pcc;clear A1_P_pcc_peak;clear A1_Q_pcc;clear A1_Q_pcc_ab;
		clear A1_Aux_v_n;clear A1_v_n;clear A1_P_f;clear A1_P_f1;clear A1_P_f2;clear A1_P_f3;clear A1_Q_f;clear A1_Q_f1;clear A1_Q_f2;clear A1_Q_f3;clear A1_P_n;clear A1_Q_n;

		%--- 2)Pit<=Uit*Pi_max
		A2_P1=sparse(zeros(NT*NG,NT*NG));
		A2_P2=sparse(zeros(NT*NG,NT*NG));
		A2_P3=sparse(zeros(NT*NG,NT*NG));
		A2_P=sparse(diag(ones(NT*NG,1)));
		A2_U=sparse(diag(-1*P_g_ub));
		A2_SC=sparse(zeros(NT*NG,NT*NG));
		A2_Q_g=sparse(zeros(NT*NG,NT*NG));
		A2_Q_g1=sparse(zeros(NT*NG,NT*NG));
		A2_Q_g2=sparse(zeros(NT*NG,NT*NG)); 
		A2_Q_g3=sparse(zeros(NT*NG,NT*NG));% 
		A2_P_b_c=sparse(zeros(NT*NG,NT*NB));
		A2_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		A2_u_b_c=sparse(zeros(NT*NG,NT*NB));
		A2_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		A2_SOC=sparse(zeros(NT*NG,NT*NB));
		A2_Q_b=sparse(zeros(NT*NG,NT*NB));
		A2_Q_b1=sparse(zeros(NT*NG,NT*NB));
		A2_Q_b2=sparse(zeros(NT*NG,NT*NB));
		A2_Q_b3=sparse(zeros(NT*NG,NT*NB));
		A2_P_b1=sparse(zeros(NT*NG,NT*NB));
		A2_P_b2=sparse(zeros(NT*NG,NT*NB));
		A2_P_b3=sparse(zeros(NT*NG,NT*NB));
		A2_P_pcc=sparse(zeros(NT*NG,NT));
		A2_P_pcc_peak=sparse(zeros(NT*NG,1));
		A2_Q_pcc=sparse(zeros(NT*NG,NT));
		A2_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		A2_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		A2_v_n=sparse(zeros(NT*NG,NT*NN));
		A2_P_f=sparse(zeros(NT*NG,NT*NC));
		A2_P_f1=sparse(zeros(NT*NG,NT*NC));
		A2_P_f2=sparse(zeros(NT*NG,NT*NC));
		A2_P_f3=sparse(zeros(NT*NG,NT*NC));
		A2_Q_f=sparse(zeros(NT*NG,NT*NC));
		A2_Q_f1=sparse(zeros(NT*NG,NT*NC));
		A2_Q_f2=sparse(zeros(NT*NG,NT*NC));
		A2_Q_f3=sparse(zeros(NT*NG,NT*NC));
		A2_P_n=sparse(zeros(NT*NG,NT*NN));
		A2_Q_n=sparse(zeros(NT*NG,NT*NN));
		A2=sparse([A2_P1,A2_P2,A2_P3,A2_P,A2_U,A2_SC,A2_Q_g,A2_Q_g1,A2_Q_g2,A2_Q_g3,A2_P_b_c,A2_P_b_dc,A2_u_b_c,A2_u_b_dc,A2_SOC,A2_Q_b,A2_Q_b1,A2_Q_b2,A2_Q_b3,A2_P_b1,A2_P_b2,A2_P_b3,...
					 A2_P_pcc,A2_P_pcc_peak,A2_Q_pcc,A2_Q_pcc_ab,A2_Aux_v_n,A2_v_n,A2_P_f,A2_P_f1,A2_P_f2,A2_P_f3,A2_Q_f,A2_Q_f1,A2_Q_f2,A2_Q_f3,A2_P_n,A2_Q_n]);
		b2=zeros(NT*NG,1);

		clear A2_P1;clear A2_P2;clear A2_P3;clear A2_P;clear A2_U;clear A2_SC;clear A2_Q_g;clear A2_Q_g1;clear A2_Q_g2;clear A2_Q_g3;clear A2_P_b_c;clear A2_P_b_dc;clear A2_u_b_c;clear A2_u_b_dc;clear A2_SOC;
		clear A2_Q_b;clear A2_Q_b1;clear A2_Q_b2;clear  A2_Q_b3;clear A2_P_b1;clear A2_P_b2;clear A2_P_b3;clear A2_P_pcc;clear A2_P_pcc_peak;clear A2_Q_pcc;clear A2_Q_pcc_ab;
		clear A2_Aux_v_n;clear A2_v_n;clear A2_P_f;clear A2_P_f1;clear A2_P_f2;clear A2_P_f3;clear A2_Q_f;clear A2_Q_f1;clear A2_Q_f2;clear A2_Q_f3;clear A2_P_n;clear A2_Q_n;clear P_g_ub;

		%--- 3)Qit<=Pit*tan(fe); tan(fe)=tan(acos(PF_max))
		A3_P1=sparse(zeros(NT*NG,NT*NG));
		A3_P2=sparse(zeros(NT*NG,NT*NG));
		A3_P3=sparse(zeros(NT*NG,NT*NG));
		A3_P_vec=zeros(NT*NG,1);
		for t=1:NT
		   A3_P_vec((t-1)*NG+1:t*NG)=-1*tan(acos(PFmax_g));
		end
		A3_P=sparse(diag(A3_P_vec));
		A3_U=sparse(zeros(NT*NG,NT*NG));
		A3_SC=sparse(zeros(NT*NG,NT*NG));
		A3_Q_g=sparse(diag(ones(NT*NG,1)));
		A3_Q_g1=sparse(zeros(NT*NG,NT*NG));
		A3_Q_g2=sparse(zeros(NT*NG,NT*NG)); 
		A3_Q_g3=sparse(zeros(NT*NG,NT*NG));% 
		A3_P_b_c=sparse(zeros(NT*NG,NT*NB));
		A3_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		A3_u_b_c=sparse(zeros(NT*NG,NT*NB));
		A3_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		A3_SOC=sparse(zeros(NT*NG,NT*NB));
		A3_Q_b=sparse(zeros(NT*NG,NT*NB));
		A3_Q_b1=sparse(zeros(NT*NG,NT*NB));
		A3_Q_b2=sparse(zeros(NT*NG,NT*NB));
		A3_Q_b3=sparse(zeros(NT*NG,NT*NB));
		A3_P_b1=sparse(zeros(NT*NG,NT*NB));
		A3_P_b2=sparse(zeros(NT*NG,NT*NB));
		A3_P_b3=sparse(zeros(NT*NG,NT*NB));
		A3_P_pcc=sparse(zeros(NT*NG,NT));
		A3_P_pcc_peak=sparse(zeros(NT*NG,1));
		A3_Q_pcc=sparse(zeros(NT*NG,NT));
		A3_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		A3_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		A3_v_n=sparse(zeros(NT*NG,NT*NN));
		A3_P_f=sparse(zeros(NT*NG,NT*NC));
		A3_P_f1=sparse(zeros(NT*NG,NT*NC));
		A3_P_f2=sparse(zeros(NT*NG,NT*NC));
		A3_P_f3=sparse(zeros(NT*NG,NT*NC));
		A3_Q_f=sparse(zeros(NT*NG,NT*NC));
		A3_Q_f1=sparse(zeros(NT*NG,NT*NC));
		A3_Q_f2=sparse(zeros(NT*NG,NT*NC));
		A3_Q_f3=sparse(zeros(NT*NG,NT*NC));
		A3_P_n=sparse(zeros(NT*NG,NT*NN));
		A3_Q_n=sparse(zeros(NT*NG,NT*NN));
		A3=sparse([A3_P1,A3_P2,A3_P3,A3_P,A3_U,A3_SC,A3_Q_g,A3_Q_g1,A3_Q_g2,A3_Q_g3,A3_P_b_c,A3_P_b_dc,A3_u_b_c,A3_u_b_dc,A3_SOC,A3_Q_b,A3_Q_b1,A3_Q_b2,A3_Q_b3,A3_P_b1,A3_P_b2,A3_P_b3,...
					 A3_P_pcc,A3_P_pcc_peak,A3_Q_pcc,A3_Q_pcc_ab,A3_Aux_v_n,A3_v_n,A3_P_f,A3_P_f1,A3_P_f2,A3_P_f3,A3_Q_f,A3_Q_f1,A3_Q_f2,A3_Q_f3,A3_P_n,A3_Q_n]);
		b3=zeros(NT*NG,1);

		clear A3_P1;clear A3_P2;clear A3_P3;clear A3_P;clear A3_U;clear A3_SC;clear A3_Q_g;clear A3_Q_g1;clear A3_Q_g2;clear A3_Q_g3;clear A3_P_b_c;clear A3_P_b_dc;clear A3_u_b_c;clear A3_u_b_dc;clear A3_SOC;
		clear A3_Q_b;clear A3_Q_b1;clear A3_Q_b2;clear  A3_Q_b3;clear A3_P_b1;clear A3_P_b2;clear A3_P_b3;clear A3_P_pcc;clear A3_P_pcc_peak;clear A3_Q_pcc;clear A3_Q_pcc_ab;
		clear A3_Aux_v_n;clear A3_v_n;clear A3_P_f;clear A3_P_f1;clear A3_P_f2;clear A3_P_f3;clear A3_Q_f;clear A3_Q_f1;clear A3_Q_f2;clear A3_Q_f3;clear A3_P_n;clear A3_Q_n;


		%--- 4)Pit*tan(fe)<=Qit;; tan(fe)=tan(acos(PF_max))<0
		A4_P1=sparse(zeros(NT*NG,NT*NG));
		A4_P2=sparse(zeros(NT*NG,NT*NG));
		A4_P3=sparse(zeros(NT*NG,NT*NG));
		A4_P_vec=zeros(NT*NG,1);
		for t=1:NT
		   A4_P_vec((t-1)*NG+1:t*NG)=tan(acos(PFmin_g));
		end
		A4_P=sparse(diag(A4_P_vec));
		A4_U=sparse(zeros(NT*NG,NT*NG));
		A4_SC=sparse(zeros(NT*NG,NT*NG));
		A4_Q_g=sparse(diag(-1*ones(NT*NG,1)));
		A4_Q_g1=sparse(zeros(NT*NG,NT*NG));
		A4_Q_g2=sparse(zeros(NT*NG,NT*NG)); 
		A4_Q_g3=sparse(zeros(NT*NG,NT*NG));% 
		A4_P_b_c=sparse(zeros(NT*NG,NT*NB));
		A4_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		A4_u_b_c=sparse(zeros(NT*NG,NT*NB));
		A4_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		A4_SOC=sparse(zeros(NT*NG,NT*NB));
		A4_Q_b=sparse(zeros(NT*NG,NT*NB));
		A4_Q_b1=sparse(zeros(NT*NG,NT*NB));
		A4_Q_b2=sparse(zeros(NT*NG,NT*NB));
		A4_Q_b3=sparse(zeros(NT*NG,NT*NB));
		A4_P_b1=sparse(zeros(NT*NG,NT*NB));
		A4_P_b2=sparse(zeros(NT*NG,NT*NB));
		A4_P_b3=sparse(zeros(NT*NG,NT*NB));
		A4_P_pcc=sparse(zeros(NT*NG,NT));
		A4_P_pcc_peak=sparse(zeros(NT*NG,1));
		A4_Q_pcc=sparse(zeros(NT*NG,NT));
		A4_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		A4_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		A4_v_n=sparse(zeros(NT*NG,NT*NN));
		A4_P_f=sparse(zeros(NT*NG,NT*NC));
		A4_P_f1=sparse(zeros(NT*NG,NT*NC));
		A4_P_f2=sparse(zeros(NT*NG,NT*NC));
		A4_P_f3=sparse(zeros(NT*NG,NT*NC));
		A4_Q_f=sparse(zeros(NT*NG,NT*NC));
		A4_Q_f1=sparse(zeros(NT*NG,NT*NC));
		A4_Q_f2=sparse(zeros(NT*NG,NT*NC));
		A4_Q_f3=sparse(zeros(NT*NG,NT*NC));
		A4_P_n=sparse(zeros(NT*NG,NT*NN));
		A4_Q_n=sparse(zeros(NT*NG,NT*NN));
		A4=sparse([A4_P1,A4_P2,A4_P3,A4_P,A4_U,A4_SC,A4_Q_g,A4_Q_g1,A4_Q_g2,A4_Q_g3,A4_P_b_c,A4_P_b_dc,A4_u_b_c,A4_u_b_dc,A4_SOC,A4_Q_b,A4_Q_b1,A4_Q_b2,A4_Q_b3,A4_P_b1,A4_P_b2,A4_P_b3,...
					 A4_P_pcc,A4_P_pcc_peak,A4_Q_pcc,A4_Q_pcc_ab,A4_Aux_v_n,A4_v_n,A4_P_f,A4_P_f1,A4_P_f2,A4_P_f3,A4_Q_f,A4_Q_f1,A4_Q_f2,A4_Q_f3,A4_P_n,A4_Q_n]);
		b4=zeros(NT*NG,1);

		clear A4_P1;clear A4_P2;clear A4_P3;clear A4_P;clear A4_U;clear A4_SC;clear A4_Q_g;clear A4_Q_g1;clear A4_Q_g2;clear A4_Q_g3;clear A4_P_b_c;clear A4_P_b_dc;clear A4_u_b_c;clear A4_u_b_dc;clear A4_SOC;
		clear A4_Q_b;clear A4_Q_b1;clear A4_Q_b2;clear  A4_Q_b3;clear A4_P_b1;clear A4_P_b2;clear A4_P_b3;clear A4_P_pcc;clear A4_P_pcc_peak;clear A4_Q_pcc;clear A4_Q_pcc_ab;
		clear A4_Aux_v_n;clear A4_v_n;clear A4_P_f;clear A4_P_f1;clear A4_P_f2;clear A4_P_f3;clear A4_Q_f;clear A4_Q_f1;clear A4_Q_f2;clear A4_Q_f3;clear A4_P_n;clear A4_Q_n;


		%--- 5)Q_g1+Q_g2+Q_g3>=Q_g
		A5_P1=sparse(zeros(NT*NG,NT*NG));
		A5_P2=sparse(zeros(NT*NG,NT*NG));
		A5_P3=sparse(zeros(NT*NG,NT*NG));
		A5_P=sparse(zeros(NT*NG,NT*NG));
		A5_U=sparse(zeros(NT*NG,NT*NG));
		A5_SC=sparse(zeros(NT*NG,NT*NG));
		A5_Q_g=sparse(diag(ones(NT*NG,1)));
		A5_Q_g1=sparse(diag(-1*ones(NT*NG,1)));
		A5_Q_g2=sparse(diag(-1*ones(NT*NG,1))); 
		A5_Q_g3=sparse(diag(-1*ones(NT*NG,1))); 
		A5_P_b_c=sparse(zeros(NT*NG,NT*NB));
		A5_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		A5_u_b_c=sparse(zeros(NT*NG,NT*NB));
		A5_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		A5_SOC=sparse(zeros(NT*NG,NT*NB));
		A5_Q_b=sparse(zeros(NT*NG,NT*NB));
		A5_Q_b1=sparse(zeros(NT*NG,NT*NB));
		A5_Q_b2=sparse(zeros(NT*NG,NT*NB));
		A5_Q_b3=sparse(zeros(NT*NG,NT*NB));
		A5_P_b1=sparse(zeros(NT*NG,NT*NB));
		A5_P_b2=sparse(zeros(NT*NG,NT*NB));
		A5_P_b3=sparse(zeros(NT*NG,NT*NB));
		A5_P_pcc=sparse(zeros(NT*NG,NT));
		A5_P_pcc_peak=sparse(zeros(NT*NG,1));
		A5_Q_pcc=sparse(zeros(NT*NG,NT));
		A5_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		A5_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		A5_v_n=sparse(zeros(NT*NG,NT*NN));
		A5_P_f=sparse(zeros(NT*NG,NT*NC));
		A5_P_f1=sparse(zeros(NT*NG,NT*NC));
		A5_P_f2=sparse(zeros(NT*NG,NT*NC));
		A5_P_f3=sparse(zeros(NT*NG,NT*NC));
		A5_Q_f=sparse(zeros(NT*NG,NT*NC));
		A5_Q_f1=sparse(zeros(NT*NG,NT*NC));
		A5_Q_f2=sparse(zeros(NT*NG,NT*NC));
		A5_Q_f3=sparse(zeros(NT*NG,NT*NC));
		A5_P_n=sparse(zeros(NT*NG,NT*NN));
		A5_Q_n=sparse(zeros(NT*NG,NT*NN));
		A5=sparse([A5_P1,A5_P2,A5_P3,A5_P,A5_U,A5_SC,A5_Q_g,A5_Q_g1,A5_Q_g2,A5_Q_g3,A5_P_b_c,A5_P_b_dc,A5_u_b_c,A5_u_b_dc,A5_SOC,A5_Q_b,A5_Q_b1,A5_Q_b2,A5_Q_b3,A5_P_b1,A5_P_b2,A5_P_b3,...
					 A5_P_pcc,A5_P_pcc_peak,A5_Q_pcc,A5_Q_pcc_ab,A5_Aux_v_n,A5_v_n,A5_P_f,A5_P_f1,A5_P_f2,A5_P_f3,A5_Q_f,A5_Q_f1,A5_Q_f2,A5_Q_f3,A5_P_n,A5_Q_n]);
		b5=zeros(NT*NG,1);

		clear A5_P1;clear A5_P2;clear A5_P3;clear A5_P;clear A5_U;clear A5_SC;clear A5_Q_g;clear A5_Q_g1;clear A5_Q_g2;clear A5_Q_g3;clear A5_P_b_c;clear A5_P_b_dc;clear A5_u_b_c;clear A5_u_b_dc;clear A5_SOC;
		clear A5_Q_b;clear A5_Q_b1;clear A5_Q_b2;clear  A5_Q_b3;clear A5_P_b1;clear A5_P_b2;clear A5_P_b3;clear A5_P_pcc;clear A5_P_pcc_peak;clear A5_Q_pcc;clear A5_Q_pcc_ab;
		clear A5_Aux_v_n;clear A5_v_n;clear A5_P_f;clear A5_P_f1;clear A5_P_f2;clear A5_P_f3;clear A5_Q_f;clear A5_Q_f1;clear A5_Q_f2;clear A5_Q_f3;clear A5_P_n;clear A5_Q_n;


		%--- 6)Q_g1+Q_g2+Q_g3>=-Q_g
		A6_P1=sparse(zeros(NT*NG,NT*NG));
		A6_P2=sparse(zeros(NT*NG,NT*NG));
		A6_P3=sparse(zeros(NT*NG,NT*NG));
		A6_P=sparse(zeros(NT*NG,NT*NG));
		A6_U=sparse(zeros(NT*NG,NT*NG));
		A6_SC=sparse(zeros(NT*NG,NT*NG));
		A6_Q_g=sparse(diag(-1*ones(NT*NG,1)));
		A6_Q_g1=sparse(diag(-1*ones(NT*NG,1)));
		A6_Q_g2=sparse(diag(-1*ones(NT*NG,1))); 
		A6_Q_g3=sparse(diag(-1*ones(NT*NG,1))); 
		A6_P_b_c=sparse(zeros(NT*NG,NT*NB));
		A6_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		A6_u_b_c=sparse(zeros(NT*NG,NT*NB));
		A6_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		A6_SOC=sparse(zeros(NT*NG,NT*NB));
		A6_Q_b=sparse(zeros(NT*NG,NT*NB));
		A6_Q_b1=sparse(zeros(NT*NG,NT*NB));
		A6_Q_b2=sparse(zeros(NT*NG,NT*NB));
		A6_Q_b3=sparse(zeros(NT*NG,NT*NB));
		A6_P_b1=sparse(zeros(NT*NG,NT*NB));
		A6_P_b2=sparse(zeros(NT*NG,NT*NB));
		A6_P_b3=sparse(zeros(NT*NG,NT*NB));
		A6_P_pcc=sparse(zeros(NT*NG,NT));
		A6_P_pcc_peak=sparse(zeros(NT*NG,1));
		A6_Q_pcc=sparse(zeros(NT*NG,NT));
		A6_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		A6_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		A6_v_n=sparse(zeros(NT*NG,NT*NN));
		A6_P_f=sparse(zeros(NT*NG,NT*NC));
		A6_P_f1=sparse(zeros(NT*NG,NT*NC));
		A6_P_f2=sparse(zeros(NT*NG,NT*NC));
		A6_P_f3=sparse(zeros(NT*NG,NT*NC));
		A6_Q_f=sparse(zeros(NT*NG,NT*NC));
		A6_Q_f1=sparse(zeros(NT*NG,NT*NC));
		A6_Q_f2=sparse(zeros(NT*NG,NT*NC));
		A6_Q_f3=sparse(zeros(NT*NG,NT*NC));
		A6_P_n=sparse(zeros(NT*NG,NT*NN));
		A6_Q_n=sparse(zeros(NT*NG,NT*NN));
		A6=sparse([A6_P1,A6_P2,A6_P3,A6_P,A6_U,A6_SC,A6_Q_g,A6_Q_g1,A6_Q_g2,A6_Q_g3,A6_P_b_c,A6_P_b_dc,A6_u_b_c,A6_u_b_dc,A6_SOC,A6_Q_b,A6_Q_b1,A6_Q_b2,A6_Q_b3,A6_P_b1,A6_P_b2,A6_P_b3,...
					 A6_P_pcc,A6_P_pcc_peak,A6_Q_pcc,A6_Q_pcc_ab,A6_Aux_v_n,A6_v_n,A6_P_f,A6_P_f1,A6_P_f2,A6_P_f3,A6_Q_f,A6_Q_f1,A6_Q_f2,A6_Q_f3,A6_P_n,A6_Q_n]);
		b6=zeros(NT*NG,1);

		clear A6_P1;clear A6_P2;clear A6_P3;clear A6_P;clear A6_U;clear A6_SC;clear A6_Q_g;clear A6_Q_g1;clear A6_Q_g2;clear A6_Q_g3;clear A6_P_b_c;clear A6_P_b_dc;clear A6_u_b_c;clear A6_u_b_dc;clear A6_SOC;
		clear A6_Q_b;clear A6_Q_b1;clear A6_Q_b2;clear  A6_Q_b3;clear A6_P_b1;clear A6_P_b2;clear A6_P_b3;clear A6_P_pcc;clear A6_P_pcc_peak;clear A6_Q_pcc;clear A6_Q_pcc_ab;
		clear A6_Aux_v_n;clear A6_v_n;clear A6_P_f;clear A6_P_f1;clear A6_P_f2;clear A6_P_f3;clear A6_Q_f;clear A6_Q_f1;clear A6_Q_f2;clear A6_Q_f3;clear A6_P_n;clear A6_Q_n;


		%--- 7)sum(cp_it*P_it)+u_it*P_min^2+sum(cq_it*Qit)<=Smax_g^2
		A7_P1=sparse(diag(C_P_g1));
		A7_P2=sparse(diag(C_P_g2));
		A7_P3=sparse(diag(C_P_g3));
		A7_P=sparse(zeros(NT*NG,NT*NG));
		A7_U_vec=zeros(NT*NG,1);
		for t=1:NT
		   A7_U_vec((t-1)*NG+1:t*NG)=Pmin_g.^2;
		end
		A7_U=sparse(diag(A7_U_vec));
		A7_SC=sparse(zeros(NT*NG,NT*NG));
		A7_Q_g=sparse(zeros(NT*NG,NT*NG));
		A7_Q_g1=sparse(diag(C_Q_g1));
		A7_Q_g2=sparse(diag(C_Q_g2)); 
		A7_Q_g3=sparse(diag(C_Q_g3)); 
		A7_P_b_c=sparse(zeros(NT*NG,NT*NB));
		A7_P_b_dc=sparse(zeros(NT*NG,NT*NB));
		A7_u_b_c=sparse(zeros(NT*NG,NT*NB));
		A7_u_b_dc=sparse(zeros(NT*NG,NT*NB));
		A7_SOC=sparse(zeros(NT*NG,NT*NB));
		A7_Q_b=sparse(zeros(NT*NG,NT*NB));
		A7_Q_b1=sparse(zeros(NT*NG,NT*NB));
		A7_Q_b2=sparse(zeros(NT*NG,NT*NB));
		A7_Q_b3=sparse(zeros(NT*NG,NT*NB));
		A7_P_b1=sparse(zeros(NT*NG,NT*NB));
		A7_P_b2=sparse(zeros(NT*NG,NT*NB));
		A7_P_b3=sparse(zeros(NT*NG,NT*NB));
		A7_P_pcc=sparse(zeros(NT*NG,NT));
		A7_P_pcc_peak=sparse(zeros(NT*NG,1));
		A7_Q_pcc=sparse(zeros(NT*NG,NT));
		A7_Q_pcc_ab=sparse(zeros(NT*NG,NT));
		A7_Aux_v_n=sparse(zeros(NT*NG,NT*NN));
		A7_v_n=sparse(zeros(NT*NG,NT*NN));
		A7_P_f=sparse(zeros(NT*NG,NT*NC));
		A7_P_f1=sparse(zeros(NT*NG,NT*NC));
		A7_P_f2=sparse(zeros(NT*NG,NT*NC));
		A7_P_f3=sparse(zeros(NT*NG,NT*NC));
		A7_Q_f=sparse(zeros(NT*NG,NT*NC));
		A7_Q_f1=sparse(zeros(NT*NG,NT*NC));
		A7_Q_f2=sparse(zeros(NT*NG,NT*NC));
		A7_Q_f3=sparse(zeros(NT*NG,NT*NC));
		A7_P_n=sparse(zeros(NT*NG,NT*NN));
		A7_Q_n=sparse(zeros(NT*NG,NT*NN));
		A7=sparse([A7_P1,A7_P2,A7_P3,A7_P,A7_U,A7_SC,A7_Q_g,A7_Q_g1,A7_Q_g2,A7_Q_g3,A7_P_b_c,A7_P_b_dc,A7_u_b_c,A7_u_b_dc,A7_SOC,A7_Q_b,A7_Q_b1,A7_Q_b2,A7_Q_b3,A7_P_b1,A7_P_b2,A7_P_b3,...
					 A7_P_pcc,A7_P_pcc_peak,A7_Q_pcc,A7_Q_pcc_ab,A7_Aux_v_n,A7_v_n,A7_P_f,A7_P_f1,A7_P_f2,A7_P_f3,A7_Q_f,A7_Q_f1,A7_Q_f2,A7_Q_f3,A7_P_n,A7_Q_n]);
		b7=zeros(NT*NG,1);
		for t=1:NT
		   b7((t-1)*NG+1:t*NG)=Smax_g.^2;
		end
		clear A7_P1;clear A7_P2;clear A7_P3;clear A7_P;clear A7_U;clear A7_SC;clear A7_Q_g;clear A7_Q_g1;clear A7_Q_g2;clear A7_Q_g3;clear A7_P_b_c;clear A7_P_b_dc;clear A7_u_b_c;clear A7_u_b_dc;clear A7_SOC;
		clear A7_Q_b;clear A7_Q_b1;clear A7_Q_b2;clear  A7_Q_b3;clear A7_P_b1;clear A7_P_b2;clear A7_P_b3;clear A7_P_pcc;clear A7_P_pcc_peak;clear A7_Q_pcc;clear A7_Q_pcc_ab;
		clear A7_Aux_v_n;clear A7_v_n;clear A7_P_f;clear A7_P_f1;clear A7_P_f2;clear A7_P_f3;clear A7_Q_f;clear A7_Q_f1;clear A7_Q_f2;clear A7_Q_f3;clear A7_P_n;clear A7_Q_n;

		%--- 8)P_ch<=u_ch*P_ch(max)
		A8_P1=sparse(zeros(NT*NB,NT*NG));
		A8_P2=sparse(zeros(NT*NB,NT*NG));
		A8_P3=sparse(zeros(NT*NB,NT*NG));
		A8_P=sparse(zeros(NT*NB,NT*NG));
		A8_U=sparse(zeros(NT*NB,NT*NG));
		A8_SC=sparse(zeros(NT*NB,NT*NG));
		A8_Q_g=sparse(zeros(NT*NB,NT*NG));
		A8_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A8_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A8_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A8_P_b_c=sparse(diag(ones(NT*NB,1)));
		A8_P_b_dc=sparse(zeros(NT*NB,NT*NB));
		A8_u_b_c_vec=zeros(NT*NB,1);
		for t=1:NT
		   A8_u_b_c_vec((t-1)*NB+1:t*NB)=-Pmax_b;
		end
		A8_u_b_c=sparse(diag(A8_u_b_c_vec));
		A8_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A8_SOC=sparse(zeros(NT*NB,NT*NB));
		A8_Q_b=sparse(zeros(NT*NB,NT*NB));
		A8_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A8_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A8_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A8_P_b1=sparse(zeros(NT*NB,NT*NB));
		A8_P_b2=sparse(zeros(NT*NB,NT*NB));
		A8_P_b3=sparse(zeros(NT*NB,NT*NB));
		A8_P_pcc=sparse(zeros(NT*NB,NT));
		A8_P_pcc_peak=sparse(zeros(NT*NB,1));
		A8_Q_pcc=sparse(zeros(NT*NB,NT));
		A8_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A8_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A8_v_n=sparse(zeros(NT*NB,NT*NN));
		A8_P_f=sparse(zeros(NT*NB,NT*NC));
		A8_P_f1=sparse(zeros(NT*NB,NT*NC));
		A8_P_f2=sparse(zeros(NT*NB,NT*NC));
		A8_P_f3=sparse(zeros(NT*NB,NT*NC));
		A8_Q_f=sparse(zeros(NT*NB,NT*NC));
		A8_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A8_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A8_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A8_P_n=sparse(zeros(NT*NB,NT*NN));
		A8_Q_n=sparse(zeros(NT*NB,NT*NN));
		A8=sparse([A8_P1,A8_P2,A8_P3,A8_P,A8_U,A8_SC,A8_Q_g,A8_Q_g1,A8_Q_g2,A8_Q_g3,A8_P_b_c,A8_P_b_dc,A8_u_b_c,A8_u_b_dc,A8_SOC,A8_Q_b,A8_Q_b1,A8_Q_b2,A8_Q_b3,A8_P_b1,A8_P_b2,A8_P_b3,...
					 A8_P_pcc,A8_P_pcc_peak,A8_Q_pcc,A8_Q_pcc_ab,A8_Aux_v_n,A8_v_n,A8_P_f,A8_P_f1,A8_P_f2,A8_P_f3,A8_Q_f,A8_Q_f1,A8_Q_f2,A8_Q_f3,A8_P_n,A8_Q_n]);
		b8=zeros(NT*NB,1);

		clear A8_P1;clear A8_P2;clear A8_P3;clear A8_P;clear A8_U;clear A8_SC;clear A8_Q_g;clear A8_Q_g1;clear A8_Q_g2;clear A8_Q_g3;clear A8_P_b_c;clear A8_P_b_dc;clear A8_u_b_c;clear A8_u_b_dc;clear A8_SOC;
		clear A8_Q_b;clear A8_Q_b1;clear A8_Q_b2;clear  A8_Q_b3;clear A8_P_b1;clear A8_P_b2;clear A8_P_b3;clear A8_P_pcc;clear A8_P_pcc_peak;clear A8_Q_pcc;clear A8_Q_pcc_ab;
		clear A8_Aux_v_n;clear A8_v_n;clear A8_P_f;clear A8_P_f1;clear A8_P_f2;clear A8_P_f3;clear A8_Q_f;clear A8_Q_f1;clear A8_Q_f2;clear A8_Q_f3;clear A8_P_n;clear A8_Q_n;

		%--- 9)P_dch<=u_dch*P_dch(max)
		A9_P1=sparse(zeros(NT*NB,NT*NG));
		A9_P2=sparse(zeros(NT*NB,NT*NG));
		A9_P3=sparse(zeros(NT*NB,NT*NG));
		A9_P=sparse(zeros(NT*NB,NT*NG));
		A9_U=sparse(zeros(NT*NB,NT*NG));
		A9_SC=sparse(zeros(NT*NB,NT*NG));
		A9_Q_g=sparse(zeros(NT*NB,NT*NG));
		A9_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A9_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A9_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A9_P_b_c=sparse(zeros(NT*NB,NT*NB));
		A9_P_b_dc=sparse(diag(ones(NT*NB,1)));
		A9_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A9_u_b_dc_vec=zeros(NT*NB,1);
		for t=1:NT
		   A9_u_b_dc_vec((t-1)*NB+1:t*NB)=-Pmax_b;
		end
		A9_u_b_dc=sparse(diag(A9_u_b_dc_vec));
		A9_SOC=sparse(zeros(NT*NB,NT*NB));
		A9_Q_b=sparse(zeros(NT*NB,NT*NB));
		A9_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A9_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A9_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A9_P_b1=sparse(zeros(NT*NB,NT*NB));
		A9_P_b2=sparse(zeros(NT*NB,NT*NB));
		A9_P_b3=sparse(zeros(NT*NB,NT*NB));
		A9_P_pcc=sparse(zeros(NT*NB,NT));
		A9_P_pcc_peak=sparse(zeros(NT*NB,1));
		A9_Q_pcc=sparse(zeros(NT*NB,NT));
		A9_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A9_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A9_v_n=sparse(zeros(NT*NB,NT*NN));
		A9_P_f=sparse(zeros(NT*NB,NT*NC));
		A9_P_f1=sparse(zeros(NT*NB,NT*NC));
		A9_P_f2=sparse(zeros(NT*NB,NT*NC));
		A9_P_f3=sparse(zeros(NT*NB,NT*NC));
		A9_Q_f=sparse(zeros(NT*NB,NT*NC));
		A9_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A9_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A9_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A9_P_n=sparse(zeros(NT*NB,NT*NN));
		A9_Q_n=sparse(zeros(NT*NB,NT*NN));
		A9=sparse([A9_P1,A9_P2,A9_P3,A9_P,A9_U,A9_SC,A9_Q_g,A9_Q_g1,A9_Q_g2,A9_Q_g3,A9_P_b_c,A9_P_b_dc,A9_u_b_c,A9_u_b_dc,A9_SOC,A9_Q_b,A9_Q_b1,A9_Q_b2,A9_Q_b3,A9_P_b1,A9_P_b2,A9_P_b3,...
					 A9_P_pcc,A9_P_pcc_peak,A9_Q_pcc,A9_Q_pcc_ab,A9_Aux_v_n,A9_v_n,A9_P_f,A9_P_f1,A9_P_f2,A9_P_f3,A9_Q_f,A9_Q_f1,A9_Q_f2,A9_Q_f3,A9_P_n,A9_Q_n]);
		b9=zeros(NT*NB,1);

		clear A9_P1;clear A9_P2;clear A9_P3;clear A9_P;clear A9_U;clear A9_SC;clear A9_Q_g;clear A9_Q_g1;clear A9_Q_g2;clear A9_Q_g3;clear A9_P_b_c;clear A9_P_b_dc;clear A9_u_b_c;clear A9_u_b_dc;clear A9_SOC;
		clear A9_Q_b;clear A9_Q_b1;clear A9_Q_b2;clear  A9_Q_b3;clear A9_P_b1;clear A9_P_b2;clear A9_P_b3;clear A9_P_pcc;clear A9_P_pcc_peak;clear A9_Q_pcc;clear A9_Q_pcc_ab;
		clear A9_Aux_v_n;clear A9_v_n;clear A9_P_f;clear A9_P_f1;clear A9_P_f2;clear A9_P_f3;clear A9_Q_f;clear A9_Q_f1;clear A9_Q_f2;clear A9_Q_f3;clear A9_P_n;clear A9_Q_n;

		%--- 10)u_ch+u_dch<=1
		A10_P1=sparse(zeros(NT*NB,NT*NG));
		A10_P2=sparse(zeros(NT*NB,NT*NG));
		A10_P3=sparse(zeros(NT*NB,NT*NG));
		A10_P=sparse(zeros(NT*NB,NT*NG));
		A10_U=sparse(zeros(NT*NB,NT*NG));
		A10_SC=sparse(zeros(NT*NB,NT*NG));
		A10_Q_g=sparse(zeros(NT*NB,NT*NG));
		A10_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A10_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A10_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A10_P_b_c=sparse(zeros(NT*NB,NT*NB));
		A10_P_b_dc=sparse(zeros(NT*NB,NT*NB));
		A10_u_b_c=sparse(diag(ones(NT*NB,1)));
		A10_u_b_dc=sparse(diag(ones(NT*NB,1)));
		A10_SOC=sparse(zeros(NT*NB,NT*NB));
		A10_Q_b=sparse(zeros(NT*NB,NT*NB));
		A10_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A10_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A10_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A10_P_b1=sparse(zeros(NT*NB,NT*NB));
		A10_P_b2=sparse(zeros(NT*NB,NT*NB));
		A10_P_b3=sparse(zeros(NT*NB,NT*NB));
		A10_P_pcc=sparse(zeros(NT*NB,NT));
		A10_P_pcc_peak=sparse(zeros(NT*NB,1));
		A10_Q_pcc=sparse(zeros(NT*NB,NT));
		A10_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A10_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A10_v_n=sparse(zeros(NT*NB,NT*NN));
		A10_P_f=sparse(zeros(NT*NB,NT*NC));
		A10_P_f1=sparse(zeros(NT*NB,NT*NC));
		A10_P_f2=sparse(zeros(NT*NB,NT*NC));
		A10_P_f3=sparse(zeros(NT*NB,NT*NC));
		A10_Q_f=sparse(zeros(NT*NB,NT*NC));
		A10_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A10_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A10_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A10_P_n=sparse(zeros(NT*NB,NT*NN));
		A10_Q_n=sparse(zeros(NT*NB,NT*NN));
		A10=sparse([A10_P1,A10_P2,A10_P3,A10_P,A10_U,A10_SC,A10_Q_g,A10_Q_g1,A10_Q_g2,A10_Q_g3,A10_P_b_c,A10_P_b_dc,A10_u_b_c,A10_u_b_dc,A10_SOC,A10_Q_b,A10_Q_b1,A10_Q_b2,A10_Q_b3,A10_P_b1,A10_P_b2,A10_P_b3,...
					 A10_P_pcc,A10_P_pcc_peak,A10_Q_pcc,A10_Q_pcc_ab,A10_Aux_v_n,A10_v_n,A10_P_f,A10_P_f1,A10_P_f2,A10_P_f3,A10_Q_f,A10_Q_f1,A10_Q_f2,A10_Q_f3,A10_P_n,A10_Q_n]);
		b10=ones(NT*NB,1);

		clear A10_P1;clear A10_P2;clear A10_P3;clear A10_P;clear A10_U;clear A10_SC;clear A10_Q_g;clear A10_Q_g1;clear A10_Q_g2;clear A10_Q_g3;clear A10_P_b_c;clear A10_P_b_dc;clear A10_u_b_c;clear A10_u_b_dc;clear A10_SOC;
		clear A10_Q_b;clear A10_Q_b1;clear A10_Q_b2;clear  A10_Q_b3;clear A10_P_b1;clear A10_P_b2;clear A10_P_b3;clear A10_P_pcc;clear A10_P_pcc_peak;clear A10_Q_pcc;clear A10_Q_pcc_ab;
		clear A10_Aux_v_n;clear A10_v_n;clear A10_P_f;clear A10_P_f1;clear A10_P_f2;clear A10_P_f3;clear A10_Q_f;clear A10_Q_f1;clear A10_Q_f2;clear A10_Q_f3;clear A10_P_n;clear A10_Q_n;


		%--- 11)Q_b<=P_b_dc*tan(fe)+M*u_b_c; tan(fe)=tan(acos(PFmax_b))>0
		A11_P1=sparse(zeros(NT*NB,NT*NG));
		A11_P2=sparse(zeros(NT*NB,NT*NG));
		A11_P3=sparse(zeros(NT*NB,NT*NG));
		A11_P=sparse(zeros(NT*NB,NT*NG));
		A11_U=sparse(zeros(NT*NB,NT*NG));
		A11_SC=sparse(zeros(NT*NB,NT*NG));
		A11_Q_g=sparse(zeros(NT*NB,NT*NG));
		A11_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A11_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A11_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A11_P_b_c=sparse(zeros(NT*NB,NT*NB));
		A11_P_b_dc_vec=zeros(NT*NB,1);
		for t=1:NT
		   A11_P_b_dc_vec((t-1)*NB+1:t*NB)=-1*tan(acos(PFmax_b));
		end
		A11_P_b_dc=sparse(diag(A11_P_b_dc_vec));
		A11_u_b_c=sparse(diag(-1*Q_b_ub));
		A11_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A11_SOC=sparse(zeros(NT*NB,NT*NB));
		A11_Q_b=sparse(diag(ones(NT*NB,1)));
		A11_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A11_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A11_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A11_P_b1=sparse(zeros(NT*NB,NT*NB));
		A11_P_b2=sparse(zeros(NT*NB,NT*NB));
		A11_P_b3=sparse(zeros(NT*NB,NT*NB));
		A11_P_pcc=sparse(zeros(NT*NB,NT));
		A11_P_pcc_peak=sparse(zeros(NT*NB,1));
		A11_Q_pcc=sparse(zeros(NT*NB,NT));
		A11_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A11_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A11_v_n=sparse(zeros(NT*NB,NT*NN));
		A11_P_f=sparse(zeros(NT*NB,NT*NC));
		A11_P_f1=sparse(zeros(NT*NB,NT*NC));
		A11_P_f2=sparse(zeros(NT*NB,NT*NC));
		A11_P_f3=sparse(zeros(NT*NB,NT*NC));
		A11_Q_f=sparse(zeros(NT*NB,NT*NC));
		A11_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A11_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A11_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A11_P_n=sparse(zeros(NT*NB,NT*NN));
		A11_Q_n=sparse(zeros(NT*NB,NT*NN));
		A11=sparse([A11_P1,A11_P2,A11_P3,A11_P,A11_U,A11_SC,A11_Q_g,A11_Q_g1,A11_Q_g2,A11_Q_g3,A11_P_b_c,A11_P_b_dc,A11_u_b_c,A11_u_b_dc,A11_SOC,A11_Q_b,A11_Q_b1,A11_Q_b2,A11_Q_b3,A11_P_b1,A11_P_b2,A11_P_b3,...
					 A11_P_pcc,A11_P_pcc_peak,A11_Q_pcc,A11_Q_pcc_ab,A11_Aux_v_n,A11_v_n,A11_P_f,A11_P_f1,A11_P_f2,A11_P_f3,A11_Q_f,A11_Q_f1,A11_Q_f2,A11_Q_f3,A11_P_n,A11_Q_n]);
		b11=zeros(NT*NB,1);

		clear A11_P1;clear A11_P2;clear A11_P3;clear A11_P;clear A11_U;clear A11_SC;clear A11_Q_g;clear A11_Q_g1;clear A11_Q_g2;clear A11_Q_g3;clear A11_P_b_c;clear A11_P_b_dc;clear A11_u_b_c;clear A11_u_b_dc;clear A11_SOC;
		clear A11_Q_b;clear A11_Q_b1;clear A11_Q_b2;clear  A11_Q_b3;clear A11_P_b1;clear A11_P_b2;clear A11_P_b3;clear A11_P_pcc;clear A11_P_pcc_peak;clear A11_Q_pcc;clear A11_Q_pcc_ab;
		clear A11_Aux_v_n;clear A11_v_n;clear A11_P_f;clear A11_P_f1;clear A11_P_f2;clear A11_P_f3;clear A11_Q_f;clear A11_Q_f1;clear A11_Q_f2;clear A11_Q_f3;clear A11_P_n;clear A11_Q_n;

		%--- 12)-M*u_b_c+P_b_dc*tan(fe)<=Q_b;; tan(fe)=tan(acos(PF_min))<0
		A12_P1=sparse(zeros(NT*NB,NT*NG));
		A12_P2=sparse(zeros(NT*NB,NT*NG));
		A12_P3=sparse(zeros(NT*NB,NT*NG));
		A12_P=sparse(zeros(NT*NB,NT*NG));
		A12_U=sparse(zeros(NT*NB,NT*NG));
		A12_SC=sparse(zeros(NT*NB,NT*NG));
		A12_Q_g=sparse(zeros(NT*NB,NT*NG));
		A12_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A12_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A12_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A12_P_b_c=sparse(zeros(NT*NB,NT*NB));
		A12_P_b_dc_vec=zeros(NT*NB,1);
		for t=1:NT
		   A12_P_b_dc_vec((t-1)*NB+1:t*NB)=tan(acos(PFmin_b));
		end
		A12_P_b_dc=sparse(diag(A12_P_b_dc_vec));
		A12_u_b_c=sparse(diag(-1*Q_b_ub));
		A12_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A12_SOC=sparse(zeros(NT*NB,NT*NB));
		A12_Q_b=sparse(-1*diag(ones(NT*NB,1)));
		A12_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A12_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A12_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A12_P_b1=sparse(zeros(NT*NB,NT*NB));
		A12_P_b2=sparse(zeros(NT*NB,NT*NB));
		A12_P_b3=sparse(zeros(NT*NB,NT*NB));
		A12_P_pcc=sparse(zeros(NT*NB,NT));
		A12_P_pcc_peak=sparse(zeros(NT*NB,1));
		A12_Q_pcc=sparse(zeros(NT*NB,NT));
		A12_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A12_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A12_v_n=sparse(zeros(NT*NB,NT*NN));
		A12_P_f=sparse(zeros(NT*NB,NT*NC));
		A12_P_f1=sparse(zeros(NT*NB,NT*NC));
		A12_P_f2=sparse(zeros(NT*NB,NT*NC));
		A12_P_f3=sparse(zeros(NT*NB,NT*NC));
		A12_Q_f=sparse(zeros(NT*NB,NT*NC));
		A12_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A12_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A12_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A12_P_n=sparse(zeros(NT*NB,NT*NN));
		A12_Q_n=sparse(zeros(NT*NB,NT*NN));
		A12=sparse([A12_P1,A12_P2,A12_P3,A12_P,A12_U,A12_SC,A12_Q_g,A12_Q_g1,A12_Q_g2,A12_Q_g3,A12_P_b_c,A12_P_b_dc,A12_u_b_c,A12_u_b_dc,A12_SOC,A12_Q_b,A12_Q_b1,A12_Q_b2,A12_Q_b3,A12_P_b1,A12_P_b2,A12_P_b3,...
					 A12_P_pcc,A12_P_pcc_peak,A12_Q_pcc,A12_Q_pcc_ab,A12_Aux_v_n,A12_v_n,A12_P_f,A12_P_f1,A12_P_f2,A12_P_f3,A12_Q_f,A12_Q_f1,A12_Q_f2,A12_Q_f3,A12_P_n,A12_Q_n]);
		b12=zeros(NT*NB,1);

		clear A12_P1;clear A12_P2;clear A12_P3;clear A12_P;clear A12_U;clear A12_SC;clear A12_Q_g;clear A12_Q_g1;clear A12_Q_g2;clear A12_Q_g3;clear A12_P_b_c;clear A12_P_b_dc;clear A12_u_b_c;clear A12_u_b_dc;clear A12_SOC;
		clear A12_Q_b;clear A12_Q_b1;clear A12_Q_b2;clear  A12_Q_b3;clear A12_P_b1;clear A12_P_b2;clear A12_P_b3;clear A12_P_pcc;clear A12_P_pcc_peak;clear A12_Q_pcc;clear A12_Q_pcc_ab;
		clear A12_Aux_v_n;clear A12_v_n;clear A12_P_f;clear A12_P_f1;clear A12_P_f2;clear A12_P_f3;clear A12_Q_f;clear A12_Q_f1;clear A12_Q_f2;clear A12_Q_f3;clear A12_P_n;clear A12_Q_n;


		%--- 13)Q_b<=P_b_c*tan(fe)+M*U_b_dc; tan(fe)=tan(acos(PFmax_b))
		A13_P1=sparse(zeros(NT*NB,NT*NG));
		A13_P2=sparse(zeros(NT*NB,NT*NG));
		A13_P3=sparse(zeros(NT*NB,NT*NG));
		A13_P=sparse(zeros(NT*NB,NT*NG));
		A13_U=sparse(zeros(NT*NB,NT*NG));
		A13_SC=sparse(zeros(NT*NB,NT*NG));
		A13_Q_g=sparse(zeros(NT*NB,NT*NG));
		A13_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A13_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A13_Q_g3=sparse(zeros(NT*NB,NT*NG));
		A13_P_b_c_vec=zeros(NT*NB,1);
		for t=1:NT
		   A13_P_b_c_vec((t-1)*NB+1:t*NB)=-1*tan(acos(PFmax_b));
		end
		A13_P_b_c=sparse(diag(A13_P_b_c_vec));
		A13_P_b_dc=sparse(zeros(NT*NB,NT*NB));
		A13_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A13_u_b_dc=sparse(diag(-1*Q_b_ub));
		A13_SOC=sparse(zeros(NT*NB,NT*NB));
		A13_Q_b=sparse(diag(ones(NT*NB,1)));
		A13_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A13_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A13_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A13_P_b1=sparse(zeros(NT*NB,NT*NB));
		A13_P_b2=sparse(zeros(NT*NB,NT*NB));
		A13_P_b3=sparse(zeros(NT*NB,NT*NB));
		A13_P_pcc=sparse(zeros(NT*NB,NT));
		A13_P_pcc_peak=sparse(zeros(NT*NB,1));
		A13_Q_pcc=sparse(zeros(NT*NB,NT));
		A13_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A13_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A13_v_n=sparse(zeros(NT*NB,NT*NN));
		A13_P_f=sparse(zeros(NT*NB,NT*NC));
		A13_P_f1=sparse(zeros(NT*NB,NT*NC));
		A13_P_f2=sparse(zeros(NT*NB,NT*NC));
		A13_P_f3=sparse(zeros(NT*NB,NT*NC));
		A13_Q_f=sparse(zeros(NT*NB,NT*NC));
		A13_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A13_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A13_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A13_P_n=sparse(zeros(NT*NB,NT*NN));
		A13_Q_n=sparse(zeros(NT*NB,NT*NN));
		A13=sparse([A13_P1,A13_P2,A13_P3,A13_P,A13_U,A13_SC,A13_Q_g,A13_Q_g1,A13_Q_g2,A13_Q_g3,A13_P_b_c,A13_P_b_dc,A13_u_b_c,A13_u_b_dc,A13_SOC,A13_Q_b,A13_Q_b1,A13_Q_b2,A13_Q_b3,A13_P_b1,A13_P_b2,A13_P_b3,...
					 A13_P_pcc,A13_P_pcc_peak,A13_Q_pcc,A13_Q_pcc_ab,A13_Aux_v_n,A13_v_n,A13_P_f,A13_P_f1,A13_P_f2,A13_P_f3,A13_Q_f,A13_Q_f1,A13_Q_f2,A13_Q_f3,A13_P_n,A13_Q_n]);
		b13=zeros(NT*NB,1);

		clear A13_P1;clear A13_P2;clear A13_P3;clear A13_P;clear A13_U;clear A13_SC;clear A13_Q_g;clear A13_Q_g1;clear A13_Q_g2;clear A13_Q_g3;clear A13_P_b_c;clear A13_P_b_dc;clear A13_u_b_c;clear A13_u_b_dc;clear A13_SOC;
		clear A13_Q_b;clear A13_Q_b1;clear A13_Q_b2;clear  A13_Q_b3;clear A13_P_b1;clear A13_P_b2;clear A13_P_b3;clear A13_P_pcc;clear A13_P_pcc_peak;clear A13_Q_pcc;clear A13_Q_pcc_ab;
		clear A13_Aux_v_n;clear A13_v_n;clear A13_P_f;clear A13_P_f1;clear A13_P_f2;clear A13_P_f3;clear A13_Q_f;clear A13_Q_f1;clear A13_Q_f2;clear A13_Q_f3;clear A13_P_n;clear A13_Q_n;

		%--- 14)-M*U_b_dc+P_b_c*tan(fe)<=Q_b;; tan(fe)=tan(acos(PF_min))<0
		A14_P1=sparse(zeros(NT*NB,NT*NG));
		A14_P2=sparse(zeros(NT*NB,NT*NG));
		A14_P3=sparse(zeros(NT*NB,NT*NG));
		A14_P=sparse(zeros(NT*NB,NT*NG));
		A14_U=sparse(zeros(NT*NB,NT*NG));
		A14_SC=sparse(zeros(NT*NB,NT*NG));
		A14_Q_g=sparse(zeros(NT*NB,NT*NG));
		A14_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A14_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A14_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A14_P_b_c_vec=zeros(NT*NB,1);
		for t=1:NT
		   A14_P_b_c_vec((t-1)*NB+1:t*NB)=tan(acos(PFmin_b));
		end
		A14_P_b_c=sparse(diag(A14_P_b_c_vec));

		A14_P_b_dc=sparse(zeros(NT*NB,NT*NB));
		A14_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A14_u_b_dc=sparse(diag(-1*Q_b_ub));
		A14_SOC=sparse(zeros(NT*NB,NT*NB));
		A14_Q_b=sparse(-1*diag(ones(NT*NB,1)));
		A14_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A14_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A14_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A14_P_b1=sparse(zeros(NT*NB,NT*NB));
		A14_P_b2=sparse(zeros(NT*NB,NT*NB));
		A14_P_b3=sparse(zeros(NT*NB,NT*NB));
		A14_P_pcc=sparse(zeros(NT*NB,NT));
		A14_P_pcc_peak=sparse(zeros(NT*NB,1));
		A14_Q_pcc=sparse(zeros(NT*NB,NT));
		A14_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A14_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A14_v_n=sparse(zeros(NT*NB,NT*NN));
		A14_P_f=sparse(zeros(NT*NB,NT*NC));
		A14_P_f1=sparse(zeros(NT*NB,NT*NC));
		A14_P_f2=sparse(zeros(NT*NB,NT*NC));
		A14_P_f3=sparse(zeros(NT*NB,NT*NC));
		A14_Q_f=sparse(zeros(NT*NB,NT*NC));
		A14_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A14_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A14_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A14_P_n=sparse(zeros(NT*NB,NT*NN));
		A14_Q_n=sparse(zeros(NT*NB,NT*NN));
		A14=sparse([A14_P1,A14_P2,A14_P3,A14_P,A14_U,A14_SC,A14_Q_g,A14_Q_g1,A14_Q_g2,A14_Q_g3,A14_P_b_c,A14_P_b_dc,A14_u_b_c,A14_u_b_dc,A14_SOC,A14_Q_b,A14_Q_b1,A14_Q_b2,A14_Q_b3,A14_P_b1,A14_P_b2,A14_P_b3,...
					 A14_P_pcc,A14_P_pcc_peak,A14_Q_pcc,A14_Q_pcc_ab,A14_Aux_v_n,A14_v_n,A14_P_f,A14_P_f1,A14_P_f2,A14_P_f3,A14_Q_f,A14_Q_f1,A14_Q_f2,A14_Q_f3,A14_P_n,A14_Q_n]);
		b14=zeros(NT*NB,1);

		clear A14_P1;clear A14_P2;clear A14_P3;clear A14_P;clear A14_U;clear A14_SC;clear A14_Q_g;clear A14_Q_g1;clear A14_Q_g2;clear A14_Q_g3;clear A14_P_b_c;clear A14_P_b_dc;clear A14_u_b_c;clear A14_u_b_dc;clear A14_SOC;
		clear A14_Q_b;clear A14_Q_b1;clear A14_Q_b2;clear  A14_Q_b3;clear A14_P_b1;clear A14_P_b2;clear A14_P_b3;clear A14_P_pcc;clear A14_P_pcc_peak;clear A14_Q_pcc;clear A14_Q_pcc_ab;
		clear A14_Aux_v_n;clear A14_v_n;clear A14_P_f;clear A14_P_f1;clear A14_P_f2;clear A14_P_f3;clear A14_Q_f;clear A14_Q_f1;clear A14_Q_f2;clear A14_Q_f3;clear A14_P_n;clear A14_Q_n;

		%--- 15)P_b1+P_b2+P_b3>=P_b_dc-P_b_c;
		A15_P1=sparse(zeros(NT*NB,NT*NG));
		A15_P2=sparse(zeros(NT*NB,NT*NG));
		A15_P3=sparse(zeros(NT*NB,NT*NG));
		A15_P=sparse(zeros(NT*NB,NT*NG));
		A15_U=sparse(zeros(NT*NB,NT*NG));
		A15_SC=sparse(zeros(NT*NB,NT*NG));
		A15_Q_g=sparse(zeros(NT*NB,NT*NG));
		A15_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A15_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A15_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A15_P_b_c=sparse(-1*diag(ones(NT*NB,1)));
		A15_P_b_dc=sparse(diag(ones(NT*NB,1)));
		A15_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A15_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A15_SOC=sparse(zeros(NT*NB,NT*NB));
		A15_Q_b=sparse(zeros(NT*NB,NT*NB));
		A15_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A15_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A15_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A15_P_b1=sparse(-1*diag(ones(NT*NB,1)));
		A15_P_b2=sparse(-1*diag(ones(NT*NB,1)));
		A15_P_b3=sparse(-1*diag(ones(NT*NB,1)));
		A15_P_pcc=sparse(zeros(NT*NB,NT));
		A15_P_pcc_peak=sparse(zeros(NT*NB,1));
		A15_Q_pcc=sparse(zeros(NT*NB,NT));
		A15_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A15_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A15_v_n=sparse(zeros(NT*NB,NT*NN));
		A15_P_f=sparse(zeros(NT*NB,NT*NC));
		A15_P_f1=sparse(zeros(NT*NB,NT*NC));
		A15_P_f2=sparse(zeros(NT*NB,NT*NC));
		A15_P_f3=sparse(zeros(NT*NB,NT*NC));
		A15_Q_f=sparse(zeros(NT*NB,NT*NC));
		A15_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A15_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A15_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A15_P_n=sparse(zeros(NT*NB,NT*NN));
		A15_Q_n=sparse(zeros(NT*NB,NT*NN));
		A15=sparse([A15_P1,A15_P2,A15_P3,A15_P,A15_U,A15_SC,A15_Q_g,A15_Q_g1,A15_Q_g2,A15_Q_g3,A15_P_b_c,A15_P_b_dc,A15_u_b_c,A15_u_b_dc,A15_SOC,A15_Q_b,A15_Q_b1,A15_Q_b2,A15_Q_b3,A15_P_b1,A15_P_b2,A15_P_b3,...
					 A15_P_pcc,A15_P_pcc_peak,A15_Q_pcc,A15_Q_pcc_ab,A15_Aux_v_n,A15_v_n,A15_P_f,A15_P_f1,A15_P_f2,A15_P_f3,A15_Q_f,A15_Q_f1,A15_Q_f2,A15_Q_f3,A15_P_n,A15_Q_n]);
		b15=zeros(NT*NB,1);

		clear A15_P1;clear A15_P2;clear A15_P3;clear A15_P;clear A15_U;clear A15_SC;clear A15_Q_g;clear A15_Q_g1;clear A15_Q_g2;clear A15_Q_g3;clear A15_P_b_c;clear A15_P_b_dc;clear A15_u_b_c;clear A15_u_b_dc;clear A15_SOC;
		clear A15_Q_b;clear A15_Q_b1;clear A15_Q_b2;clear  A15_Q_b3;clear A15_P_b1;clear A15_P_b2;clear A15_P_b3;clear A15_P_pcc;clear A15_P_pcc_peak;clear A15_Q_pcc;clear A15_Q_pcc_ab;
		clear A15_Aux_v_n;clear A15_v_n;clear A15_P_f;clear A15_P_f1;clear A15_P_f2;clear A15_P_f3;clear A15_Q_f;clear A15_Q_f1;clear A15_Q_f2;clear A15_Q_f3;clear A15_P_n;clear A15_Q_n;

		%--- 16)P_b1+P_b2+P_b3>=P_b_c-P_b_dc;
		A16_P1=sparse(zeros(NT*NB,NT*NG));
		A16_P2=sparse(zeros(NT*NB,NT*NG));
		A16_P3=sparse(zeros(NT*NB,NT*NG));
		A16_P=sparse(zeros(NT*NB,NT*NG));
		A16_U=sparse(zeros(NT*NB,NT*NG));
		A16_SC=sparse(zeros(NT*NB,NT*NG));
		A16_Q_g=sparse(zeros(NT*NB,NT*NG));
		A16_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A16_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A16_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A16_P_b_c=sparse(diag(ones(NT*NB,1)));
		A16_P_b_dc=sparse(-1*diag(ones(NT*NB,1)));
		A16_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A16_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A16_SOC=sparse(zeros(NT*NB,NT*NB));
		A16_Q_b=sparse(zeros(NT*NB,NT*NB));
		A16_Q_b1=sparse(zeros(NT*NB,NT*NB));
		A16_Q_b2=sparse(zeros(NT*NB,NT*NB));
		A16_Q_b3=sparse(zeros(NT*NB,NT*NB));
		A16_P_b1=sparse(-1*diag(ones(NT*NB,1)));
		A16_P_b2=sparse(-1*diag(ones(NT*NB,1)));
		A16_P_b3=sparse(-1*diag(ones(NT*NB,1)));
		A16_P_pcc=sparse(zeros(NT*NB,NT));
		A16_P_pcc_peak=sparse(zeros(NT*NB,1));
		A16_Q_pcc=sparse(zeros(NT*NB,NT));
		A16_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A16_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A16_v_n=sparse(zeros(NT*NB,NT*NN));
		A16_P_f=sparse(zeros(NT*NB,NT*NC));
		A16_P_f1=sparse(zeros(NT*NB,NT*NC));
		A16_P_f2=sparse(zeros(NT*NB,NT*NC));
		A16_P_f3=sparse(zeros(NT*NB,NT*NC));
		A16_Q_f=sparse(zeros(NT*NB,NT*NC));
		A16_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A16_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A16_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A16_P_n=sparse(zeros(NT*NB,NT*NN));
		A16_Q_n=sparse(zeros(NT*NB,NT*NN));
		A16=sparse([A16_P1,A16_P2,A16_P3,A16_P,A16_U,A16_SC,A16_Q_g,A16_Q_g1,A16_Q_g2,A16_Q_g3,A16_P_b_c,A16_P_b_dc,A16_u_b_c,A16_u_b_dc,A16_SOC,A16_Q_b,A16_Q_b1,A16_Q_b2,A16_Q_b3,A16_P_b1,A16_P_b2,A16_P_b3,...
					 A16_P_pcc,A16_P_pcc_peak,A16_Q_pcc,A16_Q_pcc_ab,A16_Aux_v_n,A16_v_n,A16_P_f,A16_P_f1,A16_P_f2,A16_P_f3,A16_Q_f,A16_Q_f1,A16_Q_f2,A16_Q_f3,A16_P_n,A16_Q_n]);
		b16=zeros(NT*NB,1);

		clear A16_P1;clear A16_P2;clear A16_P3;clear A16_P;clear A16_U;clear A16_SC;clear A16_Q_g;clear A16_Q_g1;clear A16_Q_g2;clear A16_Q_g3;clear A16_P_b_c;clear A16_P_b_dc;clear A16_u_b_c;clear A16_u_b_dc;clear A16_SOC;
		clear A16_Q_b;clear A16_Q_b1;clear A16_Q_b2;clear  A16_Q_b3;clear A16_P_b1;clear A16_P_b2;clear A16_P_b3;clear A16_P_pcc;clear A16_P_pcc_peak;clear A16_Q_pcc;clear A16_Q_pcc_ab;
		clear A16_Aux_v_n;clear A16_v_n;clear A16_P_f;clear A16_P_f1;clear A16_P_f2;clear A16_P_f3;clear A16_Q_f;clear A16_Q_f1;clear A16_Q_f2;clear A16_Q_f3;clear A16_P_n;clear A16_Q_n;

		%--- 17)Q_b1+Q_b2+Q_b3>=Q_b;
		A17_P1=sparse(zeros(NT*NB,NT*NG));
		A17_P2=sparse(zeros(NT*NB,NT*NG));
		A17_P3=sparse(zeros(NT*NB,NT*NG));
		A17_P=sparse(zeros(NT*NB,NT*NG));
		A17_U=sparse(zeros(NT*NB,NT*NG));
		A17_SC=sparse(zeros(NT*NB,NT*NG));
		A17_Q_g=sparse(zeros(NT*NB,NT*NG));
		A17_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A17_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A17_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A17_P_b_c=sparse(zeros(NT*NB,NT*NB));
		A17_P_b_dc=sparse(zeros(NT*NB,NT*NB));
		A17_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A17_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A17_SOC=sparse(zeros(NT*NB,NT*NB));
		A17_Q_b=sparse(diag(ones(NT*NB,1)));
		A17_Q_b1=sparse(-1*diag(ones(NT*NB,1)));
		A17_Q_b2=sparse(-1*diag(ones(NT*NB,1)));
		A17_Q_b3=sparse(-1*diag(ones(NT*NB,1)));
		A17_P_b1=sparse(zeros(NT*NB,NT*NB));
		A17_P_b2=sparse(zeros(NT*NB,NT*NB));
		A17_P_b3=sparse(zeros(NT*NB,NT*NB));
		A17_P_pcc=sparse(zeros(NT*NB,NT));
		A17_P_pcc_peak=sparse(zeros(NT*NB,1));
		A17_Q_pcc=sparse(zeros(NT*NB,NT));
		A17_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A17_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A17_v_n=sparse(zeros(NT*NB,NT*NN));
		A17_P_f=sparse(zeros(NT*NB,NT*NC));
		A17_P_f1=sparse(zeros(NT*NB,NT*NC));
		A17_P_f2=sparse(zeros(NT*NB,NT*NC));
		A17_P_f3=sparse(zeros(NT*NB,NT*NC));
		A17_Q_f=sparse(zeros(NT*NB,NT*NC));
		A17_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A17_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A17_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A17_P_n=sparse(zeros(NT*NB,NT*NN));
		A17_Q_n=sparse(zeros(NT*NB,NT*NN));
		A17=sparse([A17_P1,A17_P2,A17_P3,A17_P,A17_U,A17_SC,A17_Q_g,A17_Q_g1,A17_Q_g2,A17_Q_g3,A17_P_b_c,A17_P_b_dc,A17_u_b_c,A17_u_b_dc,A17_SOC,A17_Q_b,A17_Q_b1,A17_Q_b2,A17_Q_b3,A17_P_b1,A17_P_b2,A17_P_b3,...
					 A17_P_pcc,A17_P_pcc_peak,A17_Q_pcc,A17_Q_pcc_ab,A17_Aux_v_n,A17_v_n,A17_P_f,A17_P_f1,A17_P_f2,A17_P_f3,A17_Q_f,A17_Q_f1,A17_Q_f2,A17_Q_f3,A17_P_n,A17_Q_n]);
		b17=zeros(NT*NB,1);

		clear A17_P1;clear A17_P2;clear A17_P3;clear A17_P;clear A17_U;clear A17_SC;clear A17_Q_g;clear A17_Q_g1;clear A17_Q_g2;clear A17_Q_g3;clear A17_P_b_c;clear A17_P_b_dc;clear A17_u_b_c;clear A17_u_b_dc;clear A17_SOC;
		clear A17_Q_b;clear A17_Q_b1;clear A17_Q_b2;clear  A17_Q_b3;clear A17_P_b1;clear A17_P_b2;clear A17_P_b3;clear A17_P_pcc;clear A17_P_pcc_peak;clear A17_Q_pcc;clear A17_Q_pcc_ab;
		clear A17_Aux_v_n;clear A17_v_n;clear A17_P_f;clear A17_P_f1;clear A17_P_f2;clear A17_P_f3;clear A17_Q_f;clear A17_Q_f1;clear A17_Q_f2;clear A17_Q_f3;clear A17_P_n;clear A17_Q_n;

		%--- 18)Q_b1+Q_b2+Q_b3>=-Q_b;
		A18_P1=sparse(zeros(NT*NB,NT*NG));
		A18_P2=sparse(zeros(NT*NB,NT*NG));
		A18_P3=sparse(zeros(NT*NB,NT*NG));
		A18_P=sparse(zeros(NT*NB,NT*NG));
		A18_U=sparse(zeros(NT*NB,NT*NG));
		A18_SC=sparse(zeros(NT*NB,NT*NG));
		A18_Q_g=sparse(zeros(NT*NB,NT*NG));
		A18_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A18_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A18_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A18_P_b_c=sparse(zeros(NT*NB,NT*NB));
		A18_P_b_dc=sparse(zeros(NT*NB,NT*NB));
		A18_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A18_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A18_SOC=sparse(zeros(NT*NB,NT*NB));
		A18_Q_b=sparse(-1*diag(ones(NT*NB,1)));
		A18_Q_b1=sparse(-1*diag(ones(NT*NB,1)));
		A18_Q_b2=sparse(-1*diag(ones(NT*NB,1)));
		A18_Q_b3=sparse(-1*diag(ones(NT*NB,1)));
		A18_P_b1=sparse(zeros(NT*NB,NT*NB));
		A18_P_b2=sparse(zeros(NT*NB,NT*NB));
		A18_P_b3=sparse(zeros(NT*NB,NT*NB));
		A18_P_pcc=sparse(zeros(NT*NB,NT));
		A18_P_pcc_peak=sparse(zeros(NT*NB,1));
		A18_Q_pcc=sparse(zeros(NT*NB,NT));
		A18_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A18_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A18_v_n=sparse(zeros(NT*NB,NT*NN));
		A18_P_f=sparse(zeros(NT*NB,NT*NC));
		A18_P_f1=sparse(zeros(NT*NB,NT*NC));
		A18_P_f2=sparse(zeros(NT*NB,NT*NC));
		A18_P_f3=sparse(zeros(NT*NB,NT*NC));
		A18_Q_f=sparse(zeros(NT*NB,NT*NC));
		A18_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A18_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A18_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A18_P_n=sparse(zeros(NT*NB,NT*NN));
		A18_Q_n=sparse(zeros(NT*NB,NT*NN));
		A18=sparse([A18_P1,A18_P2,A18_P3,A18_P,A18_U,A18_SC,A18_Q_g,A18_Q_g1,A18_Q_g2,A18_Q_g3,A18_P_b_c,A18_P_b_dc,A18_u_b_c,A18_u_b_dc,A18_SOC,A18_Q_b,A18_Q_b1,A18_Q_b2,A18_Q_b3,A18_P_b1,A18_P_b2,A18_P_b3,...
					 A18_P_pcc,A18_P_pcc_peak,A18_Q_pcc,A18_Q_pcc_ab,A18_Aux_v_n,A18_v_n,A18_P_f,A18_P_f1,A18_P_f2,A18_P_f3,A18_Q_f,A18_Q_f1,A18_Q_f2,A18_Q_f3,A18_P_n,A18_Q_n]);
		b18=zeros(NT*NB,1);

		clear A18_P1;clear A18_P2;clear A18_P3;clear A18_P;clear A18_U;clear A18_SC;clear A18_Q_g;clear A18_Q_g1;clear A18_Q_g2;clear A18_Q_g3;clear A18_P_b_c;clear A18_P_b_dc;clear A18_u_b_c;clear A18_u_b_dc;clear A18_SOC;
		clear A18_Q_b;clear A18_Q_b1;clear A18_Q_b2;clear  A18_Q_b3;clear A18_P_b1;clear A18_P_b2;clear A18_P_b3;clear A18_P_pcc;clear A18_P_pcc_peak;clear A18_Q_pcc;clear A18_Q_pcc_ab;
		clear A18_Aux_v_n;clear A18_v_n;clear A18_P_f;clear A18_P_f1;clear A18_P_f2;clear A18_P_f3;clear A18_Q_f;clear A18_Q_f1;clear A18_Q_f2;clear A18_Q_f3;clear A18_P_n;clear A18_Q_n;

		%--- 19)Sum(C_P_b*P_b)+Sum(C_Q_b*Q_b)<=Smax_b^2;
		A19_P1=sparse(zeros(NT*NB,NT*NG));
		A19_P2=sparse(zeros(NT*NB,NT*NG));
		A19_P3=sparse(zeros(NT*NB,NT*NG));
		A19_P=sparse(zeros(NT*NB,NT*NG));
		A19_U=sparse(zeros(NT*NB,NT*NG));
		A19_SC=sparse(zeros(NT*NB,NT*NG));
		A19_Q_g=sparse(zeros(NT*NB,NT*NG));
		A19_Q_g1=sparse(zeros(NT*NB,NT*NG));
		A19_Q_g2=sparse(zeros(NT*NB,NT*NG));
		A19_Q_g3=sparse(zeros(NT*NB,NT*NG)); 
		A19_P_b_c=sparse(zeros(NT*NB,NT*NB));
		A19_P_b_dc=sparse(zeros(NT*NB,NT*NB));
		A19_u_b_c=sparse(zeros(NT*NB,NT*NB));
		A19_u_b_dc=sparse(zeros(NT*NB,NT*NB));
		A19_SOC=sparse(zeros(NT*NB,NT*NB));
		A19_Q_b=sparse(zeros(NT*NB,NT*NB));
		A19_Q_b1=sparse(diag(C_Q_b1));
		A19_Q_b2=sparse(diag(C_Q_b2));
		A19_Q_b3=sparse(diag(C_Q_b3));
		A19_P_b1=sparse(diag(C_P_b1));
		A19_P_b2=sparse(diag(C_P_b2));
		A19_P_b3=sparse(diag(C_P_b3));
		A19_P_pcc=sparse(zeros(NT*NB,NT));
		A19_P_pcc_peak=sparse(zeros(NT*NB,1));
		A19_Q_pcc=sparse(zeros(NT*NB,NT));
		A19_Q_pcc_ab=sparse(zeros(NT*NB,NT));
		A19_Aux_v_n=sparse(zeros(NT*NB,NT*NN));
		A19_v_n=sparse(zeros(NT*NB,NT*NN));
		A19_P_f=sparse(zeros(NT*NB,NT*NC));
		A19_P_f1=sparse(zeros(NT*NB,NT*NC));
		A19_P_f2=sparse(zeros(NT*NB,NT*NC));
		A19_P_f3=sparse(zeros(NT*NB,NT*NC));
		A19_Q_f=sparse(zeros(NT*NB,NT*NC));
		A19_Q_f1=sparse(zeros(NT*NB,NT*NC));
		A19_Q_f2=sparse(zeros(NT*NB,NT*NC));
		A19_Q_f3=sparse(zeros(NT*NB,NT*NC));
		A19_P_n=sparse(zeros(NT*NB,NT*NN));
		A19_Q_n=sparse(zeros(NT*NB,NT*NN));
		A19=sparse([A19_P1,A19_P2,A19_P3,A19_P,A19_U,A19_SC,A19_Q_g,A19_Q_g1,A19_Q_g2,A19_Q_g3,A19_P_b_c,A19_P_b_dc,A19_u_b_c,A19_u_b_dc,A19_SOC,A19_Q_b,A19_Q_b1,A19_Q_b2,A19_Q_b3,A19_P_b1,A19_P_b2,A19_P_b3,...
					 A19_P_pcc,A19_P_pcc_peak,A19_Q_pcc,A19_Q_pcc_ab,A19_Aux_v_n,A19_v_n,A19_P_f,A19_P_f1,A19_P_f2,A19_P_f3,A19_Q_f,A19_Q_f1,A19_Q_f2,A19_Q_f3,A19_P_n,A19_Q_n]);
		b19=zeros(NT*NB,1);
		for t=1:NT
		   b19((t-1)*NB+1:t*NB)=Smax_b.^2;
		end
		clear A19_P1;clear A19_P2;clear A19_P3;clear A19_P;clear A19_U;clear A19_SC;clear A19_Q_g;clear A19_Q_g1;clear A19_Q_g2;clear A19_Q_g3;clear A19_P_b_c;clear A19_P_b_dc;clear A19_u_b_c;clear A19_u_b_dc;clear A19_SOC;
		clear A19_Q_b;clear A19_Q_b1;clear A19_Q_b2;clear  A19_Q_b3;clear A19_P_b1;clear A19_P_b2;clear A19_P_b3;clear A19_P_pcc;clear A19_P_pcc_peak;clear A19_Q_pcc;clear A19_Q_pcc_ab;
		clear A19_Aux_v_n;clear A19_v_n;clear A19_P_f;clear A19_P_f1;clear A19_P_f2;clear A19_P_f3;clear A19_Q_f;clear A19_Q_f1;clear A19_Q_f2;clear A19_Q_f3;clear A19_P_n;clear A19_Q_n;

		%--- 20)P_pcc_peak>=P_pcc
		A20_P1=sparse(zeros(NT,NT*NG));
		A20_P2=sparse(zeros(NT,NT*NG));
		A20_P3=sparse(zeros(NT,NT*NG));
		A20_P=sparse(zeros(NT,NT*NG));
		A20_U=sparse(zeros(NT,NT*NG));
		A20_SC=sparse(zeros(NT,NT*NG));
		A20_Q_g=sparse(zeros(NT,NT*NG));
		A20_Q_g1=sparse(zeros(NT,NT*NG));
		A20_Q_g2=sparse(zeros(NT,NT*NG));
		A20_Q_g3=sparse(zeros(NT,NT*NG)); 
		A20_P_b_c=sparse(zeros(NT,NT*NB));
		A20_P_b_dc=sparse(zeros(NT,NT*NB));
		A20_u_b_c=sparse(zeros(NT,NT*NB));
		A20_u_b_dc=sparse(zeros(NT,NT*NB));
		A20_SOC=sparse(zeros(NT,NT*NB));
		A20_Q_b=sparse(zeros(NT,NT*NB));
		A20_Q_b1=sparse(zeros(NT,NT*NB));
		A20_Q_b2=sparse(zeros(NT,NT*NB));
		A20_Q_b3=sparse(zeros(NT,NT*NB));
		A20_P_b1=sparse(zeros(NT,NT*NB));
		A20_P_b2=sparse(zeros(NT,NT*NB));
		A20_P_b3=sparse(zeros(NT,NT*NB));
		A20_P_pcc=sparse(diag(ones(NT,1)));
		A20_P_pcc_peak=-1*ones(NT,1);
		A20_Q_pcc=sparse(zeros(NT,NT));
		A20_Q_pcc_ab=sparse(zeros(NT,NT));
		A20_Aux_v_n=sparse(zeros(NT,NT*NN));
		A20_v_n=sparse(zeros(NT,NT*NN));
		A20_P_f=sparse(zeros(NT,NT*NC));
		A20_P_f1=sparse(zeros(NT,NT*NC));
		A20_P_f2=sparse(zeros(NT,NT*NC));
		A20_P_f3=sparse(zeros(NT,NT*NC));
		A20_Q_f=sparse(zeros(NT,NT*NC));
		A20_Q_f1=sparse(zeros(NT,NT*NC));
		A20_Q_f2=sparse(zeros(NT,NT*NC));
		A20_Q_f3=sparse(zeros(NT,NT*NC));
		A20_P_n=sparse(zeros(NT,NT*NN));
		A20_Q_n=sparse(zeros(NT,NT*NN));
		A20=sparse([A20_P1,A20_P2,A20_P3,A20_P,A20_U,A20_SC,A20_Q_g,A20_Q_g1,A20_Q_g2,A20_Q_g3,A20_P_b_c,A20_P_b_dc,A20_u_b_c,A20_u_b_dc,A20_SOC,A20_Q_b,A20_Q_b1,A20_Q_b2,A20_Q_b3,A20_P_b1,A20_P_b2,A20_P_b3,...
					 A20_P_pcc,A20_P_pcc_peak,A20_Q_pcc,A20_Q_pcc_ab,A20_Aux_v_n,A20_v_n,A20_P_f,A20_P_f1,A20_P_f2,A20_P_f3,A20_Q_f,A20_Q_f1,A20_Q_f2,A20_Q_f3,A20_P_n,A20_Q_n]);
		b20=zeros(NT,1);

		clear A20_P1;clear A20_P2;clear A20_P3;clear A20_P;clear A20_U;clear A20_SC;clear A20_Q_g;clear A20_Q_g1;clear A20_Q_g2;clear A20_Q_g3;clear A20_P_b_c;clear A20_P_b_dc;clear A20_u_b_c;clear A20_u_b_dc;clear A20_SOC;
		clear A20_Q_b;clear A20_Q_b1;clear A20_Q_b2;clear  A20_Q_b3;clear A20_P_b1;clear A20_P_b2;clear A20_P_b3;clear A20_P_pcc;clear A20_P_pcc_peak;clear A20_Q_pcc;clear A20_Q_pcc_ab;
		clear A20_Aux_v_n;clear A20_v_n;clear A20_P_f;clear A20_P_f1;clear A20_P_f2;clear A20_P_f3;clear A20_Q_f;clear A20_Q_f1;clear A20_Q_f2;clear A20_Q_f3;clear A20_P_n;clear A20_Q_n;


		%--- 21)Q_pcc_ab>=Q_pcc
		A21_P1=sparse(zeros(NT,NT*NG));
		A21_P2=sparse(zeros(NT,NT*NG));
		A21_P3=sparse(zeros(NT,NT*NG));
		A21_P=sparse(zeros(NT,NT*NG));
		A21_U=sparse(zeros(NT,NT*NG));
		A21_SC=sparse(zeros(NT,NT*NG));
		A21_Q_g=sparse(zeros(NT,NT*NG));
		A21_Q_g1=sparse(zeros(NT,NT*NG));
		A21_Q_g2=sparse(zeros(NT,NT*NG));
		A21_Q_g3=sparse(zeros(NT,NT*NG)); 
		A21_P_b_c=sparse(zeros(NT,NT*NB));
		A21_P_b_dc=sparse(zeros(NT,NT*NB));
		A21_u_b_c=sparse(zeros(NT,NT*NB));
		A21_u_b_dc=sparse(zeros(NT,NT*NB));
		A21_SOC=sparse(zeros(NT,NT*NB));
		A21_Q_b=sparse(zeros(NT,NT*NB));
		A21_Q_b1=sparse(zeros(NT,NT*NB));
		A21_Q_b2=sparse(zeros(NT,NT*NB));
		A21_Q_b3=sparse(zeros(NT,NT*NB));
		A21_P_b1=sparse(zeros(NT,NT*NB));
		A21_P_b2=sparse(zeros(NT,NT*NB));
		A21_P_b3=sparse(zeros(NT,NT*NB));
		A21_P_pcc=sparse(zeros(NT,NT));
		A21_P_pcc_peak=sparse(zeros(NT,1));
		A21_Q_pcc=sparse(diag(ones(NT,1)));
		A21_Q_pcc_ab=sparse(diag(-1*ones(NT,1)));
		A21_Aux_v_n=sparse(zeros(NT,NT*NN));
		A21_v_n=sparse(zeros(NT,NT*NN));
		A21_P_f=sparse(zeros(NT,NT*NC));
		A21_P_f1=sparse(zeros(NT,NT*NC));
		A21_P_f2=sparse(zeros(NT,NT*NC));
		A21_P_f3=sparse(zeros(NT,NT*NC));
		A21_Q_f=sparse(zeros(NT,NT*NC));
		A21_Q_f1=sparse(zeros(NT,NT*NC));
		A21_Q_f2=sparse(zeros(NT,NT*NC));
		A21_Q_f3=sparse(zeros(NT,NT*NC));
		A21_P_n=sparse(zeros(NT,NT*NN));
		A21_Q_n=sparse(zeros(NT,NT*NN));
		A21=sparse([A21_P1,A21_P2,A21_P3,A21_P,A21_U,A21_SC,A21_Q_g,A21_Q_g1,A21_Q_g2,A21_Q_g3,A21_P_b_c,A21_P_b_dc,A21_u_b_c,A21_u_b_dc,A21_SOC,A21_Q_b,A21_Q_b1,A21_Q_b2,A21_Q_b3,A21_P_b1,A21_P_b2,A21_P_b3,...
					 A21_P_pcc,A21_P_pcc_peak,A21_Q_pcc,A21_Q_pcc_ab,A21_Aux_v_n,A21_v_n,A21_P_f,A21_P_f1,A21_P_f2,A21_P_f3,A21_Q_f,A21_Q_f1,A21_Q_f2,A21_Q_f3,A21_P_n,A21_Q_n]);
		b21=zeros(NT,1);

		clear A21_P1;clear A21_P2;clear A21_P3;clear A21_P;clear A21_U;clear A21_SC;clear A21_Q_g;clear A21_Q_g1;clear A21_Q_g2;clear A21_Q_g3;clear A21_P_b_c;clear A21_P_b_dc;clear A21_u_b_c;clear A21_u_b_dc;clear A21_SOC;
		clear A21_Q_b;clear A21_Q_b1;clear A21_Q_b2;clear  A21_Q_b3;clear A21_P_b1;clear A21_P_b2;clear A21_P_b3;clear A21_P_pcc;clear A21_P_pcc_peak;clear A21_Q_pcc;clear A21_Q_pcc_ab;
		clear A21_Aux_v_n;clear A21_v_n;clear A21_P_f;clear A21_P_f1;clear A21_P_f2;clear A21_P_f3;clear A21_Q_f;clear A21_Q_f1;clear A21_Q_f2;clear A21_Q_f3;clear A21_P_n;clear A21_Q_n;

		%--- 22)Q_pcc_ab>=-Q_pcc
		A22_P1=sparse(zeros(NT,NT*NG));
		A22_P2=sparse(zeros(NT,NT*NG));
		A22_P3=sparse(zeros(NT,NT*NG));
		A22_P=sparse(zeros(NT,NT*NG));
		A22_U=sparse(zeros(NT,NT*NG));
		A22_SC=sparse(zeros(NT,NT*NG));
		A22_Q_g=sparse(zeros(NT,NT*NG));
		A22_Q_g1=sparse(zeros(NT,NT*NG));
		A22_Q_g2=sparse(zeros(NT,NT*NG));
		A22_Q_g3=sparse(zeros(NT,NT*NG)); 
		A22_P_b_c=sparse(zeros(NT,NT*NB));
		A22_P_b_dc=sparse(zeros(NT,NT*NB));
		A22_u_b_c=sparse(zeros(NT,NT*NB));
		A22_u_b_dc=sparse(zeros(NT,NT*NB));
		A22_SOC=sparse(zeros(NT,NT*NB));
		A22_Q_b=sparse(zeros(NT,NT*NB));
		A22_Q_b1=sparse(zeros(NT,NT*NB));
		A22_Q_b2=sparse(zeros(NT,NT*NB));
		A22_Q_b3=sparse(zeros(NT,NT*NB));
		A22_P_b1=sparse(zeros(NT,NT*NB));
		A22_P_b2=sparse(zeros(NT,NT*NB));
		A22_P_b3=sparse(zeros(NT,NT*NB));
		A22_P_pcc=sparse(zeros(NT,NT));
		A22_P_pcc_peak=sparse(zeros(NT,1));
		A22_Q_pcc=sparse(-1*diag(ones(NT,1)));
		A22_Q_pcc_ab=sparse(diag(-1*ones(NT,1)));
		A22_Aux_v_n=sparse(zeros(NT,NT*NN));
		A22_v_n=sparse(zeros(NT,NT*NN));
		A22_P_f=sparse(zeros(NT,NT*NC));
		A22_P_f1=sparse(zeros(NT,NT*NC));
		A22_P_f2=sparse(zeros(NT,NT*NC));
		A22_P_f3=sparse(zeros(NT,NT*NC));
		A22_Q_f=sparse(zeros(NT,NT*NC));
		A22_Q_f1=sparse(zeros(NT,NT*NC));
		A22_Q_f2=sparse(zeros(NT,NT*NC));
		A22_Q_f3=sparse(zeros(NT,NT*NC));
		A22_P_n=sparse(zeros(NT,NT*NN));
		A22_Q_n=sparse(zeros(NT,NT*NN));
		A22=sparse([A22_P1,A22_P2,A22_P3,A22_P,A22_U,A22_SC,A22_Q_g,A22_Q_g1,A22_Q_g2,A22_Q_g3,A22_P_b_c,A22_P_b_dc,A22_u_b_c,A22_u_b_dc,A22_SOC,A22_Q_b,A22_Q_b1,A22_Q_b2,A22_Q_b3,A22_P_b1,A22_P_b2,A22_P_b3,...
					 A22_P_pcc,A22_P_pcc_peak,A22_Q_pcc,A22_Q_pcc_ab,A22_Aux_v_n,A22_v_n,A22_P_f,A22_P_f1,A22_P_f2,A22_P_f3,A22_Q_f,A22_Q_f1,A22_Q_f2,A22_Q_f3,A22_P_n,A22_Q_n]);
		b22=zeros(NT,1);

		clear A22_P1;clear A22_P2;clear A22_P3;clear A22_P;clear A22_U;clear A22_SC;clear A22_Q_g;clear A22_Q_g1;clear A22_Q_g2;clear A22_Q_g3;clear A22_P_b_c;clear A22_P_b_dc;clear A22_u_b_c;clear A22_u_b_dc;clear A22_SOC;
		clear A22_Q_b;clear A22_Q_b1;clear A22_Q_b2;clear  A22_Q_b3;clear A22_P_b1;clear A22_P_b2;clear A22_P_b3;clear A22_P_pcc;clear A22_P_pcc_peak;clear A22_Q_pcc;clear A22_Q_pcc_ab;
		clear A22_Aux_v_n;clear A22_v_n;clear A22_P_f;clear A22_P_f1;clear A22_P_f2;clear A22_P_f3;clear A22_Q_f;clear A22_Q_f1;clear A22_Q_f2;clear A22_Q_f3;clear A22_P_n;clear A22_Q_n;

		%--- 23)Aux_v_n>=v_n-V_max_thr^2
		A23_P1=sparse(zeros(NT*NN,NT*NG));
		A23_P2=sparse(zeros(NT*NN,NT*NG));
		A23_P3=sparse(zeros(NT*NN,NT*NG));
		A23_P=sparse(zeros(NT*NN,NT*NG));
		A23_U=sparse(zeros(NT*NN,NT*NG));
		A23_SC=sparse(zeros(NT*NN,NT*NG));
		A23_Q_g=sparse(zeros(NT*NN,NT*NG));
		A23_Q_g1=sparse(zeros(NT*NN,NT*NG));
		A23_Q_g2=sparse(zeros(NT*NN,NT*NG));
		A23_Q_g3=sparse(zeros(NT*NN,NT*NG)); 
		A23_P_b_c=sparse(zeros(NT*NN,NT*NB));
		A23_P_b_dc=sparse(zeros(NT*NN,NT*NB));
		A23_u_b_c=sparse(zeros(NT*NN,NT*NB));
		A23_u_b_dc=sparse(zeros(NT*NN,NT*NB));
		A23_SOC=sparse(zeros(NT*NN,NT*NB));
		A23_Q_b=sparse(zeros(NT*NN,NT*NB));
		A23_Q_b1=sparse(zeros(NT*NN,NT*NB));
		A23_Q_b2=sparse(zeros(NT*NN,NT*NB));
		A23_Q_b3=sparse(zeros(NT*NN,NT*NB));
		A23_P_b1=sparse(zeros(NT*NN,NT*NB));
		A23_P_b2=sparse(zeros(NT*NN,NT*NB));
		A23_P_b3=sparse(zeros(NT*NN,NT*NB));
		A23_P_pcc=sparse(zeros(NT*NN,NT));
		A23_P_pcc_peak=sparse(zeros(NT*NN,1));
		A23_Q_pcc=sparse(zeros(NT*NN,NT));
		A23_Q_pcc_ab=sparse(zeros(NT*NN,NT));
		A23_Aux_v_n=sparse(diag(-1*ones(NT*NN,1)));
		A23_v_n=sparse(diag(ones(NT*NN,1)));
		A23_P_f=sparse(zeros(NT*NN,NT*NC));
		A23_P_f1=sparse(zeros(NT*NN,NT*NC));
		A23_P_f2=sparse(zeros(NT*NN,NT*NC));
		A23_P_f3=sparse(zeros(NT*NN,NT*NC));
		A23_Q_f=sparse(zeros(NT*NN,NT*NC));
		A23_Q_f1=sparse(zeros(NT*NN,NT*NC));
		A23_Q_f2=sparse(zeros(NT*NN,NT*NC));
		A23_Q_f3=sparse(zeros(NT*NN,NT*NC));
		A23_P_n=sparse(zeros(NT*NN,NT*NN));
		A23_Q_n=sparse(zeros(NT*NN,NT*NN));
		A23=sparse([A23_P1,A23_P2,A23_P3,A23_P,A23_U,A23_SC,A23_Q_g,A23_Q_g1,A23_Q_g2,A23_Q_g3,A23_P_b_c,A23_P_b_dc,A23_u_b_c,A23_u_b_dc,A23_SOC,A23_Q_b,A23_Q_b1,A23_Q_b2,A23_Q_b3,A23_P_b1,A23_P_b2,A23_P_b3,...
					 A23_P_pcc,A23_P_pcc_peak,A23_Q_pcc,A23_Q_pcc_ab,A23_Aux_v_n,A23_v_n,A23_P_f,A23_P_f1,A23_P_f2,A23_P_f3,A23_Q_f,A23_Q_f1,A23_Q_f2,A23_Q_f3,A23_P_n,A23_Q_n]);
		b23=ones(NT*NN,1)*1.01^2;%%%%%%recommended voltage threshold

		clear A23_P1;clear A23_P2;clear A23_P3;clear A23_P;clear A23_U;clear A23_SC;clear A23_Q_g;clear A23_Q_g1;clear A23_Q_g2;clear A23_Q_g3;clear A23_P_b_c;clear A23_P_b_dc;clear A23_u_b_c;clear A23_u_b_dc;clear A23_SOC;
		clear A23_Q_b;clear A23_Q_b1;clear A23_Q_b2;clear  A23_Q_b3;clear A23_P_b1;clear A23_P_b2;clear A23_P_b3;clear A23_P_pcc;clear A23_P_pcc_peak;clear A23_Q_pcc;clear A23_Q_pcc_ab;
		clear A23_Aux_v_n;clear A23_v_n;clear A23_P_f;clear A23_P_f1;clear A23_P_f2;clear A23_P_f3;clear A23_Q_f;clear A23_Q_f1;clear A23_Q_f2;clear A23_Q_f3;clear A23_P_n;clear A23_Q_n;

		%--- 24)Aux_v_n>=V_min_thr^2-v-n
		A24_P1=sparse(zeros(NT*NN,NT*NG));
		A24_P2=sparse(zeros(NT*NN,NT*NG));
		A24_P3=sparse(zeros(NT*NN,NT*NG));
		A24_P=sparse(zeros(NT*NN,NT*NG));
		A24_U=sparse(zeros(NT*NN,NT*NG));
		A24_SC=sparse(zeros(NT*NN,NT*NG));
		A24_Q_g=sparse(zeros(NT*NN,NT*NG));
		A24_Q_g1=sparse(zeros(NT*NN,NT*NG));
		A24_Q_g2=sparse(zeros(NT*NN,NT*NG));
		A24_Q_g3=sparse(zeros(NT*NN,NT*NG)); 
		A24_P_b_c=sparse(zeros(NT*NN,NT*NB));
		A24_P_b_dc=sparse(zeros(NT*NN,NT*NB));
		A24_u_b_c=sparse(zeros(NT*NN,NT*NB));
		A24_u_b_dc=sparse(zeros(NT*NN,NT*NB));
		A24_SOC=sparse(zeros(NT*NN,NT*NB));
		A24_Q_b=sparse(zeros(NT*NN,NT*NB));
		A24_Q_b1=sparse(zeros(NT*NN,NT*NB));
		A24_Q_b2=sparse(zeros(NT*NN,NT*NB));
		A24_Q_b3=sparse(zeros(NT*NN,NT*NB));
		A24_P_b1=sparse(zeros(NT*NN,NT*NB));
		A24_P_b2=sparse(zeros(NT*NN,NT*NB));
		A24_P_b3=sparse(zeros(NT*NN,NT*NB));
		A24_P_pcc=sparse(zeros(NT*NN,NT));
		A24_P_pcc_peak=sparse(zeros(NT*NN,1));
		A24_Q_pcc=sparse(zeros(NT*NN,NT));
		A24_Q_pcc_ab=sparse(zeros(NT*NN,NT));
		A24_Aux_v_n=sparse(diag(-1*ones(NT*NN,1)));
		A24_v_n=sparse(diag(-1*ones(NT*NN,1)));
		A24_P_f=sparse(zeros(NT*NN,NT*NC));
		A24_P_f1=sparse(zeros(NT*NN,NT*NC));
		A24_P_f2=sparse(zeros(NT*NN,NT*NC));
		A24_P_f3=sparse(zeros(NT*NN,NT*NC));
		A24_Q_f=sparse(zeros(NT*NN,NT*NC));
		A24_Q_f1=sparse(zeros(NT*NN,NT*NC));
		A24_Q_f2=sparse(zeros(NT*NN,NT*NC));
		A24_Q_f3=sparse(zeros(NT*NN,NT*NC));
		A24_P_n=sparse(zeros(NT*NN,NT*NN));
		A24_Q_n=sparse(zeros(NT*NN,NT*NN));
		A24=sparse([A24_P1,A24_P2,A24_P3,A24_P,A24_U,A24_SC,A24_Q_g,A24_Q_g1,A24_Q_g2,A24_Q_g3,A24_P_b_c,A24_P_b_dc,A24_u_b_c,A24_u_b_dc,A24_SOC,A24_Q_b,A24_Q_b1,A24_Q_b2,A24_Q_b3,A24_P_b1,A24_P_b2,A24_P_b3,...
					 A24_P_pcc,A24_P_pcc_peak,A24_Q_pcc,A24_Q_pcc_ab,A24_Aux_v_n,A24_v_n,A24_P_f,A24_P_f1,A24_P_f2,A24_P_f3,A24_Q_f,A24_Q_f1,A24_Q_f2,A24_Q_f3,A24_P_n,A24_Q_n]);
		b24=-1*ones(NT*NN,1)*0.99^2;%%%%%%recommended voltage threshold

		clear A24_P1;clear A24_P2;clear A24_P3;clear A24_P;clear A24_U;clear A24_SC;clear A24_Q_g;clear A24_Q_g1;clear A24_Q_g2;clear A24_Q_g3;clear A24_P_b_c;clear A24_P_b_dc;clear A24_u_b_c;clear A24_u_b_dc;clear A24_SOC;
		clear A24_Q_b;clear A24_Q_b1;clear A24_Q_b2;clear  A24_Q_b3;clear A24_P_b1;clear A24_P_b2;clear A24_P_b3;clear A24_P_pcc;clear A24_P_pcc_peak;clear A24_Q_pcc;clear A24_Q_pcc_ab;
		clear A24_Aux_v_n;clear A24_v_n;clear A24_P_f;clear A24_P_f1;clear A24_P_f2;clear A24_P_f3;clear A24_Q_f;clear A24_Q_f1;clear A24_Q_f2;clear A24_Q_f3;clear A24_P_n;clear A24_Q_n;

		%--- 25)P_f1+P_f2+P_f3>=P_f;
		A25_P1=sparse(zeros(NT*NC,NT*NG));
		A25_P2=sparse(zeros(NT*NC,NT*NG));
		A25_P3=sparse(zeros(NT*NC,NT*NG));
		A25_P=sparse(zeros(NT*NC,NT*NG));
		A25_U=sparse(zeros(NT*NC,NT*NG));
		A25_SC=sparse(zeros(NT*NC,NT*NG));
		A25_Q_g=sparse(zeros(NT*NC,NT*NG));
		A25_Q_g1=sparse(zeros(NT*NC,NT*NG));
		A25_Q_g2=sparse(zeros(NT*NC,NT*NG));
		A25_Q_g3=sparse(zeros(NT*NC,NT*NG)); 
		A25_P_b_c=sparse(zeros(NT*NC,NT*NB));
		A25_P_b_dc=sparse(zeros(NT*NC,NT*NB));
		A25_u_b_c=sparse(zeros(NT*NC,NT*NB));
		A25_u_b_dc=sparse(zeros(NT*NC,NT*NB));
		A25_SOC=sparse(zeros(NT*NC,NT*NB));
		A25_Q_b=sparse(zeros(NT*NC,NT*NB));
		A25_Q_b1=sparse(zeros(NT*NC,NT*NB));
		A25_Q_b2=sparse(zeros(NT*NC,NT*NB));
		A25_Q_b3=sparse(zeros(NT*NC,NT*NB));
		A25_P_b1=sparse(zeros(NT*NC,NT*NB));
		A25_P_b2=sparse(zeros(NT*NC,NT*NB));
		A25_P_b3=sparse(zeros(NT*NC,NT*NB));
		A25_P_pcc=sparse(zeros(NT*NC,NT));
		A25_P_pcc_peak=sparse(zeros(NT*NC,1));
		A25_Q_pcc=sparse(zeros(NT*NC,NT));
		A25_Q_pcc_ab=sparse(zeros(NT*NC,NT));
		A25_Aux_v_n=sparse(zeros(NT*NC,NT*NN));
		A25_v_n=sparse(zeros(NT*NC,NT*NN));
		A25_P_f=sparse(diag(ones(NT*NC,1)));
		A25_P_f1=sparse(-1*diag(ones(NT*NC,1)));
		A25_P_f2=sparse(-1*diag(ones(NT*NC,1)));
		A25_P_f3=sparse(-1*diag(ones(NT*NC,1)));
		A25_Q_f=sparse(zeros(NT*NC,NT*NC));
		A25_Q_f1=sparse(zeros(NT*NC,NT*NC));
		A25_Q_f2=sparse(zeros(NT*NC,NT*NC));
		A25_Q_f3=sparse(zeros(NT*NC,NT*NC));
		A25_P_n=sparse(zeros(NT*NC,NT*NN));
		A25_Q_n=sparse(zeros(NT*NC,NT*NN));
		A25=sparse([A25_P1,A25_P2,A25_P3,A25_P,A25_U,A25_SC,A25_Q_g,A25_Q_g1,A25_Q_g2,A25_Q_g3,A25_P_b_c,A25_P_b_dc,A25_u_b_c,A25_u_b_dc,A25_SOC,A25_Q_b,A25_Q_b1,A25_Q_b2,A25_Q_b3,A25_P_b1,A25_P_b2,A25_P_b3,...
					 A25_P_pcc,A25_P_pcc_peak,A25_Q_pcc,A25_Q_pcc_ab,A25_Aux_v_n,A25_v_n,A25_P_f,A25_P_f1,A25_P_f2,A25_P_f3,A25_Q_f,A25_Q_f1,A25_Q_f2,A25_Q_f3,A25_P_n,A25_Q_n]);
		b25=zeros(NT*NC,1);
		clear A25_P1;clear A25_P2;clear A25_P3;clear A25_P;clear A25_U;clear A25_SC;clear A25_Q_g;clear A25_Q_g1;clear A25_Q_g2;clear A25_Q_g3;clear A25_P_b_c;clear A25_P_b_dc;clear A25_u_b_c;clear A25_u_b_dc;clear A25_SOC;
		clear A25_Q_b;clear A25_Q_b1;clear A25_Q_b2;clear  A25_Q_b3;clear A25_P_b1;clear A25_P_b2;clear A25_P_b3;clear A25_P_pcc;clear A25_P_pcc_peak;clear A25_Q_pcc;clear A25_Q_pcc_ab;
		clear A25_Aux_v_n;clear A25_v_n;clear A25_P_f;clear A25_P_f1;clear A25_P_f2;clear A25_P_f3;clear A25_Q_f;clear A25_Q_f1;clear A25_Q_f2;clear A25_Q_f3;clear A25_P_n;clear A25_Q_n;

		%--- 26)P_f1+P_f2+P_f3>=-P_f;
		A26_P1=sparse(zeros(NT*NC,NT*NG));
		A26_P2=sparse(zeros(NT*NC,NT*NG));
		A26_P3=sparse(zeros(NT*NC,NT*NG));
		A26_P=sparse(zeros(NT*NC,NT*NG));
		A26_U=sparse(zeros(NT*NC,NT*NG));
		A26_SC=sparse(zeros(NT*NC,NT*NG));
		A26_Q_g=sparse(zeros(NT*NC,NT*NG));
		A26_Q_g1=sparse(zeros(NT*NC,NT*NG));
		A26_Q_g2=sparse(zeros(NT*NC,NT*NG));
		A26_Q_g3=sparse(zeros(NT*NC,NT*NG)); 
		A26_P_b_c=sparse(zeros(NT*NC,NT*NB));
		A26_P_b_dc=sparse(zeros(NT*NC,NT*NB));
		A26_u_b_c=sparse(zeros(NT*NC,NT*NB));
		A26_u_b_dc=sparse(zeros(NT*NC,NT*NB));
		A26_SOC=sparse(zeros(NT*NC,NT*NB));
		A26_Q_b=sparse(zeros(NT*NC,NT*NB));
		A26_Q_b1=sparse(zeros(NT*NC,NT*NB));
		A26_Q_b2=sparse(zeros(NT*NC,NT*NB));
		A26_Q_b3=sparse(zeros(NT*NC,NT*NB));
		A26_P_b1=sparse(zeros(NT*NC,NT*NB));
		A26_P_b2=sparse(zeros(NT*NC,NT*NB));
		A26_P_b3=sparse(zeros(NT*NC,NT*NB));
		A26_P_pcc=sparse(zeros(NT*NC,NT));
		A26_P_pcc_peak=sparse(zeros(NT*NC,1));
		A26_Q_pcc=sparse(zeros(NT*NC,NT));
		A26_Q_pcc_ab=sparse(zeros(NT*NC,NT));
		A26_Aux_v_n=sparse(zeros(NT*NC,NT*NN));
		A26_v_n=sparse(zeros(NT*NC,NT*NN));
		A26_P_f=sparse(-1*diag(ones(NT*NC,1)));
		A26_P_f1=sparse(-1*diag(ones(NT*NC,1)));
		A26_P_f2=sparse(-1*diag(ones(NT*NC,1)));
		A26_P_f3=sparse(-1*diag(ones(NT*NC,1)));
		A26_Q_f=sparse(zeros(NT*NC,NT*NC));
		A26_Q_f1=sparse(zeros(NT*NC,NT*NC));
		A26_Q_f2=sparse(zeros(NT*NC,NT*NC));
		A26_Q_f3=sparse(zeros(NT*NC,NT*NC));
		A26_P_n=sparse(zeros(NT*NC,NT*NN));
		A26_Q_n=sparse(zeros(NT*NC,NT*NN));
		A26=sparse([A26_P1,A26_P2,A26_P3,A26_P,A26_U,A26_SC,A26_Q_g,A26_Q_g1,A26_Q_g2,A26_Q_g3,A26_P_b_c,A26_P_b_dc,A26_u_b_c,A26_u_b_dc,A26_SOC,A26_Q_b,A26_Q_b1,A26_Q_b2,A26_Q_b3,A26_P_b1,A26_P_b2,A26_P_b3,...
					 A26_P_pcc,A26_P_pcc_peak,A26_Q_pcc,A26_Q_pcc_ab,A26_Aux_v_n,A26_v_n,A26_P_f,A26_P_f1,A26_P_f2,A26_P_f3,A26_Q_f,A26_Q_f1,A26_Q_f2,A26_Q_f3,A26_P_n,A26_Q_n]);
		b26=zeros(NT*NC,1);

		clear A26_P1;clear A26_P2;clear A26_P3;clear A26_P;clear A26_U;clear A26_SC;clear A26_Q_g;clear A26_Q_g1;clear A26_Q_g2;clear A26_Q_g3;clear A26_P_b_c;clear A26_P_b_dc;clear A26_u_b_c;clear A26_u_b_dc;clear A26_SOC;
		clear A26_Q_b;clear A26_Q_b1;clear A26_Q_b2;clear  A26_Q_b3;clear A26_P_b1;clear A26_P_b2;clear A26_P_b3;clear A26_P_pcc;clear A26_P_pcc_peak;clear A26_Q_pcc;clear A26_Q_pcc_ab;
		clear A26_Aux_v_n;clear A26_v_n;clear A26_P_f;clear A26_P_f1;clear A26_P_f2;clear A26_P_f3;clear A26_Q_f;clear A26_Q_f1;clear A26_Q_f2;clear A26_Q_f3;clear A26_P_n;clear A26_Q_n;

		%--- 27)Q_f1+Q_f2+Q_f3>=Q_f;
		A27_P1=sparse(zeros(NT*NC,NT*NG));
		A27_P2=sparse(zeros(NT*NC,NT*NG));
		A27_P3=sparse(zeros(NT*NC,NT*NG));
		A27_P=sparse(zeros(NT*NC,NT*NG));
		A27_U=sparse(zeros(NT*NC,NT*NG));
		A27_SC=sparse(zeros(NT*NC,NT*NG));
		A27_Q_g=sparse(zeros(NT*NC,NT*NG));
		A27_Q_g1=sparse(zeros(NT*NC,NT*NG));
		A27_Q_g2=sparse(zeros(NT*NC,NT*NG));
		A27_Q_g3=sparse(zeros(NT*NC,NT*NG)); 
		A27_P_b_c=sparse(zeros(NT*NC,NT*NB));
		A27_P_b_dc=sparse(zeros(NT*NC,NT*NB));
		A27_u_b_c=sparse(zeros(NT*NC,NT*NB));
		A27_u_b_dc=sparse(zeros(NT*NC,NT*NB));
		A27_SOC=sparse(zeros(NT*NC,NT*NB));
		A27_Q_b=sparse(zeros(NT*NC,NT*NB));
		A27_Q_b1=sparse(zeros(NT*NC,NT*NB));
		A27_Q_b2=sparse(zeros(NT*NC,NT*NB));
		A27_Q_b3=sparse(zeros(NT*NC,NT*NB));
		A27_P_b1=sparse(zeros(NT*NC,NT*NB));
		A27_P_b2=sparse(zeros(NT*NC,NT*NB));
		A27_P_b3=sparse(zeros(NT*NC,NT*NB));
		A27_P_pcc=sparse(zeros(NT*NC,NT));
		A27_P_pcc_peak=sparse(zeros(NT*NC,1));
		A27_Q_pcc=sparse(zeros(NT*NC,NT));
		A27_Q_pcc_ab=sparse(zeros(NT*NC,NT));
		A27_Aux_v_n=sparse(zeros(NT*NC,NT*NN));
		A27_v_n=sparse(zeros(NT*NC,NT*NN));
		A27_P_f=sparse(zeros(NT*NC,NT*NC));
		A27_P_f1=sparse(zeros(NT*NC,NT*NC));
		A27_P_f2=sparse(zeros(NT*NC,NT*NC));
		A27_P_f3=sparse(zeros(NT*NC,NT*NC));
		A27_Q_f=sparse(diag(ones(NT*NC,1)));
		A27_Q_f1=sparse(-1*diag(ones(NT*NC,1)));
		A27_Q_f2=sparse(-1*diag(ones(NT*NC,1)));
		A27_Q_f3=sparse(-1*diag(ones(NT*NC,1)));
		A27_P_n=sparse(zeros(NT*NC,NT*NN));
		A27_Q_n=sparse(zeros(NT*NC,NT*NN));
		A27=sparse([A27_P1,A27_P2,A27_P3,A27_P,A27_U,A27_SC,A27_Q_g,A27_Q_g1,A27_Q_g2,A27_Q_g3,A27_P_b_c,A27_P_b_dc,A27_u_b_c,A27_u_b_dc,A27_SOC,A27_Q_b,A27_Q_b1,A27_Q_b2,A27_Q_b3,A27_P_b1,A27_P_b2,A27_P_b3,...
					 A27_P_pcc,A27_P_pcc_peak,A27_Q_pcc,A27_Q_pcc_ab,A27_Aux_v_n,A27_v_n,A27_P_f,A27_P_f1,A27_P_f2,A27_P_f3,A27_Q_f,A27_Q_f1,A27_Q_f2,A27_Q_f3,A27_P_n,A27_Q_n]);
		b27=zeros(NT*NC,1);

		clear A27_P1;clear A27_P2;clear A27_P3;clear A27_P;clear A27_U;clear A27_SC;clear A27_Q_g;clear A27_Q_g1;clear A27_Q_g2;clear A27_Q_g3;clear A27_P_b_c;clear A27_P_b_dc;clear A27_u_b_c;clear A27_u_b_dc;clear A27_SOC;
		clear A27_Q_b;clear A27_Q_b1;clear A27_Q_b2;clear  A27_Q_b3;clear A27_P_b1;clear A27_P_b2;clear A27_P_b3;clear A27_P_pcc;clear A27_P_pcc_peak;clear A27_Q_pcc;clear A27_Q_pcc_ab;
		clear A27_Aux_v_n;clear A27_v_n;clear A27_P_f;clear A27_P_f1;clear A27_P_f2;clear A27_P_f3;clear A27_Q_f;clear A27_Q_f1;clear A27_Q_f2;clear A27_Q_f3;clear A27_P_n;clear A27_Q_n;

		%--- 28)Q_f1+Q_f2+Q_f3>=-Q_f;
		A28_P1=sparse(zeros(NT*NC,NT*NG));
		A28_P2=sparse(zeros(NT*NC,NT*NG));
		A28_P3=sparse(zeros(NT*NC,NT*NG));
		A28_P=sparse(zeros(NT*NC,NT*NG));
		A28_U=sparse(zeros(NT*NC,NT*NG));
		A28_SC=sparse(zeros(NT*NC,NT*NG));
		A28_Q_g=sparse(zeros(NT*NC,NT*NG));
		A28_Q_g1=sparse(zeros(NT*NC,NT*NG));
		A28_Q_g2=sparse(zeros(NT*NC,NT*NG));
		A28_Q_g3=sparse(zeros(NT*NC,NT*NG)); 
		A28_P_b_c=sparse(zeros(NT*NC,NT*NB));
		A28_P_b_dc=sparse(zeros(NT*NC,NT*NB));
		A28_u_b_c=sparse(zeros(NT*NC,NT*NB));
		A28_u_b_dc=sparse(zeros(NT*NC,NT*NB));
		A28_SOC=sparse(zeros(NT*NC,NT*NB));
		A28_Q_b=sparse(zeros(NT*NC,NT*NB));
		A28_Q_b1=sparse(zeros(NT*NC,NT*NB));
		A28_Q_b2=sparse(zeros(NT*NC,NT*NB));
		A28_Q_b3=sparse(zeros(NT*NC,NT*NB));
		A28_P_b1=sparse(zeros(NT*NC,NT*NB));
		A28_P_b2=sparse(zeros(NT*NC,NT*NB));
		A28_P_b3=sparse(zeros(NT*NC,NT*NB));
		A28_P_pcc=sparse(zeros(NT*NC,NT));
		A28_P_pcc_peak=sparse(zeros(NT*NC,1));
		A28_Q_pcc=sparse(zeros(NT*NC,NT));
		A28_Q_pcc_ab=sparse(zeros(NT*NC,NT));
		A28_Aux_v_n=sparse(zeros(NT*NC,NT*NN));
		A28_v_n=sparse(zeros(NT*NC,NT*NN));
		A28_P_f=sparse(zeros(NT*NC,NT*NC));
		A28_P_f1=sparse(zeros(NT*NC,NT*NC));
		A28_P_f2=sparse(zeros(NT*NC,NT*NC));
		A28_P_f3=sparse(zeros(NT*NC,NT*NC));
		A28_Q_f=sparse(-1*diag(ones(NT*NC,1)));
		A28_Q_f1=sparse(-1*diag(ones(NT*NC,1)));
		A28_Q_f2=sparse(-1*diag(ones(NT*NC,1)));
		A28_Q_f3=sparse(-1*diag(ones(NT*NC,1)));
		A28_P_n=sparse(zeros(NT*NC,NT*NN));
		A28_Q_n=sparse(zeros(NT*NC,NT*NN));
		A28=sparse([A28_P1,A28_P2,A28_P3,A28_P,A28_U,A28_SC,A28_Q_g,A28_Q_g1,A28_Q_g2,A28_Q_g3,A28_P_b_c,A28_P_b_dc,A28_u_b_c,A28_u_b_dc,A28_SOC,A28_Q_b,A28_Q_b1,A28_Q_b2,A28_Q_b3,A28_P_b1,A28_P_b2,A28_P_b3,...
					 A28_P_pcc,A28_P_pcc_peak,A28_Q_pcc,A28_Q_pcc_ab,A28_Aux_v_n,A28_v_n,A28_P_f,A28_P_f1,A28_P_f2,A28_P_f3,A28_Q_f,A28_Q_f1,A28_Q_f2,A28_Q_f3,A28_P_n,A28_Q_n]);
		b28=zeros(NT*NC,1);

		clear A28_P1;clear A28_P2;clear A28_P3;clear A28_P;clear A28_U;clear A28_SC;clear A28_Q_g;clear A28_Q_g1;clear A28_Q_g2;clear A28_Q_g3;clear A28_P_b_c;clear A28_P_b_dc;clear A28_u_b_c;clear A28_u_b_dc;clear A28_SOC;
		clear A28_Q_b;clear A28_Q_b1;clear A28_Q_b2;clear  A28_Q_b3;clear A28_P_b1;clear A28_P_b2;clear A28_P_b3;clear A28_P_pcc;clear A28_P_pcc_peak;clear A28_Q_pcc;clear A28_Q_pcc_ab;
		clear A28_Aux_v_n;clear A28_v_n;clear A28_P_f;clear A28_P_f1;clear A28_P_f2;clear A28_P_f3;clear A28_Q_f;clear A28_Q_f1;clear A28_Q_f2;clear A28_Q_f3;clear A28_P_n;clear A28_Q_n;
	catch Me
		disp('EMS Grid Connected_Defining Inequalaies2')
		disp(Me.message) 
		ignore_results = 1;  		
	end;
end;

if ignore_results == 0
	try 
		%% --- Finally, assemble A Aeq b beq
		Aeq=sparse([Aeq1;Aeq2;Aeq3;Aeq4;Aeq5;Aeq6;Aeq7;Aeq8]);
		clear Aeq1; clear Aeq2; clear Aeq3; clear Aeq4; clear Aeq5; clear Aeq6; clear Aeq7; clear Aeq8;
		beq=[beq1;beq2;beq3;beq4;beq5;beq6;beq7;beq8];
		clear beq1;clear beq2;clear beq3;clear beq4;clear beq5;clear beq6; clear beq7; clear beq8;

		Aineq=sparse([A1;A2;A3;A4;A5;A6;A7;A8;A9;A10;A11;A12;A13;A14;A15;A16;A17;A18;A19;A20;A21;A22;A23;A24;A25;A26;A27;A28]);
		clear A1;clear A2; clear A3; clear A4; clear A5; clear A6; clear A7; clear A8;
		clear A9; clear A10; clear A11; clear A12; clear A13; clear A14; clear A15;
		clear A16; clear A17; clear A18; clear A19; clear A20; clear A21; clear A22; clear A23; clear A24; 
		clear A25;clear A26;clear A27;clear A28;
		bineq=[b1;b2;b3;b4;b5;b6;b7;b8;b9;b10;b11;b12;b13;b14;b15;b16;b17;b18;b19;b20;b21;b22;b23;b24;b25;b26;b27;b28];
		clear b1;clear b2;clear b3;clear b4;clear b5;clear b6;clear b7;
		clear b8;clear b9;clear b10;clear b11;clear b12;clear b13;clear b14;
		clear b15;clear b16;clear b17;clear b18;clear b19;clear b20;clear b21; clear b22;clear b23;clear b24;
		clear b25;clear b26;clear b27;clear b28;
		intcon=[NT*NG*4+1:NT*NG*6,NT*NG*10+NT*NB*2+1:NT*NG*10+NT*NB*4];
		
	catch Me
			disp('EMS Grid Connected_assemble A Aeq b beq')
			disp(Me.message) 
			ignore_results = 1;  
	end;		
end;

if ignore_results == 0
	try
		%%Data Preperation Finished
		update_status(handles.program_status,home,'Optimization Model Formulation Successful!')
		update_status(handles.program_status,home,'Start Optimization Engine..')
		clear data;
	catch Me
		disp('EMS Grid Connected_Display2')
		disp(Me.message) 
		ignore_results = 1;       
	end;
end;

if ignore_results == 0
	try
		%% Run Optimization Engine
		options = optimoptions('intlinprog','MaxTime',120,'TolGapRel',0.001);
		
		[x,fval,exitflag] = intlinprog(f,intcon,Aineq,bineq,Aeq,beq,lb,ub,options);
		clear Aineq, clear bineq;clear Aeq;clear beq;clear lb; clear ub; clear intcon
		

		if isempty(x)
			create_error_notification(home,'Optimization did not solve','EMS Grid Connected_Optimization Engine.txt');   
		end;
		
		if exitflag>0
			update_status(handles.program_status,home,'Optimization Successful')
		else
		   update_status(handles.program_status,home,'Optimization Routine Terminated Prematurely!')
		   ignore_results = 1;  

		end
	catch Me
			disp('EMS Grid Connected_Optimization Engine')
			disp(Me.message) 
			ignore_results = 1;   
	end;
end;
	
if ignore_results == 0
	try 
		%% Extracting Data
		P1=x(1:NT*NG);
		x(1:NT*NG)=[];
		P2=x(1:NT*NG);
		x(1:NT*NG)=[];
		P3=x(1:NT*NG);
		x(1:NT*NG)=[];
		P_g=x(1:NT*NG);
		x(1:NT*NG)=[];
		u_g=x(1:NT*NG);
		x(1:NT*NG)=[];
		SC_g=x(1:NT*NG);
		x(1:NT*NG)=[];
		Q_g=x(1:NT*NG);
		x(1:NT*NG)=[];
		Q_g1=x(1:NT*NG);
		x(1:NT*NG)=[];
		Q_g2=x(1:NT*NG);
		x(1:NT*NG)=[];
		Q_g3=x(1:NT*NG);
		x(1:NT*NG)=[];
		% Results of batteries
		P_b_c=x(1:NT*NB);
		x(1:NT*NB)=[];
		P_b_dc=x(1:NT*NB);
		x(1:NT*NB)=[];
		u_b_c=x(1:NT*NB);
		x(1:NT*NB)=[];
		u_b_dc=x(1:NT*NB);
		x(1:NT*NB)=[];
		SOC_b=x(1:NT*NB);
		x(1:NT*NB)=[];
		Q_b=x(1:NT*NB);
		x(1:NT*NB)=[];
		Q_b1=x(1:NT*NB);
		x(1:NT*NB)=[];
		Q_b2=x(1:NT*NB);
		x(1:NT*NB)=[];
		Q_b3=x(1:NT*NB);
		x(1:NT*NB)=[];
		P_b1=x(1:NT*NB);
		x(1:NT*NB)=[];
		P_b2=x(1:NT*NB);
		x(1:NT*NB)=[];
		P_b3=x(1:NT*NB);
		x(1:NT*NB)=[];
		% Results of PCC
		P_pcc=x(1:NT);
		x(1:NT)=[];
		P_pcc_peak=x(1); 
		x(1)=[];
		Q_pcc=x(1:NT);
		x(1:NT)=[];
		Q_pcc_ab=x(1:NT);
		x(1:NT)=[];
		% results of cables and nodes
		Aux_v_n=x(1:NT*NN);
		x(1:NT*NN)=[];
		V_n=sqrt(x(1:NT*NN));
		x(1:NT*NN)=[];
		P_f=x(1:NT*NC);
		x(1:NT*NC)=[];
		P_f1=x(1:NT*NC);
		x(1:NT*NC)=[];
		P_f2=x(1:NT*NC);
		x(1:NT*NC)=[];
		P_f3=x(1:NT*NC);
		x(1:NT*NC)=[];
		Q_f=x(1:NT*NC);
		x(1:NT*NC)=[];
		Q_f1=x(1:NT*NC);
		x(1:NT*NC)=[];
		Q_f2=x(1:NT*NC);
		x(1:NT*NC)=[];
		Q_f3=x(1:NT*NC);
		x(1:NT*NC)=[];
		P_n=x(1:NT*NN);
		x(1:NT*NN)=[];
		Q_n=x(1:NT*NN);
		x(1:NT*NN)=[];
		%% Calculate categoried cost

		Gen_cost=MC_1'*P1+MC_2'*P2+MC_3'*P3+NLC'*u_g+K_sc'*SC_g;
		Buy_Sell_cost=P_pcc'*DA_price*del_t;
		Demand_charge=Dmd_Crg*P_pcc_peak;
		Total_Q=Q_pcc_ab'*ones(NT,1);
		Power_Loss=C_P_f1'*P_f1+C_P_f2'*P_f2+C_P_f3'*P_f3+C_Q_f1'*Q_f1+C_Q_f2'*Q_f2+C_Q_f3'*Q_f3;
		Voltage_deviation=sum(Aux_v_n);
		%% Put into matrix form
		P_g_solution=zeros(NG,NT);
		for i=1:NT
			P_g_solution(:,i)=P_g((i-1)*NG+1:i*NG);
		end
		u_g_solution=zeros(NG,NT);
		for i=1:NT
			u_g_solution(:,i)=u_g((i-1)*NG+1:i*NG);
		end
		Q_g_solution=zeros(NG,NT);
		for i=1:NT
			Q_g_solution(:,i)=Q_g((i-1)*NG+1:i*NG);
		end
		% Results of batteries
		P_b_solution=zeros(NB,NT);
		for i=1:NT
			P_b_solution(:,i)=P_b_dc((i-1)*NB+1:i*NB)-P_b_c((i-1)*NB+1:i*NB);
		end

		u_b_solution=zeros(NB,NT);
		for i=1:NT
			u_b_solution(:,i)=u_b_dc((i-1)*NB+1:i*NB)-u_b_c((i-1)*NB+1:i*NB);
		end

		SOC_b_solution=zeros(NB,NT);
		for i=1:NT
			SOC_b_solution(:,i)=SOC_b((i-1)*NB+1:i*NB);
		end
		Q_b_solution=zeros(NB,NT);
		for i=1:NT
			Q_b_solution(:,i)=Q_b((i-1)*NB+1:i*NB);
		end
		% Results of PCC
		P_pcc_solution=P_pcc';
		Q_pcc_solution=Q_pcc';
		% results of cables and nodes

		V_n_solution=zeros(NN,NT);
		for i=1:NT
			V_n_solution(:,i)=V_n((i-1)*NN+1:i*NN);
		end

		P_f_solution=zeros(NC,NT);
		for i=1:NT
			P_f_solution(:,i)=P_f((i-1)*NC+1:i*NC);
		end

		Q_f_solution=zeros(NC,NT);
		for i=1:NT
			Q_f_solution(:,i)=Q_f((i-1)*NC+1:i*NC);
		end
	catch Me
			disp('EMS Grid Connected_Extracting Data')
			disp(Me.message) 
			ignore_results = 1; 
	end
end;

if ignore_results == 1
		   P_g_solution = 0;
		   u_g_solution = 0;
		   Q_g_solution = 0;
		   P_b_solution = 0;
		   u_b_solution = 0;
		   SOC_b_solution = 0;
		   Q_b_solution = 0;
		   P_pcc_solution = 0;
		   Q_pcc_solution = 0;
		   V_n_solution = 0;
		   P_f_solution = 0;
		   Q_f_solution = 0;
		   disp('error in EMS_GRID_connected')
		    set(handles.program_status,'String','Optimization Failed...')
			pause(5);
end;
		   



