function [system_data,device_list,device_parameters] = load_setpoints()
%[] = [system_data,device_list,device_parameters] = load_setpoints()
%% loads setpoints information safely (does not load incorrect information or
%% when file is partially created.)
    rerun = 0;
    while rerun == 0
        try
            data = importdata('Setpoints.txt')

            system_data = data.data
            device_list = data.textdata(:,1)
            device_parameters = data.textdata(:,2)
            rerun = 1;
        catch
            pause(0.3);
        end
    end;

end

