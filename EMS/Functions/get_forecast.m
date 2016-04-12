function [solar_forecast] = get_forecast(handles)
%[] = [solar_forecast] = get_forecast(handles)
% pulls solar and load forecast from files.

global system_status;
global home;

%% Load Load Forecast Data
try 
   time_stamp = clock;
   try 
       %% current day
       date_stamp = strcat(num2str(time_stamp(1),'%02.0f'),'_',num2str(time_stamp(2),'%02.0f'),'_',num2str(time_stamp(3),'%02.0f'))
       cd(fullfile('C:/','Load_Forecast_Data','Load Forecast Data',date_stamp))
       load_forecast_hourly = load(strcat('Load_forecast_',date_stamp,'.txt'));
   catch
       %% previous day
       time_stamp = datevec(datenum(clock)-1)
       date_stamp = strcat(num2str(time_stamp(1),'%02.0f'),'_',num2str(time_stamp(2),'%02.0f'),'_',num2str(time_stamp(3),'%02.0f'))
       cd(fullfile('C:/','Load_Forecast_Data','Load Forecast Data',date_stamp))
       load_forecast_hourly = load(strcat('Load_forecast_',date_stamp,'.txt'));
   end; 
       
   time_hourly = 1:48;
catch Me
    create_error_notification(home,Me.message,'get forecast_load load forecast data.txt');  
end

%% Interp and Extract Current Load Forecast Data 
try
   load_forecast_5minute = interp(load_forecast_hourly,12);
   time_5minute = interp(time_hourly,12);
   current_time = clock;
   current_5minute_time = floor(current_time(4)*12+current_time(5)/5)
   if current_5minute_time == 0
		current_5minute_time =1;
	end	
   load_forecast_EMS = load_forecast_5minute(current_5minute_time:current_5minute_time+287)

catch Me
    create_error_notification(home,Me.message,'get forecast_interp and extract load forecast data.txt');  
end

%% Save data in optimization format
try
   cd(fullfile(home,'System Architecture Data','Network Model','Load'));
	%% ensure file is not in use
	setpointcontinue =0;
	while setpointcontinue <100
		fid = fopen('P_load.csv','w')
		if fid ==-1
			pause(0.05)
			setpointcontinue = setpointcontinue +1;
		else
			break
		end
	end
   %%
   fprintf(fid,'Time Interval (5 minutes),');
   
   for i = 1:288;
       fprintf(fid,'%f,',i);
   end;
   
   fprintf(fid, '%s\n','')
   fprintf(fid, '%f,',2)
   
   for i = 1:288;
       fprintf(fid,'%f,',load_forecast_EMS(i)/1000);
   end;
   fclose(fid);
   	%% ensure file is not in use
   	setpointcontinue =0;
	while setpointcontinue <100
		fid = fopen('Q_Load.csv','w')
		if fid ==-1
			pause(0.05)
			setpointcontinue = setpointcontinue +1;
		else
			break
		end
	end
	%%
   fprintf(fid,'Time Interval (5 minutes),');
   
   for i = 1:288;
       fprintf(fid,'%f,',i);
   end;
   
   fprintf(fid, '%s\n','')
   fprintf(fid, '%f,',2)
   
   for i = 1:288;
       fprintf(fid,'%f,',0/1000); %currently forecasting 0 Reactive for the optimization
   end;
   fclose(fid);
             
catch Me
    create_error_notification(home,Me.message,'get forecast_print load forecast data to file.txt');  
end


%% Load PV Forecast Data
try
   time_stamp = clock;
   try 
       %% current day
       date_stamp = strcat(num2str(time_stamp(1),'%02.0f'),'_',num2str(time_stamp(2),'%02.0f'),'_',num2str(time_stamp(3),'%02.0f'))
       cd(fullfile('C:/','Load_Forecast_Data','PV Forecast Data',date_stamp))
       load_PV_forecast_minutes = load(strcat('PV Output_',date_stamp,'.txt'));
   catch
       %% previous day
       time_stamp = datevec(datenum(clock)-1)
       date_stamp = strcat(num2str(time_stamp(1),'%02.0f'),'_',num2str(time_stamp(2),'%02.0f'),'_',num2str(time_stamp(3),'%02.0f'))
       cd(fullfile('C:/','Load_Forecast_Data','PV Forecast Data',date_stamp))
       load_PV_forecast_minutes = load(strcat('PV Output_',date_stamp,'.txt'));
   end; 
       
   PV_minutes = load_PV_forecast_minutes(:,1); %two rows/only want first one.
   time_minutes = 1:1440;
catch Me
    create_error_notification(home,Me.message,'get forecast_load PV forecast data.txt');  
end

%% Truncate Current PV Forecast Data 
try
   PV_forecast_5minute = PV_minutes(1:5:end);
   time_5minute = time_minutes(1:5:end);
   current_time = clock;
   current_5minute_time = floor(current_time(4)*12+current_time(5)/5)
   if current_5minute_time == 0
		current_5minute_time = 1;
	end	
   PV_forecast_EMS = PV_forecast_5minute(current_5minute_time:current_5minute_time+287)

catch Me
    create_error_notification(home,Me.message,'get forecast_interp and extract PV forecast data.txt');  
end

%% Save data in optimization format
try
   cd(fullfile(home,'System Architecture Data','Network Model','PV'));
	%% ensure file is not in use
	setpointcontinue =0;
	while setpointcontinue <100
		fid = fopen('Solar Data.csv','w')
		if fid ==-1
			pause(0.05)
			setpointcontinue = setpointcontinue +1;
		else
			break
		end
	end
   %%
   fprintf(fid,'Time Interval (5 minutes),');
   
   for i = 1:288;
       fprintf(fid,'%f,',i);
   end;
   
   fprintf(fid, '%s\n','')
   fprintf(fid, '%f,',2)
   
   for i = 1:288;
       fprintf(fid,'%f,',PV_forecast_EMS(i)/13.4/1000*50); %based on 13.4kW PV/1000 W to kW/convert to 50kW
   end;
   fclose(fid);
   	
             
catch Me
    create_error_notification(home,Me.message,'get forecast_print load forecast data to file.txt');  
end






