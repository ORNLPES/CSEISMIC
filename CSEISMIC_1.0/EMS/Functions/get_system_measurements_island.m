function get_system_measurements_island(handles)
%[] = get_system_measurements_island(handles)
% obtains measurements from devices from SCADA

global home;
global SCADA_receive;
global SCADA_send;

Measurements = 0;

%% load files for devices and define types
try
    cd(fullfile(home,'System Architecture Data'))
    
    % Type 1: PV Source
    % Type 2: Energy Storage
    % Type 3: Diesel Generator
    % Type 4: Relay 

    a = 0;
    if exist('relay_device_list.txt')
        device_names = importdata('relay_device_list.txt');
        
        for i = 1:length(device_names)
            a = a + 1;
            device_name_list(a) = device_names(i);
            device_type(a) = 4;
        end;

    end;
    
    if exist('PV_device_list.txt')
        device_names = importdata('PV_device_list.txt');
        
        for i = 1:length(device_names)
            a = a + 1;
            device_name_list(a) = device_names(i);
            device_type(a) = 1;
        end;
    end;
    
    if exist('generator_device_list.txt')
        device_names = importdata('generator_device_list.txt');
        
        for i = 1:length(device_names)
            a = a + 1;
            device_name_list(a) = device_names(i);
            device_type(a) = 3;
        end;
    end;
    
    if exist('main_switch_device_list.txt')
        device_names = importdata('main_switch_device_list.txt');
        
        for i = 1:length(device_names)
            a = a + 1;
            device_name_list(a) = device_names(i);
            device_type(a) = 4;
        end;
    end;
    
    if exist('ES_device_list.txt')
        device_names = importdata('ES_device_list.txt');
        
        for i = 1:length(device_names)
            a = a + 1;
            device_name_list(a) = device_names(i);
            device_type(a) = 2;
        end;
    end;

catch Me
    create_error_notification(home,Me.message,'island mode_get system measurements_opening file.txt');
end

%% pulls optimization data and relay names from files
try
    cd(fullfile(home,'System Architecture Data','System Configuration'))
    optimization_variables = importdata('Optimization_Measurements.txt');
    relay_variables = importdata('Relay_Measurements.txt');
catch Me
    create_error_notification(home,Me.message,'island mode_get system measurements_opening file2.txt');
end
   
%% sends SCADA request for measurements
try
    send_request_measurements(handles.program_status, home, SCADA_receive,SCADA_send, device_name_list,optimization_variables,relay_variables,device_type)
catch Me
    create_error_notification(home,Me.message,'island mode_get system measurements_sending request.txt');
end;

%% receive and process confirmation from SCADA
try
    [IEDname,Measurementname,measurement_actual] = receive_request_fullmeasurements(handles.program_status, home, SCADA_receive)
catch Me
        create_error_notification(home,Me.message,'island mode_get system measurements_getting confirmation.txt');
end;

%% break apart data to extract useful information
try
    [IEDname_array] = strsplit(IEDname{1}',',');
    [Measurementname_array] = strsplit(Measurementname{1}',',');

catch Me
     create_error_notification(home,Me.message,'island mode_get system measurements_parsing returned data.txt');

end;

%% save measurements to file
try
    cd(fullfile(home,'System Data','Measurements'))
    %% ensure file is not in use
	setpointcontinue = 0;
	while setpointcontinue <100
		fid = fopen('System Measurements.txt','w')
		if fid ==-1
			pause(0.05)
			setpointcontinue = setpointcontinue +1;
		else
			break
		end
	end
   %%
    for i = 1:length(measurement_actual)
        fprintf(fid,'%s,%s,%f\n',IEDname_array{i},Measurementname_array{i},measurement_actual(i))
    end;
    fclose(fid)
catch Me
            create_error_notification(home,Me.message,'island mode_get system measurements_saving measurements.txt');
end;