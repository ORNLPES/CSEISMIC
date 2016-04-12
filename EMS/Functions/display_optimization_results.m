function display_optimization_results(handles)
global home;

%% get optimization results

    set(handles.program_status,'String','Plotting Load Forecast')
    pause(0.1)
    
    %%%%%%%%%%%%%% Load Load Forecast Data %%%%%%%%%%%%%%%
    cd(fullfile(home))
    cd(fullfile(home,'System Architecture Data','Network Model','Load'))
    fid = fopen('P_Load.csv');

    string_count = '%s%s';
    for i = 1:288
        string_count = strcat(string_count,'%s');
    end;

    data = textscan(fid,string_count,'Delimiter',',');
    fclose(fid);

    cd(fullfile(home))

    for i = 2:length(data)-1
        Total_Power(i) = str2double(data{i}(2:length(data{1})));
    end;

    %%%%%%%%%%%%%% Plot Load Forecast %%%%%%%%%%%%%%%
    plot(handles.Load_forecast_axis,Total_Power)
    set(handles.Load_forecast_axis,'Layer','top')
    colormap jet
    title(handles.Load_forecast_axis,'Load Forecast')
    ylabel(handles.Load_forecast_axis,'Power(kW)','Color','White')
    xlabel(handles.Load_forecast_axis,'5 Minute Intervals')
    set(handles.Load_forecast_axis,'xColor',[1 1 1])
    set(handles.Load_forecast_axis,'yColor',[1 1 1])
    set(handles.Load_forecast_axis,'Color',[0 0 0])



    set(handles.program_status,'String','Plotting Price Forecast')
    pause(0.1)
    
    %%%%%%%%%%%%%% Load Price Forecast Data %%%%%%%%%%%%%%%
    cd(fullfile(home))
    cd(fullfile(home,'System Data','Price Data','Electricity Tariff'))
    fid = fopen('Tariff.csv');

    string_count = '%s%s';

    data = textscan(fid,string_count,'Delimiter',',');
    fclose(fid);

    for i = 2:length(data{2})
        price_points(i-1) = str2double(data{2}(i));
    end;

    cd(fullfile(home))


    %%%%%%%%%%%%%% Plot Price Forecast %%%%%%%%%%%%%%%
    plot(handles.Real_time_price_axes,price_points)
    set(handles.Real_time_price_axes,'Layer','top')
    colormap jet
    title(handles.Real_time_price_axes,'Electricity Price')
    ylabel(handles.Real_time_price_axes,'Electricity Price','Color','White')
    xlabel(handles.Real_time_price_axes,'5 Minute Intervals')
    set(handles.Real_time_price_axes,'xColor',[1 1 1])
    set(handles.Real_time_price_axes,'yColor',[1 1 1])
    set(handles.Real_time_price_axes,'Color',[0 0 0])
    
    set(handles.program_status,'String','Plotting Optimization Results')
    pause(0.1)
    
    % clear any status files in System Architecture Data
    cd(fullfile(home))
    cd(fullfile(home,'System Data','Optimized Results'))

    %%%%%%%%%%%%%% Load Optimization Results %%%%%%%%%%%%%%%
    fid = fopen('Optimization Results.csv');

    string_count = '%s%s';
    for i = 1:288
        string_count = strcat(string_count,'%s');
    end;

    data = textscan(fid,string_count,'Delimiter',',');
    fclose(fid);

    cd(fullfile(home))

    counter_array = zeros(100,1);
    for i = 2:length(data{2})

        %%%%%%%%%%%%%%%%%%%%%%%% Pull data from row %%%%%%%%%%%%%%%%
        new_data = zeros(288,1);
        for k = 1:length(new_data)
            new_data(k) = str2double(data{2+k}(i));
        end;

        %%%%%%%%%%%%%%%%%%%%%%%%% Define data to data types %%%%%%%%%%%%%%
        if strcmp(data{2}(i),'20')
            counter_array(20) = counter_array(20) + 1;
            battery_results(counter_array(20),:) = new_data;
        elseif strcmp(data{2}(i),'22')
            counter_array(22) = counter_array(22) + 1;
            SOC_results(counter_array(22),:) = new_data;
        else
        end;

    end;


    %%%%%%%%%%%%%% Plot Optimization Results %%%%%%%%%%%%%%%
    plot(handles.main_optimization_axes,battery_results/1000)
    set(handles.main_optimization_axes,'Layer','top')
    colormap jet
    title(handles.main_optimization_axes,'Real Power Optimization Results')
    ylabel(handles.main_optimization_axes,'Power Demand(kW)','Color','White')
    xlabel(handles.main_optimization_axes,'5 Minute Intervals')
    set(handles.main_optimization_axes,'xColor',[1 1 1])
    set(handles.main_optimization_axes,'yColor',[1 1 1])
    set(handles.main_optimization_axes,'Color',[0 0 0])

    plot(handles.SOC_axes,SOC_results)
    set(handles.SOC_axes,'Layer','top')
    colormap jet
    title(handles.SOC_axes,'SOC Results')
    ylabel(handles.SOC_axes,'SOC(%)','Color','White')
    xlabel(handles.SOC_axes,'5 Minute Intervals')
    set(handles.SOC_axes,'xColor',[1 1 1])
    set(handles.SOC_axes,'yColor',[1 1 1])
    set(handles.SOC_axes,'Color',[0 0 0])

    pause(1);
    
%     