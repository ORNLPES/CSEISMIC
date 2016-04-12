function [SOCs] = load_measurements_SOC()
% [SOCs] = load_measurements_SOC()
%% loads setpoints information safely (does not load incorrect information or
%% when file is partially created.)
    rerun = 0;
    while rerun == 0
        try
            measurements = importdata('System Measurements.txt');

        %% FIND SOCs in data %%%%%%%%%%%%%%
            a = 0;
            for k = 1:length(measurements.textdata(:,1))
                    if strcmp('StateofCharge',measurements.textdata{k,2})
                        a = a + 1;
                        SOCs(a) = measurements.data(k,1);
                    end;       
            end;
            SOCs;
            rerun = 1;
        catch
            pause(.3)
        end
    end;

end

