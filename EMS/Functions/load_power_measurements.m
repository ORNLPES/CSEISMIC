function [Net_power] = load_power_measurements()
%% [Net_power] = load_power_measurements()
global home;

%% load device names
try
    cd(fullfile(home,'System Architecture Data'))
    
    %% load relay list
    a = 0;
    if exist('relay_device_list.txt')
        relay_names = importdata('relay_device_list.txt');
    end;
    
    %% load PV list
    if exist('PV_device_list.txt')
        PV_names = importdata('PV_device_list.txt');
    end;
    
    %% load generator list
    if exist('generator_device_list.txt')
        generator_names = importdata('generator_device_list.txt');

    end;

    %% load energy storage list
    if exist('ES_device_list.txt')
        ES_names = importdata('ES_device_list.txt');
    end;
    
catch
    
end;

%% load v/f controller
try
    cd(fullfile(home,'System Architecture Data','System Configuration'))
    vf_name = importdata('island_controller.txt');
catch
end;

%% determine net power
rerun = 0;
while rerun == 0
    try
        cd(fullfile(home,'System Data','Measurements'))
        measurements = importdata('System Measurements.txt');

        %% sum all loads
        Power_pu_load = zeros(1,3);
        for i = 1:length(relay_names)
            for k = 1:length(measurements.textdata(:,1))
                if strcmp (relay_names{i},measurements.textdata{k,1})
                    if strcmp('RealPowerPhaseA',measurements.textdata{k,2})
                        Power_pu_load(1) = measurements.data(k,1) + Power_pu_load(1);
                    elseif strcmp('RealPowerPhaseB',measurements.textdata{k,2})
                        Power_pu_load(2) = measurements.data(k,1) + Power_pu_load(2);
                    elseif strcmp('RealPowerPhaseC',measurements.textdata{k,2})
                        Power_pu_load(3) = measurements.data(k,1) + Power_pu_load(3);
                    end;         
                end;
            end;
        end;
        
        %% sum all generation
        Power_pu_gen = zeros(1,3);
        for i = 1:length(generator_names)
            for k = 1:length(measurements.textdata(:,1))
                if strcmp (generator_names{i},measurements.textdata{k,1})
                    if strcmp('RealPowerPhaseA',measurements.textdata{k,2})
                        Power_pu_gen(1) = measurements.data(k,1) + Power_pu_gen(1);
                    elseif strcmp('RealPowerPhaseB',measurements.textdata{k,2})
                        Power_pu_gen(2) = measurements.data(k,1) + Power_pu_gen(2);
                    elseif strcmp('RealPowerPhaseC',measurements.textdata{k,2})
                        Power_pu_gen(3) = measurements.data(k,1) + Power_pu_gen(3);
                    end;
                end;
            end;
        end;
        
        %% sum all energy storage
        Power_pu_ES = zeros(1,3);
        for i = 1:length(ES_names)
            for k = 1:length(measurements.textdata(:,1))
                if strcmp (ES_names{i},measurements.textdata{k,1})
                    if strcmp('RealPowerPhaseA',measurements.textdata{k,2})
                        Power_pu_ES(1) = measurements.data(k,1) + Power_pu_ES(1);
                    elseif strcmp('RealPowerPhaseB',measurements.textdata{k,2})
                        Power_pu_ES(2) = measurements.data(k,1) + Power_pu_ES(2);
                    elseif strcmp('RealPowerPhaseC',measurements.textdata{k,2})
                        Power_pu_ES(3) = measurements.data(k,1) + Power_pu_ES(3);
                    end;
                end;
            end;
        end;
        
         %% sum all PV
        Power_pu_PV = zeros(1,3);
        for i = 1:length(PV_names)
            for k = 1:length(measurements.textdata(:,1))
                if strcmp (PV_names{i},measurements.textdata{k,1})
                    if strcmp('RealPowerPhaseA',measurements.textdata{k,2})
                        Power_pu_PV(1) = measurements.data(k,1) + Power_pu_PV(1);
                    elseif strcmp('RealPowerPhaseB',measurements.textdata{k,2})
                        Power_pu_PV(2) = measurements.data(k,1) + Power_pu_PV(2);
                    elseif strcmp('RealPowerPhaseC',measurements.textdata{k,2})
                        Power_pu_PV(3) = measurements.data(k,1) + Power_pu_PV(3);
                    end;
                end;
            end;
        end;
        
        %% find v/f 
        for i = 1:length(ES_names)
            for k = 1:length(measurements.textdata(:,1))
                if strcmp (vf_name{i},measurements.textdata{k,1})
                    if strcmp('RealPowerPhaseA',measurements.textdata{k,2})
                        hold_onto_power(1) = measurements.data(k,1);
                    elseif strcmp('RealPowerPhaseB',measurements.textdata{k,2})
                        hold_onto_power(2) = measurements.data(k,1);
                    elseif strcmp('RealPowerPhaseC',measurements.textdata{k,2})
                        hold_onto_power(3) = measurements.data(k,1);
                    end;
                end;
            end;
        end;
        
        for i = 1:length(generator_names)
            for k = 1:length(measurements.textdata(:,1))
                if strcmp (vf_name{i},measurements.textdata{k,1})
                    if strcmp('RealPowerPhaseA',measurements.textdata{k,2})
                        hold_onto_power(1) = measurements.data(k,1);
                    elseif strcmp('RealPowerPhaseB',measurements.textdata{k,2})
                        hold_onto_power(2) = measurements.data(k,1);
                    elseif strcmp('RealPowerPhaseC',measurements.textdata{k,2})
                        hold_onto_power(3) = measurements.data(k,1);
                    end;
                end;
            end;
        end;
        
        % determine target power
        Net_power = sum(Power_pu_load) - sum(Power_pu_ES) - sum(Power_pu_PV)...
            - sum(Power_pu_gen) + sum(hold_onto_power);
        
        rerun = 1;
        
    catch
        
        
    end;
end;
            
            
            
 
