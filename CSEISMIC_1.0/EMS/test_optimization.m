
clear all;
clc;
home = cd;
addpath(fullfile(home,'Functions'))

%%%%%%%%%%%%%%%%%%%%%%%%%% LOADING DATA SETS %%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% load system measurement data for the optimization %%%%%%
try 
    cd(fullfile(home,'System Data','Measurements'))
    measurements = importdata('System Measurements.txt');
    
catch Me
        create_error_notification(home,Me.message,'run optimization_load measurements.txt');
end;

%%%%%%%%%%%%%% load relay list %%%%%%
try
    cd(fullfile(home,'System Architecture Data'))
    relay_list = importdata('relay_device_list.txt');
    
catch Me
    create_error_notification(home,Me.message,'run optimization_load relays.txt');
end

%%%%%%%%%%%%%% load relay list excel bus information %%%%%%
try
    cd(fullfile(home,'System Architecture Data','Network Model'))
     [relay_list_buses,relay_list_devices,RAW]= xlsread('relay_list.xlsx');
     relay_list_devices(1,:) = '';
     relay_list_devices(1,:) = '';
    
catch Me
    create_error_notification(home,Me.message,'run optimization_load relays.txt');
end

%%%%%%%%%%%%%% load PCC switch information %%%%%%
try
   cd(fullfile(home,'System Architecture Data','System Configuration'))
   relay_island_controller = importdata('relay_island_controller.txt');  
catch Me
    create_error_notification(home,Me.message,'run optimization_load PCC.txt');
end
   
%%%%%%%%%%%%%% load loading information %%%%%%
try
    cd(fullfile(home,'System Architecture Data','Network Model'))
     [load_list_buses,load_list_name,RAW]= xlsread('load_list.xlsx') ; 
catch Me
    create_error_notification(home,Me.message,'run optimization_load load information.txt');
end

%%%%%%%%%%%%%% load bus information %%%%%%
try
    cd(fullfile(home,'System Architecture Data','Network Model'))
     [list_buses,bus_list_name,RAW]= xlsread('number_of_buses.xlsx');  
     number_of_buses = max(list_buses);
     no_bus = number_of_buses;
catch Me
    create_error_notification(home,Me.message,'run optimization_load bus information.txt');
end

%%%%%%%%%%%%%% load generation information from network model %%%%%%
try
    cd(fullfile(home,'System Architecture Data','Network Model'))
     [generator_numbers,generator_names,RAW]= xlsread('generator_list.xlsx');
     generator_names(1,:) = '';
     generator_names(1,:) = '';
     Sbase = max(generator_numbers(:,2));
    
catch Me
    create_error_notification(home,Me.message,'run optimization_load relays.txt');
end

%%%%%%%%%%%%%% load generation information  %%%%%%
try
    cd(fullfile(home,'System Architecture Data'))
    if exist('generator_device_list.txt')
        generator_list = importdata('generator_device_list.txt');
    end;
    if exist('ES_device_list.txt')
        energy_storage_list = importdata('ES_device_list.txt');
    end;
    if exist('PV_device_list.txt') 
        PV_list = importdata('PV_device_list.txt');
    end;
    
catch Me
    create_error_notification(home,Me.message,'run optimization_generation assets.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    cd(fullfile(home,'System Architecture Data','Network Model'))
     [impedance_numbers,impedance_names,RAW]= xlsread('impedance_network.xlsx');
     impedance_names(1,:) = '';
     impedance_names(1,:) = '';
    
catch Me
    create_error_notification(home,Me.message,'run optimization_load relays.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%% LINK TO LOAD FLOW PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Define Pgen and Qgen
Pgen = zeros(1,number_of_buses);
Qgen = zeros(1,number_of_buses);

%%%%% Define Generator Buses and BASE
Pgen_max = zeros(1,number_of_buses);
Base = max(generator_numbers(:,2));

for i = 1:length(generator_numbers)
    Pgen_max(generator_numbers(i,1)) = generator_numbers(i,2)/Base;
end;

%%%%% Define Generator Buses and BASE
% assume PCC is bus 1;
bus_type(1) = 1;
bus_type(2:number_of_buses) = 3;

%%%%%%%%%%%%%%%%%%%%% Determine Pload/Qload %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% link relay information from network models to ini file %%%%%%
Pload = zeros(number_of_buses,1);
Qload = zeros(number_of_buses,1);

try
    for i = 1:length(relay_list_devices(:,1))
        for k = 1:length(relay_list)
            if strcmp(relay_list_devices{i,1},relay_list{k})
                relay_linkage(i) = relay_list_buses(k);
            end;
        end
        
    end;
    
catch Me
    create_error_notification(home,Me.message,'run optimization_relay checks.txt');
end

%%%%%%%%%%%%%% determine relays that supply load %%%%%%%%%%%%

for i = 1:length(load_list_buses)
    %%%%%%% in matrix relay load linkage first column designates position in
    %%%%%%% relay list bus that has a load, second column designates if it
    %%%%%%% is the first column or second column in the relay list bus
    %%%%%%% list.
    for k = 1:length(relay_list_buses(:,1))
        if load_list_buses(i) == relay_list_buses(k,1)
            relay_load_linkage(i,1) = k;
            relay_load_linkage(i,2) = 1;
        end;
        if load_list_buses(i) == relay_list_buses(k,2)
            relay_load_linkage(i,1) = k;
            relay_load_linkage(i,2) = 2;
        end;
    end;
end;

%%%%%%%%%%%%%% exta load data from relays %%%%%%%%%%%%%%%%%
try
    
    for i = 1:length(relay_load_linkage(:,1))
        a = 0;
        for k = 1:length(measurements.textdata(:,1))
            if strcmp (relay_list{relay_load_linkage(i,1)},measurements.textdata{k,1})
                a = a + 1;
                if strcmp('RealPowerPhaseA',measurements.textdata{k,2})
                    Pload(relay_list_buses(i,relay_load_linkage(i,2)),1) = measurements.data(k,1)/Sbase;
                elseif strcmp('RealPowerPhaseB',measurements.textdata{k,2})
                    Pload(relay_list_buses(i,relay_load_linkage(i,2)),2) = measurements.data(k,1)/Sbase;
                elseif strcmp('RealPowerPhaseC',measurements.textdata{k,2})
                    Pload(relay_list_buses(i,relay_load_linkage(i,2)),3) = measurements.data(k,1)/Sbase;
                elseif strcmp('ReactivePowerPhaseA',measurements.textdata{k,2})
                    Qload(relay_list_buses(i,relay_load_linkage(i,2)),1) = measurements.data(k,1)/Sbase;
                elseif strcmp('ReactivePowerPhaseB',measurements.textdata{k,2})
                    Qload(relay_list_buses(i,relay_load_linkage(i,2)),2) = measurements.data(k,1)/Sbase;
                elseif strcmp('ReactivePowerPhaseC',measurements.textdata{k,2})
                    Qload(relay_list_buses(i,relay_load_linkage(i,2)),3) = measurements.data(k,1)/Sbase;
                end;
            end;
        end;
    end;
    
    %PL rows (# number of devices, colums phase A/B/C)
    %QL rows (# number of devices, colums phase A/B/C)
catch Me
      create_error_notification(home,Me.message,'run optimization_determine loading from measurements.txt'); 
end

%%%%%%%%%%%%%%%%% Averaging across three phases %%%%%%%%%%%%%%%%%%%
try 
    Pload_hold = Pload;
    Qload_hold = Qload;
    
    clear Pload
    clear Qload
    for i = 1:length(Pload_hold(:,1))
        Pload(i) = mean(Pload_hold(i,:));
        Qload(i) = mean(Qload_hold(i,:));
    end
    
catch Me
     create_error_notification(home,Me.message,'run optimization_averaging phases power.txt'); 
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
%%%%%%%%%%%%%%%%% System Voltages %%%%%%%%%%%%
Vsystem = ones(number_of_buses,3);
delta = zeros(number_of_buses,1);
Vbase = 1;

%%%%%%%%%%%%%%%%% Pull data from relays %%%%%%%%%%%%%%%

try 
    for i = 1:length(relay_load_linkage(:,1))
        a = 0;
        for k = 1:length(measurements.textdata(:,1))
            if strcmp (relay_list{relay_load_linkage(i,1)},measurements.textdata{k,1})
                a = a + 1;
                if strcmp('VoltagePhaseA',measurements.textdata{k,2})
                    Vsystem(relay_list_buses(relay_load_linkage(i,1),1),1) = measurements.data(k,1)/Vbase;
                    Vsystem(relay_list_buses(relay_load_linkage(i,1),2),1) = measurements.data(k,1)/Vbase;
                elseif strcmp('VoltagePhaseB',measurements.textdata{k,2})
                    Vsystem(relay_list_buses(relay_load_linkage(i,1),1),2) = measurements.data(k,1)/Vbase;
                    Vsystem(relay_list_buses(relay_load_linkage(i,1),2),2) = measurements.data(k,1)/Vbase;
                elseif strcmp('VoltagePhaseC',measurements.textdata{k,2})
                    Vsystem(relay_list_buses(relay_load_linkage(i,1),1),3) = measurements.data(k,1)/Vbase;
                    Vsystem(relay_list_buses(relay_load_linkage(i,1),2),3) = measurements.data(k,1)/Vbase;
                end;
            end;
        end;
    end;
catch Me
     create_error_notification(home,Me.message,'run optimization_system voltages relay.txt'); 
end;    
 
%%%%%%%%%%%%%%%%% Pull data from PCC %%%%%%%%%%%%%%%
 
 try 
   for k = 1:length(measurements.textdata(:,1))
            if strcmp (relay_island_controller{1},measurements.textdata{k,1})
                a = a + 1;
                if strcmp('VoltagePhaseA',measurements.textdata{k,2})
                    Vsystem(1,1) = measurements.data(k,1)/Vbase;
                    Vsystem(2,1) = measurements.data(k,1)/Vbase;
                elseif strcmp('VoltagePhaseB',measurements.textdata{k,2})
                    Vsystem(1,2) = measurements.data(k,1)/Vbase;
                    Vsystem(2,2) = measurements.data(k,1)/Vbase;
                elseif strcmp('VoltagePhaseC',measurements.textdata{k,2})
                    Vsystem(1,3) = measurements.data(k,1)/Vbase; 
                    Vsystem(2,3) = measurements.data(k,1)/Vbase;
                end;
        end;
    end;
catch Me
     create_error_notification(home,Me.message,'run optimization_system voltages pcc.txt'); 
end;    

%%%%%%%%%%%%%%%%% Pull data from sources %%%%%%%%%%%%%%%

try
    for i = 1:length(generator_names(:,1))
        for k = 1:length(measurements.textdata(:,1))
            if strcmp (generator_names{i,1},measurements.textdata{k,1})
                a = a + 1;
                if strcmp('VoltagePhaseA',measurements.textdata{k,2})
                    Vsystem(generator_numbers(i),1) = measurements.data(k,1)/Vbase;
                elseif strcmp('VoltagePhaseB',measurements.textdata{k,2})
                    Vsystem(generator_numbers(i),2) = measurements.data(k,1)/Vbase;
                elseif strcmp('VoltagePhaseC',measurements.textdata{k,2})
                    Vsystem(generator_numbers(i),3) = measurements.data(k,1)/Vbase;
                end;
            end;
        end;
    end;
catch Me
     create_error_notification(home,Me.message,'run optimization_system voltages sources.txt'); 
end;    

%%%%%%%%%%%%%%%%% Averaging across three phases %%%%%%%%%%%%%%%%%%%
try 
    for i = 1:length(Vsystem(:,1))
        V(i) = mean(Vsystem(i,:));
    end
    
catch Me
     create_error_notification(home,Me.message,'run optimization_averaging phases voltages.txt'); 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%% System Models %%%%%%%%%%%%%%%%%%%%%%%%%%%% 

try
    a = 0;
    for i = 1:length(impedance_numbers(:,1))
        a = a + 1;
        from_bus(a) = impedance_numbers(a,1); 
        to_bus(a) = impedance_numbers(a,2);
        R(a) = impedance_numbers(a,3);
        X(a) = impedance_numbers(a,4);
        B(a) = impedance_numbers(a,5);
    end;
        
catch Me
     create_error_notification(home,Me.message,'run optimization_system impedance cables.txt');    
end

%%%%%%%%%%%%%%%%%%% System Models %%%%%%%%%%%%%%%%%%%%%%%%%%%% 

try
    for i = 1:length(relay_list_buses(:,1))
        a = a + 1;
        from_bus(a) = relay_list_buses(i,1); 
        to_bus(a) = relay_list_buses(i,2);
        R(a) = .0001;
        X(a) = .0001;
        B(a) = .01;
    end;
        
catch Me
     create_error_notification(home,Me.message,'run optimization_system impedance relays.txt');    
end


Pgen 
Pgen_max 
Qgen 
Pload
Qload
bus_type
V 
delta 



%     Pgen = [0 0 0 0];
%     Pgen_max = [0 0 0 1];
%     Qgen = [0 0 0 0];
%     Pload = [0 0 1 0];
%     Qload = [0 0 0.5 0];
%     bus_type = [1, 2, 3, 2];
%     V = [1 1 1 1];
%     delta = [0 0 0 0];
%     coordinatey = [40.6818  38.9017  39.952  41.2]; 
%     coordinatex = -[74.2149  77.0678  75.1634 76.2];
% 
%     j = sqrt(-1);
% 
%     from_bus = [1 1 2 2 3];
%     to_bus = [2 3 3 4 4];
%     R = [0.02, 0.01, 0.01, 0.01, 0.01];
%     X = [0.3, 0.1, 0.1, 0.1, 0.1];
%     B = [0.15, 0.1, 0.1, 0.1, 0.1];
%     Pmax = [1, 1, 1, 1, 1];
% 
%     no_bus = 4;

%%%%%%%%%%%%%%%%%%% INSERT SYSTEM INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%


 try 
    [Y] = admittance_matrix(no_bus, R, X, B, from_bus, to_bus);
 catch  Me
    create_error_notification(home,Me.message,'run optimization_admittance matrix.txt');    
 end;
 
 %Pload = Pload*Sbase
 for i = 1:length(V)
     V(i) = 1;
 end;
 %R = R * 100
 %X = X * 100
 %B = B * 100
 [Pgen, Pflow] = load_flow(Y, V, delta, no_bus, from_bus, to_bus, bus_type, Pgen, Pload, Qgen, Qload)

%  try
%     save_data_optimization(home, Y, V, delta, no_bus, from_bus, to_bus, bus_type, Pload, Qload, Pgen_max);
%  catch Me
%          create_error_notification(home,Me.message,'run optimization_saving system parameters.txt');    
%  end;
%  
%  try 
%     numofgens = 0;
%     for i = 1:length(Pgen_max)
%         if Pgen_max(i) > 0
%             numofgens = numofgens + 1;
%         end;
%     end;
% 
%     % consider both real and reactive power
%     numberOfVariables = numofgens*2;
% 
%     for i = 1:numberOfVariables
%         ub(i) = 1; % Upper bound
%         lb(i) = 0;% Lower bound
%     end;
% 
%     a = 1;
%     for i = 1:numofgens
%         initial_pop(a:a+1) = [1 , 1]; 
%         a = a + 2;
%     end;
% 
%     FitnessFunction = @load_flow_ga;
%     options = gaoptimset('PlotFcns',@gaplotpareto,'TolFun',1,'InitialPopulation',initial_pop,'PopulationSize',50,'Generations',30);
%     [x,fval] = gamultiobj(FitnessFunction,numberOfVariables,[], ...
%         [],[],[],lb,ub,options);
%  catch Me
%         create_error_notification(home,Me.message,'run optimization_ga run.txt');
%  end
%  
%  try
%     a = 0;
%     b = floor(length(x)/2);
%     for i = 1:length(Pgen_max)
%         if Pgen_max(i) > 0
%             a = a + 1;
%             b = b + 1;
%             Pgen(i) = x(a);
%             Qgen(i) = x(b);
%         else
%             Pgen(i) = 0;
%             Qgen(i) = 0;
%         end;
%     end;
% 
%     [Pgen, Pflow] = load_flow(Y, V, delta, no_bus, from_bus, to_bus, bus_type, Pgen, Pload, Qgen, Qload)
% catch Me
%     create_error_notification(home,Me.message,'run optimization_ga results.txt');
% end;

cd(fullfile(home))