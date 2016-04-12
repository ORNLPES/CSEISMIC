function [] = get_cost()
% [] = get_cost()
% pulls costs data from files

global system_status;
global home;

%% Load Price Forecast Data
try
   cd(fullfile('C:/','Load_Forecast_Data','Real Time Price Data'))
   time_stamp = clock;
   filename = strcat(num2str(time_stamp(1),'%02.0f'),num2str(time_stamp(2),'%02.0f'),num2str(time_stamp(3),'%02.0f'),'-da.csv')
   
    delimiter = ',';
    startRow = 4;

    %% Read columns of data as strings:
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

    %% Open the text file.
    fileID = fopen(filename,'r');
        
    if fileID == -1
       time_stamp = datevec(datenum(clock)-1)
       filename = strcat(num2str(time_stamp(1),'%02.0f'),num2str(time_stamp(2),'%02.0f'),num2str(time_stamp(3),'%02.0f'),'-da.csv')
       fileID = fopen(filename,'r');
    end;


    %% Read columns of data according to format string.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

    %% Close the text file.
    fclose(fileID);

    for i = 2:length(dataArray)
        actual_cost(i-1) = str2double(dataArray{i}(1));
    end;
    
    actual_cost(length(actual_cost)+1:2*length(actual_cost))= actual_cost;

catch Me
    create_error_notification(home,Me.message,'get cost_load price data.txt');  
end

%% Interp and Extract Current Load Forecast Data
try
   price_forecast_5minute = interp(actual_cost,12);
   current_time = clock;
   current_5minute_time = floor(current_time(4)*12+current_time(5)/5)
   if current_5minute_time == 0
		current_5minute_time =1;
	end
   price_forecast_EMS = price_forecast_5minute(current_5minute_time:current_5minute_time+287)

catch Me
    create_error_notification(home,Me.message,'get cost_interp and extract price data.txt');  
end

%% Formatting for optimizer
try
   cd(fullfile(home,'System Data','Price Data','Electricity Tariff'));
   	%% ensure file is not in use
	setpointcontinue =0;
	while setpointcontinue <100
		fid = fopen('Tariff.csv','w')
		if fid ==-1
			pause(0.05)
			setpointcontinue = setpointcontinue +1;
		else
			break
		end
	end
   %%
   
   fprintf(fid,'Time Interval (5 minutes),Price ($/kW)\n');
   for i = 1:288;
       fprintf(fid,'%f,%f\n',i,price_forecast_EMS(i)/1000);
   end;
   fclose(fid);
             
catch Me
    create_error_notification(home,Me.message,'get cost_print price data to file.txt');  
end