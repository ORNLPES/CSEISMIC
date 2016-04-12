function varargout = Optimization_Results(varargin)
% OPTIMIZATION_RESULTS MATLAB code for Optimization_Results.fig
%      OPTIMIZATION_RESULTS, by itself, creates a new OPTIMIZATION_RESULTS or raises the existing
%      singleton*.
%
%      H = OPTIMIZATION_RESULTS returns the handle to a new OPTIMIZATION_RESULTS or the handle to
%      the existing singleton*.
%
%      OPTIMIZATION_RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIMIZATION_RESULTS.M with the given input arguments.
%
%      OPTIMIZATION_RESULTS('Property','Value',...) creates a new OPTIMIZATION_RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Optimization_Results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Optimization_Results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Optimization_Results

% Last Modified by GUIDE v2.5 24-Nov-2015 06:37:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Optimization_Results_OpeningFcn, ...
                   'gui_OutputFcn',  @Optimization_Results_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Optimization_Results is made visible.
function Optimization_Results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Optimization_Results (see VARARGIN)

% Choose default command line output for Optimization_Results
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Optimization_Results wait for user response (see UIRESUME)
% uiwait(handles.figure1);
home = cd;

addpath(fullfile(home,'Functions'))
addpath(fullfile(home))

set(handles.program_status,'String',' ')

% --- Outputs from this function are returned to the command line.
function varargout = Optimization_Results_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop
stop = 0;

home = cd;
while stop == 0
    
    [filextention] = current_time();
    set(handles.program_status,'String',strcat('Plotting Load Forecast',filextention))
    pause(0.1)
    
    try 
        %% Load Load Forecast Data %%%%%%%%%%%%%%%
        cd(fullfile(home))
        cd(fullfile(home,'System Architecture Data','Network Model','Load'))
        %% ensure file is not in use
        setpointcontinue = 0;
        while setpointcontinue <100
            fid = fopen('P_Load.csv');
            if fid ==-1
                pause(0.05)
                setpointcontinue = setpointcontinue +1;
            else
                break
            end
        end

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

        %% Plot Load Forecast %%%%%%%%%%%%%%%
        plot(handles.Load_forecast_axis,Total_Power)
        set(handles.Load_forecast_axis,'Layer','top')
        colormap jet
        title(handles.Load_forecast_axis,'Load Forecast')
        ylabel(handles.Load_forecast_axis,'Power(kW)','Color','White')
        xlabel(handles.Load_forecast_axis,'5 Minute Intervals')
        set(handles.Load_forecast_axis,'xColor',[1 1 1])
        set(handles.Load_forecast_axis,'yColor',[1 1 1])
        set(handles.Load_forecast_axis,'Color',[0 0 0])
    catch
       set(handles.program_status,'String','Failed Plotting Load Forecast') 
    end;
	
    [filextention] = current_time();
    set(handles.program_status,'String',strcat('Plotting Price Forecast',filextention))
    pause(0.1)
    
    try
        %% Load Price Forecast Data %%%%%%%%%%%%%%%
        cd(fullfile(home))
        cd(fullfile(home,'System Data','Price Data','Electricity Tariff'))
        %% ensure file is not in use
        setpointcontinue = 0;
        while setpointcontinue <100
            fid = fopen('Tariff.csv');
            if fid ==-1
                pause(0.05)
                setpointcontinue = setpointcontinue +1;
            else
                break
            end
        end
       %%

        string_count = '%s%s';

        data = textscan(fid,string_count,'Delimiter',',');
        fclose(fid);

        for i = 2:length(data{2})
            price_points(i-1) = str2double(data{2}(i));
        end;

        cd(fullfile(home))


        %% Plot Price Forecast %%%%%%%%%%%%%%%
        plot(handles.Real_time_price_axes,price_points)
        set(handles.Real_time_price_axes,'Layer','top')
        colormap jet
        title(handles.Real_time_price_axes,'Electricity Price')
        ylabel(handles.Real_time_price_axes,'Electricity Price','Color','White')
        xlabel(handles.Real_time_price_axes,'5 Minute Intervals')
        set(handles.Real_time_price_axes,'xColor',[1 1 1])
        set(handles.Real_time_price_axes,'yColor',[1 1 1])
        set(handles.Real_time_price_axes,'Color',[0 0 0])
    catch
         set(handles.program_status,'String','Failed Plotting Price Forecast') 
    end;
    
    [filextention] = current_time();
    set(handles.program_status,'String',strcat('Plotting Optimization Results',filextention))
    pause(0.1)
    
    try
        % clear any status files in System Architecture Data
        cd(fullfile(home))
        cd(fullfile(home,'System Data','Optimized Results'))

        %% Load Optimization Results %%%%%%%%%%%%%%%
        %% ensure file is not in use
        setpointcontinue = 0;
        while setpointcontinue <100
            fid = fopen('Optimization Results.csv');
            if fid ==-1
                pause(0.05)
                setpointcontinue = setpointcontinue +1;
            else
                break
            end
        end
       %%

        string_count = '%s%s';
        for i = 1:288
            string_count = strcat(string_count,'%s');
        end;

        data = textscan(fid,string_count,'Delimiter',',');
        fclose(fid);

        cd(fullfile(home))

        counter_array = zeros(100,1);
        for i = 2:length(data{2})

            %% Pull data from row %%%%%%%%%%%%%%%%
            new_data = zeros(288,1);
            for k = 1:length(new_data)
                new_data(k) = str2double(data{2+k}(i));
            end;

            %% Define data to data types %%%%%%%%%%%%%%
            if strcmp(data{2}(i),'20')
                counter_array(20) = counter_array(20) + 1;
                battery_results(counter_array(20),:) = new_data;
            elseif strcmp(data{2}(i),'22')
                counter_array(22) = counter_array(22) + 1;
                SOC_results(counter_array(22),:) = new_data;
            else
            end;

        end;


        %% Plot Optimization Results %%%%%%%%%%%%%%%
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

        pause(5);
    catch
         set(handles.program_status,'String','Failed Plotting Energy Storage') 
    end;

end;

 set(handles.program_status,'String','Program Stopped') 
 
% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop
stop = 1;