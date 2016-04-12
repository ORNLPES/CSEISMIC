 SOCs = 55;
 home = cd;
 
 cd(fullfile(home,'System Architecture Data','Network Model','Battery'));
 
   	%% ensure file is not in use
	setpointcontinue = 0;
	while setpointcontinue <100
		fid = fopen('Battery Parameter.csv','r')
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
        battery_numbers = batteries(:,1) %battery numbers
        bus_number =batteries(:,2);% number of batteries
        voltages =batteries(:,3);% number of batteries
        Smax_b=batteries(:,4)
		Emax_b=batteries(:,5)
		Ramp_rate=batteries(:,6)
		PFmax_b=batteries(:,7)
		PFmin_b=batteries(:,8)
		SOC_min=batteries(:,9)
		SOC_max=batteries(:,10)

		yita_ch=batteries(:,11);%efficiency of battery charging
		yita_dch=batteries(:,12);%efficiency of battery discharging

		%SOC0=batteries(:,13);% Initial SOC can be directly claimed from measurements

		SOCend=batteries(:,14);% Initial/End SOC
    
    
        %% ensure file is not in use
        setpointcontinue = 0;
        while setpointcontinue <100
            fid = fopen('Battery Parameter.csv','w')
            if fid ==-1
                pause(0.05)
                setpointcontinue = setpointcontinue +1;
            else
                break
            end
        end
   
       title_text = strcat('Battery #,Bus #,Voltage (V),Power Rating (kVA),',...
           'Energy Rating (kWh),Ramp Rate (kW/s),Max Power Factor (leading),',...
           'Max Power factor (lagging),Min SOC(%%),Max SOC(%%),Charging Efficiency,',...
           'Discharging Efficiency,	Start SOC(%%),End SOC(%%)')

       fprintf(fid,title_text)
   
       %%%%%%%%%%%%  1  2  3  4  5  6  7  8  9 10 11 12 13 14
       %% Convert SOC to MWh
       
       for i = 1:NB
           fprintf(fid,'\n%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',...
           battery_numbers(i), battery_numbers(i), voltages(i),...
           Smax_b(i), Emax_b(i), Ramp_rate(i), PFmax_b(i),PFmin_b(i),...
           SOC_min(i), SOC_max(i), yita_ch(i), yita_dch(i), SOCs(i), SOCend(i))
       end;
       fclose(fid);
   
   
   cd(fullfile(home));