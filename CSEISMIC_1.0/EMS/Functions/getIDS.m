function getIDS(program_status,home)
%getIDS(program_status,home) create local list of devices and information for optimation
%%%%%%% purposes and communications from MODBUS files. 

%% load MODBUS files %%%%%
try
    
    cd(fullfile(home))
    cd(fullfile(home,'System Architecture Data'))
    data2 = importdata('Modbus_File_names_located.txt','w')
catch Me
    create_error_notification(home,Me.message,'getIDS_missing Modbus.txt');
end;

%% Breakout important information in modbus files.
try
    cd(fullfile(home,'System Architecture Data','Communications'))
    a = 0;
    for i = 1:length(data2)
        a = a + 1;
        fid = fopen(data2{i})
        tline = fgetl(fid)
        while ischar(tline)
            %% looking for device names
            [str_match] = strfind(tline,'Name');
            if isempty(str_match)
            else
                [str_parts] = strsplit(tline,'"');
                device_name(a) = str_parts(2);
            end;
            
             %% looking for device type (device types defined in Notes/Devices_Definitions.txt)
            [str_match] = strfind(tline,'DeviceType')
            if isempty(str_match)
            else
                [str_parts] = strsplit(tline,'"');
                device_type(a) = str_parts(2);
            end;
            tline = fgetl(fid)
        end;
        fclose(fid)
    end; 
catch Me
    create_error_notification(home,Me.message,'getIDS_error opening Modbus files.txt');
end

%% Save Device Names
try
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('Device_names.txt','w')
    for i = 1:length(device_name)
        fprintf(fid,'%s\n',device_name{i})
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'getIDS_error saving device names.txt');
end

%% creating list of components through system by type.
try
    storage_count = 0;
    PV_count = 0;
    generator_count = 0;
    relay_count = 0;
    main_switch_count = 0;
    wind_count = 0;
    
% Links the device types to numeric format. 
    for i = 1:length(device_name)
        if strcmp(device_type{i},'Storage')
            storage_count = storage_count + 1;
            device_name_storage(storage_count) = device_name(i);
 
        elseif strcmp(device_type{i},'PV')
            PV_count = PV_count + 1;
            device_name_PV(PV_count) = device_name(i);
            
        elseif strcmp(device_type{i},'Generator')
            generator_count = generator_count + 1;
            device_name_generator(generator_count) = device_name(i);
            
        elseif strcmp(device_type{i},'Relay')
            relay_count = relay_count + 1;
            device_name_relay(relay_count) = device_name(i);
            
        elseif strcmp(device_type{i},'MainSwitch')
            main_switch_count = main_switch_count + 1;
            device_name_main_switch(main_switch_count) = device_name(i);
            
       elseif strcmp(device_type{i},'Wind')
            wind_count = wind_count + 1;
            device_name_wind(wind_count) = device_name(i);
        else
            create_error_notification(home,device_type(i),'getIDS_undefined device.txt');
        end;
            
    end;
    
    
catch Me
        create_error_notification(home,Me.message,'getIDS_restricting to optimization set.txt');
end;
    
%% device name list of Energy Storage  
try
 
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('ES_device_list.txt','w')
    for i = 1:storage_count
        fprintf(fid,'%s\n',device_name_storage{i})
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'getIDS_error saving device storage names.txt');
end

%% device name list of PV  
try
 
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('PV_device_list.txt','w')
    for i = 1:PV_count
        fprintf(fid,'%s\n',device_name_PV{i})
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'getIDS_error saving device PV names.txt');
end

%% device name list of Generator  
try
 
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('generator_device_list.txt','w')
    for i = 1:generator_count
        fprintf(fid,'%s\n',device_name_generator{i})
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'getIDS_error saving device generator names.txt');
end

%% device name list of Mainswitch  
try
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('main_switch_device_list.txt','w')
    for i = 1:main_switch_count
        fprintf(fid,'%s\n',device_name_main_switch{i})
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'getIDS_error saving device main switch names.txt');
end

%% device name list of Relays  
try
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('relay_device_list.txt','w')
    for i = 1:relay_count
        fprintf(fid,'%s\n',device_name_relay{i})
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'getIDS_error saving device relay names.txt');
end

%% device name list of Wind  
try
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('wind_device_list.txt','w')
    for i = 1:wind_count
        fprintf(fid,'%s\n',device_name_wind{i})
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'getIDS_error saving device wind names.txt');
end

%% returns back to main directory for stepping through startup sequence
cd(fullfile(home))


