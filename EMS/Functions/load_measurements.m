function [measurements] = load_measurements()
global home;

%% loads setpoints information safely (does not load incorrect information or
%% when file is partially created.)
    rerun = 0;
    while rerun == 0
        try
            cd(fullfile(home,'System Data','Measurements'))
            measurements = importdata('System Measurements.txt');

            Vbase = 480;
            for k = 1:length(measurements.textdata(:,1))
                if strcmp (relay_island_controller{1,1},measurements.textdata{k,1})
                    if strcmp('VoltagePhaseA',measurements.textdata{k,2})
                        VPCC_pu(1) = measurements.data(k,1)/Vbase;
                    elseif strcmp('VoltagePhaseB',measurements.textdata{k,2})
                        VPCC_pu(2) = measurements.data(k,1)/Vbase;
                    elseif strcmp('VoltagePhaseC',measurements.textdata{k,2})
                        VPCC_pu(3) = measurements.data(k,1)/Vbase;
                    end;
                end;
            end;
            VPCC_pu
            rerun = 1;
        catch
        end
    end;

end

