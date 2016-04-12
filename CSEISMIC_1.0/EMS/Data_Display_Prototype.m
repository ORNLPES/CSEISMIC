function varargout = Data_Display_Prototype(varargin)
% DATA_DISPLAY_PROTOTYPE MATLAB code for Data_Display_Prototype.fig
%      DATA_DISPLAY_PROTOTYPE, by itself, creates a new DATA_DISPLAY_PROTOTYPE or raises the existing
%      singleton*.
%
%      H = DATA_DISPLAY_PROTOTYPE returns the handle to a new DATA_DISPLAY_PROTOTYPE or the handle to
%      the existing singleton*.
%
%      DATA_DISPLAY_PROTOTYPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_DISPLAY_PROTOTYPE.M with the given input arguments.
%
%      DATA_DISPLAY_PROTOTYPE('Property','Value',...) creates a new DATA_DISPLAY_PROTOTYPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_Display_Prototype_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_Display_Prototype_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_Display_Prototype

% Last Modified by GUIDE v2.5 11-Dec-2015 09:46:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_Display_Prototype_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_Display_Prototype_OutputFcn, ...
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


% --- Executes just before Data_Display_Prototype is made visible.
function Data_Display_Prototype_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Data_Display_Prototype (see VARARGIN)

% Choose default command line output for Data_Display_Prototype
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Data_Display_Prototype wait for user response (see UIRESUME)
% uiwait(handles.figure1);

home = cd;
global home;
global stop_status;

addpath(fullfile(home,'Functions'))
addpath(fullfile(home))

update_status(handles.program_status,home,'Initiating Display')

cd(fullfile(home,'Images'))

size_image = .07

% Position [left bottom width height]

%% Full Background 

background_image = axes('Parent',handles.output,'Position',[0 0 1 1])

graphic_information = imread('DECC_Satellite_Image.PNG');
image(graphic_information,'Parent',background_image)
set(gca,'xtick',[],'ytick',[])

cd(fullfile(home))

 
% --- Outputs from this function are returned to the command line.
function varargout = Data_Display_Prototype_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in quit_button.
function quit_button_Callback(hObject, eventdata, handles)
% hObject    handle to quit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global stop_status;
global quit_status;
if stop_status == 1
    close all;
end

quit_status = 1;


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global home;
global display_status;
global stop_status;
global quit_status;
display_status = 0;
quit_status = 0;


cd(fullfile(home,'Images'))

size_image = .07

%%Lines
%% Grid to Bus 1
line([240,240],[450 600],'LineWidth',7,'Color',[0 0 0])

%% Bus 1
line([190,290],[600 600],'LineWidth',15,'Color',[0 0 0])

%% PV 1 to Bus 1
    % Horizontal
line([120, 205], [672 672],'LineWidth',7,'Color',[0 0 0])
    % Vertical
line([202, 202], [600 674],'LineWidth',7,'Color',[0 0 0])

%% Energy Storage 1 to Bus 1
    % Horizontal
line([120, 220], [825 825],'LineWidth',7,'Color',[0 0 0])
	% Vertical
line([218, 218], [600 827],'LineWidth',7,'Color',[0 0 0])

%% Load 1 to Bus 1
    % Horizontal
line([250, 320], [825 825],'LineWidth',7,'Color',[0 0 0])
	% Vertical
line([252, 252], [600 827],'LineWidth',7,'Color',[0 0 0])

%% Bus 1 to Bus 2
    % Vertical Right side
line([1695, 1695], [260 604],'LineWidth',7,'Color',[0 0 0])
    % Horizontal
line([230, 1698], [600 600],'LineWidth',7,'Color',[0 0 0])

%% Bus 2
line([1645,1740],[260 260],'LineWidth',15,'Color',[0 0 0])

%% Load 2 to Bus 2
    % Horizontal
line([1640, 1680], [220 220],'LineWidth',7,'Color',[0 0 0])
    % Vertical
line([1675, 1675], [218 260],'LineWidth',7,'Color',[0 0 0])

%% Energy Storage 2 to Bus 2
    % Horizontal
line([1706, 1740], [220 220],'LineWidth',7,'Color',[0 0 0])
	% Vertical
line([1710, 1710], [218 260],'LineWidth',7,'Color',[0 0 0])

%% GRID CONNECTION

%% PCC
axes1 = axes('Parent',handles.output,'Position',[.092 .48 size_image size_image])
box(axes1,'on')
graphic_information = imread('Grid.jpg');
image(graphic_information,'Parent',axes1)
set(gca,'xtick',[],'ytick',[])

%% Microgrid Switch
microgrid_switch_locations(1,:) = [190 400 90 50];
microgrid_switch(1) = uicontrol(handles.output,'Style','pushbutton','String','Microgrid Switch',...
    'Position',microgrid_switch_locations(1,:),'Background','green');


%% Relay2
relay_locations(1,:) = [1540 770 90 50];
relay(1) = uicontrol(handles.output,'Style','pushbutton','String','Relay 2',...
    'Position',relay_locations(1,:),'Background','green');

%% Relay1
relay_locations(2,:) = [300 90 90 50];
relay(2) = uicontrol(handles.output,'Style','pushbutton','String','Relay 1',...
    'Position',relay_locations(2,:),'Background','green');


%% PV
PV_locations(1,:) = [35 260 90 50];
PV(1) = uicontrol(handles.output,'Style','pushbutton','String','PV 1',...
    'Position',PV_locations(1,:),'Background','green');


%% Generator
energystorage_locations(1,:) = [1720 770 90 50];
energy_storage(1) = uicontrol(handles.output,'Style','pushbutton','String','Energy Storage 1',...
    'Position',energystorage_locations(1,:),'Background','green');

%% Energy Storage
generator_locations(1,:) = [35 90 90 50];
generator(1) = uicontrol(handles.output,'Style','pushbutton','String','Generator',...
    'Position',generator_locations(1,:),'Background','green');

%% Load

systemload_locations(1,:) = [1540 720 90 50];
System_Load(1) = uicontrol(handles.output,'Style','pushbutton','String','Load 2',...
    'Position',systemload_locations(1,:),'Background','red');

systemload_locations(2,:) = [300 40 90 50];
System_Load(2) = uicontrol(handles.output,'Style','pushbutton','String','Load 1',...
    'Position',systemload_locations(2,:),'Background','red');

%% System text

%% Load 2
load_datatext(1)  = uicontrol(handles.output,'Style','text','String',' ',...
    'Position',[1510 835 150 100],'Background','black','ForegroundColor','white');
throw_away  = uicontrol(handles.output,'Style','text','String','LOAD',...
    'Position',[1510 935 150 15],'Background','red','ForegroundColor','white');

%% Load 1
load_datatext(2)  = uicontrol(handles.output,'Style','text','String',' ',...
    'Position',[275 140 150 100],'Background','black','ForegroundColor','white');
throw_away  = uicontrol(handles.output,'Style','text','String','LOAD',...
    'Position',[275 240 150 15],'Background','red','ForegroundColor','white');

%% Energy Storage 2
es_datatext(1)  = uicontrol(handles.output,'Style','text','String','',...
    'Position',[1680 835 150 100],'Background','black','ForegroundColor','white');
throw_away  = uicontrol(handles.output,'Style','text','String','ES',...
    'Position',[1680 935 150 15],'Background','blue','ForegroundColor','white');

%% Generator 1
gen_datatext(2)  = uicontrol(handles.output,'Style','text','String','',...
    'Position',[10 140 150 100],'Background','black','ForegroundColor','white');
throw_away  = uicontrol(handles.output,'Style','text','String','GEN',...
    'Position',[10 240 150 15],'Background','blue','ForegroundColor','white');

%% PV 1
pv_datatext(1)  = uicontrol(handles.output,'Style','text','String','',...
    'Position',[10 310 150 100],'Background','black','ForegroundColor','white');
throw_away  = uicontrol(handles.output,'Style','text','String','PV',...
    'Position',[10 410 150 15],'Background','blue','ForegroundColor','white');
%% Grid
pcc_datatext(1) = uicontrol(handles.output,'Style','text','String',' ',...
    'Position',[300 390 150 100],'Background','black','ForegroundColor','white');
throw_away  = uicontrol(handles.output,'Style','text','String','GRID',...
    'Position',[300 490 150 15],'Background','blue','ForegroundColor','white');

update_status(handles.program_status,home,'Connecting Comms')

%% connecting to tcpip for data

connection_made = 0;
stop_status = 0
while connection_made == 0;
    try
        
        if stop_status == 1
            connection_made = 1;
        end;
        if quit_status == 1
            close all;
        end;
        
        if get(handles.test_mode,'Value')
             SCADA_receive = tcpip('localhost',4016,'NetworkRole','Client'); 
             SCADA_receive.OutputBufferSize = 10^4;
             SCADA_receive.InputBufferSize = 10^4;
             fopen(SCADA_receive);
             SCADA_receive.timeout = 10; 
             update_status(handles.program_status,home,'Connection Made')
             connection_made = 1;
             pause(0.1)
        else
            SCADA_receive = tcpip('localhost',4016,'NetworkRole','Client');
            SCADA_receive.OutputBufferSize = 10^4;
            SCADA_receive.InputBufferSize = 10^4;
            fopen(SCADA_receive);
            SCADA_receive.timeout = 10;
            connection_made = 1;
            update_status(handles.program_status,home,'Connection Made')
            pause(0.1)
        end;
        

        
    catch Me
        update_status(handles.program_status,home,'Connection Failed..')
        update_status(handles.program_status,home,'Trying Again..')
        pause(.1);
    end
end;

cd(fullfile(home))
 
   while stop_status == 0
       
        if quit_status == 1
            close all;
        end;
        
        try
            %% pull data
             [IEDname,Measurementname,measurement_actual] = receive_request_fullmeasurements_display(handles.program_status, home, SCADA_receive);
             update_status(handles.program_status,home,'Data Retrieved..')
        catch Me
             update_status(handles.program_status,home,'Data Retrieval Fail..')
             update_status(handles.program_status,home, Me.message)
             pause(.1)
             update_status(handles.program_status,home,'Trying Again..')
        end;

        try
            [IEDname_array] = strsplit(IEDname{1}',',');
            [Measurementname_array] = strsplit(Measurementname{1}',',');
        catch
        end;

        try

    %         ES_display = '';
    %         Mainswitch_display = '';
    %         Relay_display = '';

            ES_measurements = zeros(5,3);
            GEN_measurements = zeros(5,3);
            PV1_measurements = zeros(5,3);
            counter = zeros(1,5)
            for i = 1:length(IEDname_array)
                if strcmp(IEDname_array{i},'GEN1')
                    counter(1) = counter(1) + 1;
                    GEN_measurements(counter(1)) = measurement_actual(i);
                end;
                if strcmp(IEDname_array{i},'ES2')
                    counter(2) = counter(2) + 1;
                    ES_measurements(counter(2)) = measurement_actual(i);
                end;
                if strcmp(IEDname_array{i},'Mainswitch')
                    counter(3) = counter(3) + 1;
                    Mainswitch_measurements(counter(3)) = measurement_actual(i);
                end;

                if strcmp(IEDname_array{i},'R1')
                    counter(4) = counter(4) + 1;
                    Relay1_measurements(counter(4)) = measurement_actual(i);
                end;
                if strcmp(IEDname_array{i},'PV1')
                    counter(5) = counter(5) + 1;
                    PV1_measurements(counter(5)) = measurement_actual(i);
                end;
            end;

            % current checks for determination of 
            ES_current = mean(ES_measurements(1:3))
            Mainswitch_current = mean(Mainswitch_measurements(1:3))
            Relay_current = mean(Relay1_measurements(1:3))
            PV_current = mean(PV1_measurements(1:3))
            GEN_current = mean(GEN_measurements(1:3))

            if abs(ES_current) < 1
                set(energy_storage(1),'Background','green');
            else
                set(energy_storage(1),'Background','red');
            end;

            if abs(GEN_current) < 1
                set(generator(1),'Background','green');
            else
                set(generator(1),'Background','red');
            end;

            if Mainswitch_current < 1
                set(microgrid_switch(1),'Background','green');
            else
                set(microgrid_switch(1),'Background','red');
            end;

            if Relay_current < 1
                set(relay(1),'Background','green');
            else
                set(relay(1),'Background','red');
            end;


            if PV_current < 1
                set(PV(1),'Background','green');
            else
                set(PV(1),'Background','red');
            end;

            ES_voltage = mean(ES_measurements(4:6));
            ES_realpower = sum(ES_measurements(7:9));
            ES_reactivepower = sum(ES_measurements(10:12));
            ES_SOC = ES_measurements(13);

            Mainswitch_voltage = mean(Mainswitch_measurements(4:6));
            Mainswitch_realpower = sum(Mainswitch_measurements(7:9));
            Mainswitch_reactivepower = sum(Mainswitch_measurements(10:12));

            Relay1_voltage = mean(Relay1_measurements(4:6));
            Relay1_realpower = sum(Relay1_measurements(7:9));
            Relay1_reactivepower = sum(Relay1_measurements(10:12));

            PV1_voltage = mean(PV1_measurements(4:6));
            PV1_realpower = sum(PV1_measurements(7:9));
            PV1_reactivepower = sum(PV1_measurements(10:12));
            
            GEN_voltage = mean(GEN_measurements(4:6));
            GEN_realpower = sum(GEN_measurements(7:9));
            GEN_reactivepower = sum(GEN_measurements(10:12));

            %% conversion to display data
            ES_display = strcat('Voltage',32,32,32,num2str(ES_measurements(4),'%0.2f'),'/',...
            num2str(ES_measurements(5),'%0.2f'),'/',num2str(ES_measurements(6),'%0.2f'),10,...
            'Real Power',32,32,32,num2str(ES_measurements(7),'%0.2f'),'/',...
            num2str(ES_measurements(8),'%0.2f'),'/',num2str(ES_measurements(9),'%0.2f'),10,...        
            'Reactive Power',32,32,32,num2str(ES_measurements(10),'%0.2f'),'/',...
            num2str(ES_measurements(10),'%0.2f'),'/',num2str(ES_measurements(10),'%0.2f'),10,...
            'Current',32,32,32,num2str(ES_measurements(1),'%0.2f'),'/',...
            num2str(ES_measurements(2),'%0.2f'),'/',num2str(ES_measurements(3),'%0.2f'),10,...
            'SOC',32,32,32,num2str(ES_SOC,'%0.2f'))
            

            Mainswitch_display = strcat('Voltage',32,32,32,num2str(Mainswitch_measurements(4),'%0.2f'),'/',...
            num2str(Mainswitch_measurements(5),'%0.2f'),'/',num2str(Mainswitch_measurements(6),'%0.2f'),10,...
            'Real Power',32,32,32,num2str(Mainswitch_measurements(7),'%0.2f'),'/',...
            num2str(Mainswitch_measurements(8),'%0.2f'),'/',num2str(Mainswitch_measurements(9),'%0.2f'),10,...        
            'Reactive Power',32,32,32,num2str(Mainswitch_measurements(10),'%0.2f'),'/',...
            num2str(Mainswitch_measurements(10),'%0.2f'),'/',num2str(Mainswitch_measurements(10),'%0.2f'),10,...
            'Current',32,32,32,num2str(Mainswitch_measurements(1),'%0.2f'),'/',...
            num2str(Mainswitch_measurements(2),'%0.2f'),'/',num2str(Mainswitch_measurements(3),'%0.2f'))

            Relay_display = strcat('Voltage',32,32,32,num2str(Relay1_measurements(4),'%0.2f'),'/',...
            num2str(Relay1_measurements(5),'%0.2f'),'/',num2str(Relay1_measurements(6),'%0.2f'),10,...
            'Real Power',32,32,32,num2str(Relay1_measurements(7),'%0.2f'),'/',...
            num2str(Relay1_measurements(8),'%0.2f'),'/',num2str(Relay1_measurements(9),'%0.2f'),10,...        
            'Reactive Power',32,32,32,num2str(Relay1_measurements(10),'%0.2f'),'/',...
            num2str(Relay1_measurements(10),'%0.2f'),'/',num2str(Relay1_measurements(10),'%0.2f'),10,...
            'Current',32,32,32,num2str(Relay1_measurements(1),'%0.2f'),'/',...
            num2str(Relay1_measurements(2),'%0.2f'),'/',num2str(Relay1_measurements(3),'%0.2f'))

            PV_display = strcat('Voltage',32,32,32,num2str(PV1_measurements(4),'%0.2f'),'/',...
            num2str(PV1_measurements(5),'%0.2f'),'/',num2str(PV1_measurements(6),'%0.2f'),10,...
            'Real Power',32,32,32,num2str(PV1_measurements(7),'%0.2f'),'/',...
            num2str(PV1_measurements(8),'%0.2f'),'/',num2str(PV1_measurements(9),'%0.2f'),10,...        
            'Reactive Power',32,32,32,num2str(PV1_measurements(10),'%0.2f'),'/',...
            num2str(PV1_measurements(10),'%0.2f'),'/',num2str(PV1_measurements(10),'%0.2f'),10,...
            'Current',32,32,32,num2str(PV1_measurements(1),'%0.2f'),'/',...
            num2str(PV1_measurements(2),'%0.2f'),'/',num2str(PV1_measurements(3),'%0.2f'))

            Gen_display = strcat('Voltage',32,32,32,num2str(GEN_measurements(4),'%0.2f'),'/',...
            num2str(GEN_measurements(5),'%0.2f'),'/',num2str(GEN_measurements(6),'%0.2f'),10,...
            'Real Power',32,32,32,num2str(GEN_measurements(7),'%0.2f'),'/',...
            num2str(GEN_measurements(8),'%0.2f'),'/',num2str(GEN_measurements(9),'%0.2f'),10,...        
            'Reactive Power',32,32,32,num2str(GEN_measurements(10),'%0.2f'),'/',...
            num2str(GEN_measurements(10),'%0.2f'),'/',num2str(GEN_measurements(10),'%0.2f'),10,...
            'Current',32,32,32,num2str(GEN_measurements(1),'%0.2f'),'/',...
            num2str(GEN_measurements(2),'%0.2f'),'/',num2str(GEN_measurements(3),'%0.2f'))

            set(es_datatext(1),'String',ES_display,'HorizontalAlignment','left')
            set(pcc_datatext(1),'String',Mainswitch_display,'HorizontalAlignment','left')
            set(load_datatext(1),'String',Relay_display,'HorizontalAlignment','left')
            set(pv_datatext(1),'String',PV_display,'HorizontalAlignment','left')
            set(gen_datatext(1),'String',Gen_display,'HorizontalAlignment','left')
        catch Me

        end;

    end;
   
    fclose(SCADA_receive)
    update_status(handles.program_status,home,'Display Stopped..')


% --- Executes on button press in test_mode.
function test_mode_Callback(hObject, eventdata, handles)
% hObject    handle to test_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of test_mode


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_status;
stop_status = 1;
