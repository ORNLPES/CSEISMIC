function get_PCCmeasurement(program_status, home,SCADA_send, SCADA_receive, fault_icon)
%[] = get_PCCmeasurement(program_status, home,SCADA_send, SCADA_receive, fault_icon)
% obtains the PCC measurements only 

%% load islanding switch name
try
    cd(fullfile(home,'System Architecture Data','System Configuration'))
    island_controller_name_file = importdata('relay_island_controller.txt');
catch Me
    create_error_notification(home,Me.message,'get PCCmeasurement_opening file.txt');
end


try 
cd(fullfile(home))
    for k = 1:length(island_controller_name_file)-2

        %% sends SCADA data request
        try
            send_request_PCCmeasurement(program_status, home, SCADA_receive,SCADA_send, island_controller_name_file{1},island_controller_name_file{k+2})
        catch Me
            create_error_notification(home,Me.message,'get PCCmeasurement_sending data.txt');
        end

        %% data from SCADA
        try
            [data] = receive_request_measurement(program_status, home, SCADA_receive)
            measurement(k) = data;
        catch Me
             create_error_notification(home,Me.message,'get PCCmeasurement_receiving data.txt');
        end
    end;
catch Me
    create_error_notification(home,Me.message,'get PCCmeasurement_data gather loop.txt');  
end;

%% save data to file
try 
    cd(fullfile(home,'System Architecture Data'))
    fid = fopen('PCC_measurements_startup.txt','w')
    for i = 1:length(measurement)
        fprintf(fid,'%f\n',measurement(i))
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'get PCCmeasurement_saving data.txt');  
end;

