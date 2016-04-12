function set_device_info(program_status, fault_icon)
global home;
global SCADA_send;
global SCADA_receive;

 %% load device control modes
try
    cd(fullfile(home,'System Architecture Data','System Configuration'))
    fid = fopen('Control_Modes.csv');

    % only 2 columns in csv
    string_count = '%s%s';
    
    % pull data into 2 cells (1st cell is for information only)
    % column 1 device names
    % column 2 control type (PV/PQ)
    data = textscan(fid,string_count,'Delimiter',',');
        
    fclose(fid);

catch Me
    create_error_notification(home,Me.message,'get PCCmeasurement_setting control states.txt');
end

%% setting control message states for devices
try
   
    device_names = data{1};
    control_modes = data{2};
    
    for i = 2:length(data{1})   
        IED_name = device_names{i};
        parameter_name = 'DroopSelect';
        data_type = 0;
        if strcmp(control_modes(i),'PV')
            data = 1;
        elseif strcmp(control_modes(i),'PQ')
            data = 0;
        else
            create_error_notification(home,Me.message,'get PCCmeasurement_unknown control mode.txt');
        end;
        
        send_request_set_parameters(program_status, IED_name,parameter_name,data_type,data);
    end;

catch Me
    create_error_notification(home,Me.message,'get PCCmeasurement_setting control states.txt');
end

%% receiving control message states for devices
try  
    receive_request_set_parameters(program_status);
catch Me
    create_error_notification(home,Me.message,'get PCCmeasurement_receiving confirmation.txt');
end

