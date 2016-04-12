function [Net_power] = run_optimization_trans_to_island()
% [Net_power] = run_optimization_trans_to_island()
% pulls net power measurements for v/f controller target

global home;

%% get system measurements
try
    [Net_power] = load_power_measurements()
catch Me
    create_error_notification(home,Me.message,'run optimization trans to island_pulling measurements.txt');
end

