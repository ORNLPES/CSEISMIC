function  save_optimization_settings(handles)
%[] = save_optimization_settings(handles)
% pulls the optimization settings from GUI

global home;

%% pull indicators from GUI
indicators(1) = get(handles.system_costs,'Value');
indicators(2) = get(handles.power_factor,'Value');
indicators(3) = get(handles.demand_charge,'Value');
indicators(4) = get(handles.loss_indicator,'Value');
indicators(5) = get(handles.voltage_indicator,'Value');
indicators(6) = get(handles.commitment_check,'Value');

 cd(fullfile(home,'System Architecture Data','Optimization Settings'))
 
 %% saving optmization settings
 write_accepted = 0;
 while write_accepted == 0
    fid = fopen('Optimization_settings.txt','w')
    
    if fid == -1
    else
        for i = 1:length(indicators)
            fprintf(fid,'%f\n',indicators(i))
        end;
        fclose(fid)
        write_accepted = 1;
    end;
 end;
