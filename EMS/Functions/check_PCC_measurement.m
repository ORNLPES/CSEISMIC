function check_PCC_measurement(handles)
% [] = check_PCC_measurement(handles)
% checks to ensure that PCC voltage measurements are within tolerance for
% blackstart

global home;
global system_status;

try
    %% pull measurements
    cd(fullfile(home,'System Architecture Data'))
    Measured_data = load('PCC_measurements_startup.txt'); 
catch Me  
    create_error_notification(home,Me.message,'check PCC measurement_measurement file.txt');  
end

try
    %% pull reference voltage
    cd(fullfile(home,'System Architecture Data','PCC measurements'))
    Reference_data = load('PCC_nominal_voltage.txt');   
catch Me
    create_error_notification(home,Me.message,'check PCC measurement_reference file.txt');  
end

%% confirm measurements are within tolerance else change system status
try
    for i = 1:length(Measured_data)
        if Measured_data(i) < 0.95*Reference_data(i)
            create_error_notification(home,'',strcat('Grid Voltage too low',num2str(i),'_',num2str(Measured_data(i)),'.txt'));
            system_status = 4;
        elseif Measured_data(i) > 1.05*Reference_data(i)
           create_error_notification(home,'',strcat('Grid Voltage too high',num2str(i),'_',num2str(Measured_data(i)),'.txt'));
           system_status = 4;
        end;
    end;
catch Me
        create_error_notification(home,Me.message,'check PCC measurement_conditional statements.txt');
end


