function varargout = Emergency_Monitoring(varargin)
% EMERGENCY_MONITORING MATLAB code for Emergency_Monitoring.fig
%      EMERGENCY_MONITORING, by itself, creates a new EMERGENCY_MONITORING or raises the existing
%      singleton*.
%
%      H = EMERGENCY_MONITORING returns the handle to a new EMERGENCY_MONITORING or the handle to
%      the existing singleton*.
%
%      EMERGENCY_MONITORING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMERGENCY_MONITORING.M with the given input arguments.
%
%      EMERGENCY_MONITORING('Property','Value',...) creates a new EMERGENCY_MONITORING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Emergency_Monitoring_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Emergency_Monitoring_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Emergency_Monitoring

% Last Modified by GUIDE v2.5 18-Nov-2015 13:47:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Emergency_Monitoring_OpeningFcn, ...
                   'gui_OutputFcn',  @Emergency_Monitoring_OutputFcn, ...
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


% --- Executes just before Emergency_Monitoring is made visible.
function Emergency_Monitoring_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Emergency_Monitoring (see VARARGIN)

% Choose default command line output for Emergency_Monitoring
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Emergency_Monitoring wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% intitialize system files


% --- Outputs from this function are returned to the command line.
function varargout = Emergency_Monitoring_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global home
global SCADA_emergency
global system_status
global stop_variable

system_status = 1;
home = cd;

% system status = 1/awaiting start button
% system status = 2/interconnecting comms 
% system status = 3/monitoring emergency channel
% system status = 4/stopping and transition to 1

set(handles.program_status,'String','')
addpath(fullfile(home,'Functions'))
addpath(fullfile(home))

cd(fullfile(home,'Emergency Cache'))
list_files = dir('*.txt');

for i = 1:length(list_files)
    delete(list_files(i).name)
end
cd(fullfile(home))


warning('off')

%% clear emergency files
cd(fullfile(home,'Emergency Cache'))
list_files = dir('*.txt');

for i = 1:length(list_files)
    delete(list_files(i).name)
end
cd(fullfile(home))


run_loop = 0;
while run_loop == 0
    %% put in waiting state for connection to SCADA
    if system_status == 1
        time = clock;
        set(handles.program_status,'String',strcat('Awaiting User',num2str(time(4)),'_',...
            num2str(time(5)),'_',num2str(time(6))))
        pause(0.01)
     
    %% user notification of SCADA connection
    elseif system_status == 2
        set(handles.program_status,'String','Starting')
        pause(0.01)
        try 
            %% opens connections to SCADA
             if get(handles.testing_mode,'Value') == 1
                 SCADA_emergency = tcpip('localhost',4014,'NetworkRole','Server'); 
                 fopen(SCADA_emergency);
                 SCADA_emergency.timeout = 5;
             else
                 SCADA_emergency = tcpip('localhost',4014,'NetworkRole','Client'); 
                 fopen(SCADA_emergency);
                 SCADA_emergency.timeout = 5;
             end;
            set(handles.program_status,'String','Connection Successful')
            % move to continual monitoring of messages from SCADA
            system_status = 3;
        catch Me
           set(handles.program_status,'String',strcat('Failed:',Me.message))
           pause(1)
           system_status = 1;
        end;
    
    %% continual monitoring of SCADA for broadcast
    elseif system_status == 3
        stop_variable = 0
        while stop_variable == 0
            try 
                [do_not_stop] = receive_request_emergency(handles.program_status, home, SCADA_emergency);   
                if do_not_stop == 0
                    set(handles.program_status,'String','Islanded Transmission Received')
                    pause(0.1)
                elseif do_not_stop == 2
                    set(handles.program_status,'String','Emergency Transmission Received')
                    stop_variable = 1;
                    system_status = 4;
                    pause(0.1)
                else
                    time = clock;
                    set(handles.program_status,'String',strcat('Ready_',num2str(time(4)),'_',...
                        num2str(time(5)),'_',num2str(time(6))))
                    pause(0.1)
                end;
            catch Me
                create_error_notification(home,Me.message,'emergency monitoring request.txt');
                stop_variable = 1;
                system_status = 4;
            end;
        end;
    
    %% closing of Emergency Monitoring based on Exit button
    elseif system_status == 4
         fclose(SCADA_emergency);
         set(handles.program_status,'String','Sending Shutdown Request') 
         pause(0.001)
         system_status = 1;
    elseif system_status == 5
        run_loop = 1;
    end;
    
end;
cd(fullfile(home))
close all;


% --- Executes on button press in emergency_monitoring.
function emergency_monitoring_Callback(hObject, eventdata, handles)
% hObject    handle to emergency_monitoring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global home;
global system_status
system_status = 2;

% --- Executes on button press in testing_mode.
function testing_mode_Callback(hObject, eventdata, handles)
% hObject    handle to testing_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of testing_mode


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global system_status;
global stop_variable;
stop_variable = 1;
system_status = 4;


% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global system_status
system_status = 5;
