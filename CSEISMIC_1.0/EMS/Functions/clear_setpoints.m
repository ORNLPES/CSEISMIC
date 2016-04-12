function clear_setpoints(handles)
%[] =  clear_setpoints(handles)
% sets generators to P/Q = 0/0, V/f = 480/60

global home;
global ignore_results;

try 
    %% open files containing needed information on sources
    try
        cd(fullfile(home,'System Architecture Data'))
        generators_list = importdata('generator_device_list.txt')
        es_list = importdata('ES_device_list.txt')
    catch Me
        create_error_notification(home,Me.message,'clear setpoints_opening base files.txt');
    end;
    
    try
        cd(fullfile(home,'System Data','Setpoints'))

        %% Ensure file is not open
        setpointcontinue =0;
        while setpointcontinue <1000
            fid = fopen('Setpoints.txt','w')
            if fid == -1
                pause(0.05)
                setpointcontinue = setpointcontinue +1;
                if setpointcontinue > 900
                    disp('stopped at run optimization grid connected')
                end;
            else
                setpointcontinue = 10000;
            end
        end
    catch Me
        create_error_notification(home,Me.message,'clear setpoints_opening setpoints to write.txt');
    end
    
    %% set values to initially zero to startup system.
    try
        for i = 1:length(generators_list)
            fprintf(fid,'%s,Real,%f\n',generators_list{i},0)
            fprintf(fid,'%s,Reactive,%f\n',generators_list{i},0)
            fprintf(fid,'%s,Voltage,%f\n',generators_list{i},480)
            fprintf(fid,'%s,Frequency,%f\n',generators_list{i},60)
        end;

        for i = 1:length(es_list)
             fprintf(fid,'%s,Real,%f\n',es_list{i},0)
             fprintf(fid,'%s,Reactive,%f\n',es_list{i},0)
             fprintf(fid,'%s,Voltage,%f\n',es_list{i},480)
             fprintf(fid,'%s,Frequency,%f\n',es_list{i},60) 
        end
    catch Me
        create_error_notification(home,Me.message,'clear setpoints_saving setpoints file.txt');
    end
    
    fclose(fid)        
  
catch Me
    create_error_notification(home,Me.message,'clear setpoints_main error.txt');

end


