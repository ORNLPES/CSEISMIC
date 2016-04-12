function varargout = Optimization_Results_Ongrid(varargin)
% OPTIMIZATION_RESULTS_ONGRID MATLAB code for Optimization_Results_Ongrid.fig
%      OPTIMIZATION_RESULTS_ONGRID, by itself, creates a new OPTIMIZATION_RESULTS_ONGRID or raises the existing
%      singleton*.
%
%      H = OPTIMIZATION_RESULTS_ONGRID returns the handle to a new OPTIMIZATION_RESULTS_ONGRID or the handle to
%      the existing singleton*.
%
%      OPTIMIZATION_RESULTS_ONGRID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIMIZATION_RESULTS_ONGRID.M with the given input arguments.
%
%      OPTIMIZATION_RESULTS_ONGRID('Property','Value',...) creates a new OPTIMIZATION_RESULTS_ONGRID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Optimization_Results_Ongrid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Optimization_Results_Ongrid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Optimization_Results_Ongrid

% Last Modified by GUIDE v2.5 29-Dec-2015 06:05:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Optimization_Results_Ongrid_OpeningFcn, ...
                   'gui_OutputFcn',  @Optimization_Results_Ongrid_OutputFcn, ...
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


% --- Executes just before Optimization_Results_Ongrid is made visible.
function Optimization_Results_Ongrid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Optimization_Results_Ongrid (see VARARGIN)

% Choose default command line output for Optimization_Results_Ongrid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Optimization_Results_Ongrid wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global home;
home = cd;

addpath(fullfile(home,'Functions'))
addpath(fullfile(home))

set(handles.program_status,'String',' ')

% --- Outputs from this function are returned to the command line.
function varargout = Optimization_Results_Ongrid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_optimization;
global ignore_results;
global home;
stop_optimization = 0;

message = 'Awaiting EMS';
update_status(handles.program_status,home,message)
 
connection = 0;
%% Setup Communications %%%%%%%%%%%%%%%%%
while connection == 0
    try
         EMS_receive = tcpip('localhost',4000,'NetworkRole','Client');
         EMS_receive.timeout = 5;
         EMS_receive.InputBufferSize = 10^4;
         fopen(EMS_receive);

         EMS_send = tcpip('localhost',4001,'NetworkRole','Client'); 
         EMS_send.timeout = 5;
         EMS_send.InputBufferSize = 10^4;
         fopen(EMS_send);
         
         connection = 1
    catch
        time = clock;
        set(handles.program_status,'String',strcat(...
            'Awaiting connection_',num2str(time(5)),'_',num2str(time(6))))
        pause(0.1) 
    end;
end;

%% Start Optimization %%%%%%%%%%%%%%%%%
start_optimization = 0;
while start_optimization == 0;
    try
       receive_request_start_optimization(handles.program_status, home, EMS_receive);
       start_optimization = 1;
    catch
        time = clock;
        set(handles.program_status,'String',strcat(...
            'Awaiting start_',num2str(time(5)),'_',num2str(time(6))));
        pause(0.1)  
    end;
end;


%% Run Optimization %%%%%%%%%%%%%%%%%
message = 'Connected to EMS';
update_status(handles.program_status,home,message)
pause(3)

stop_optimization = 0;
while stop_optimization == 0
   %% continually run optimization
   try
        time = clock;
        set(handles.program_status,'String',strcat(...
            'Running Optimization_',num2str(time(5)),'_',num2str(time(6))));
        pause(0.1)  
       ignore_results = 0; 
       run_optimization_grid_connected(handles)

   catch Me
       display(Me.message)
       stop_optimization = 1
       %set(handles.program_status,'String','Optimization Stopped')
   end
   
end;
  
cd(fullfile(home))
set(handles.program_status,'String','Optimization Stopped')
pause(.1)
display('Optimization Stop')


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_optimization
display('User Command Stop')
stop_optimization = 1


% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_optimization
if stop_optimization == 1
    close all;
else
    disp('Please Stop First')
end;
