function varargout = Matlab_EMS(varargin)
% MATLAB_EMS MATLAB code for Matlab_EMS.fig
%      MATLAB_EMS, by itself, creates a new MATLAB_EMS or raises the existing
%      singleton*.
%
%      H = MATLAB_EMS returns the handle to a new MATLAB_EMS or the handle to
%      the existing singleton*.
%
%      MATLAB_EMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLAB_EMS.M with the given input arguments.
%
%      MATLAB_EMS('Property','Value',...) creates a new MATLAB_EMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Matlab_EMS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Matlab_EMS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Matlab_EMS

% Last Modified by GUIDE v2.5 12-Apr-2016 11:29:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Matlab_EMS_OpeningFcn, ...
    'gui_OutputFcn',  @Matlab_EMS_OutputFcn, ...
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


% --- Executes just before Matlab_EMS is made visible.
function Matlab_EMS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Matlab_EMS (see VARARGIN)

% Choose default command line output for Matlab_EMS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Matlab_EMS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Matlab_EMS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% set global variables where information has to be continually shared.
% fclose(instrfind)

global home;
global system_status;
global SCADA_receive;
global SCADA_send;
global acknowledge_fault;


% system status states
system_status = 0;
home = cd;

%% add Functions, System_status to path to ensure that we do not always have
% to enter the folder to call the necessary data.

addpath(fullfile(home,'Functions'))
addpath(fullfile(home))

%% clears the icon for faults
set_indicator(handles.fault_icon,'','blank')

%% clear the information window and set status to initilization.
update_status(handles.program_status,home,'')

update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))

%% clear any status files in System Architecture Data
cd(fullfile(home))
cd(fullfile(home,'System Architecture Data'))

list_files = dir('*.txt');

for i = 1:length(list_files)
    delete(list_files(i).name)
end

%% Check folder for any emergency files.
cd(fullfile(home))
cd(fullfile(home,'Emergency Cache'))
list_files = dir('*.txt');

%% main loop
infinite_run = 1
while infinite_run == 1
    
    %% reinitializes system status to zero
    cd(fullfile(home))
    system_status = 0;
    acknowledge_fault = 0;
    
    %%  checks emergency cache
    if length(list_files) > 0
        set_indicator(handles.fault_icon,'Warning','orange')
        update_status(handles.program_status,home,'Emergency Cache has files')
    else
        set_indicator(handles.fault_icon,'Ok','green')
        set_indicator(handles.operation_mode,'Stand-by','green')
        update_status(handles.program_status,home,'System Ready')
    end;
    
    %% puts a holding pattern while in system_status = 0;
    % awaiting start button.
    while system_status == 0
        pause(.1)
    end;
    
    %% determines if exits is pressed
    if system_status == 9
        infinite_run = 2;
    %% continues with start button press    
    elseif system_status == 1 || system_status == 4
        set_indicator(handles.operation_mode,'Start up','red')
        
        try
            %% STARTUP mode
            startup_sequence(handles)
        catch Me
            create_error_notification(home,Me.message,'startup sequence.txt');
        end;
        
        try
            %% system status: -1 - error detected 
            if system_status == -1;
                update_status(handles.program_status,home,'Failed Initiation... Retry Startup')
                set_indicator(handles.fault_icon,'Stop','orange')
             
            %% system status: 0 - returned to startup   
            elseif system_status == 0;
                update_status(handles.program_status,home,'Please Initiate Startup')
                set_indicator(handles.fault_icon,'Warning','orange')
            
            %% system status: 7 - shutdown   
            elseif system_status == 7;
                set_indicator(handles.fault_icon,'Shutdown','green')
                infinite_run = 0;
            
            %% system status: 1/4 - continue with startup       
            elseif system_status == 1 || system_status == 4

                try
                    %% activate under normal operations startup
                     if system_status == 1
                        update_status(handles.program_status,home,'Activating Devices')
                        set_indicator(handles.fault_icon,'Processing','yellow')
                        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
                        send_activation_request(handles)
                      
                    %% intiate blackstart 
                    elseif system_status == 4
						 system_status = 6;
                         blackstart(handles)
                    end;
                    
                catch Me
                    create_error_notification(home,Me.message,'Send Activation Request.txt');
                end
                
                try
                    %% START COMMS TO OPTIMIZATION
                    interconnect_EMS_comms(handles)
                catch Me
                    create_error_notification(home,Me.message,'Interconnect EMS Comms.txt');
                end
                
                % system status: -1 - error detected
                if system_status == -1;
                    update_status(handles.program_status,home,'Failed Device Activation... Retry Startup')
                    set_indicator(handles.fault_icon,'Stop','orange')
                else
                    %% main state loop  
                    infinite_loop = 0;
                    while infinite_loop == 0;
                        
                        % system status: 2 - on grid mode
                        if system_status == 2
                            set_indicator(handles.operation_mode,'On-grid','orange')
                            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
                            try
                                on_grid_mode(handles)
                                pause(1);
                            catch Me
                                create_error_notification(home,Me.message,'on grid mode.txt');
                            end;
                        % system status: 3 - transition to islanding mode
                        elseif system_status == 3
                            set_indicator(handles.operation_mode,'Trans. Off-grid','red')
                            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
                            transition_to_islanding_mode(handles)
                        
                        % system status: 4 - off grid mode
                        elseif system_status == 4
                            set_indicator(handles.operation_mode,'Off-grid','orange')
                            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
                            islanded_mode(handles)
                           
                        % system status: 5 - transition to grid
                        elseif system_status == 5
                            set_indicator(handles.operation_mode,'Trans. On-grid','red')
                            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
                            transition_to_grid_connected(handles)
                            
                        % system status: 7 - shutting down   
%                         elseif system_status == 7
%                             set_indicator(handles.operation_mode,'Shutting Down','red')
%                             update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
%                             shutdown(handles)
                            
                        % system status: 8 - unintentional island       
                        elseif system_status == 8
                            set_indicator(handles.operation_mode,'Unintentional Island','red')
                            update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
                            unintentional_island(handles)
                            
                        % system status: 9 - exit          
                        elseif system_status == 9
                            infinite_run = 2;
                            infinite_loop = 1;
                        end;
                        
                        % if error stop state loop
                        if system_status == -1
                            infinite_loop = 1;
                        end;
                    end;
                end;
                set_indicator(handles.operation_mode,'Stopped','green')
            end;
        catch Me
            create_error_notification(home,Me.message,'Main Conditional Error.txt');
        end;
        
        %% send close SCADA command
        close_SCADA(home,handles,SCADA_send,SCADA_receive)
        
        %% beep on error.
        while acknowledge_fault == 0;
            pause(.5)
            beep
        end;
        
        system_status = 0;
        update_status(handles.system_status,home,strcat('System Status:',num2str(system_status)))
    else
        system_status = 0;
    end;
end

rmpath(fullfile(home,'Functions'))
rmpath(fullfile(home))
close all;

% --- Executes on button press in start_up.
function start_up_Callback(hObject, eventdata, handles)
% hObject    handle to start_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global system_status;
global home;

try
    set_indicator(handles.fault_icon,'Processing','yellow')
    
    %% if in stop state allow start-up
    if system_status == 0
        system_status = 1;
        update_status(handles.program_status,home,'Performing Startup')
    else
    end;
    
catch Me
    create_error_notification(home,Me.message,'Islanding Error.txt');
end;

set_indicator(handles.fault_icon,'Ok','green')


% --- Executes on button press in island_system.
function island_system_Callback(hObject, eventdata, handles)
% hObject    handle to island_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global system_status;
global home;

try
    set_indicator(handles.fault_icon,'Processing','yellow')
    
    %% if in on-grid state allow trans_to_off grid
    if system_status == 2
        system_status = 3;
        update_status(handles.program_status,home,'Sending Islanding Command')
    elseif system_status == 4
        update_status(handles.program_status,home,'Already Islanded')
    else
    end;
    
catch Me
    create_error_notification(home,Me.message,'Islanding Error.txt');
end;

set_indicator(handles.fault_icon,'Ok','green')


% --- Executes on button press in sychronize_system.
function sychronize_system_Callback(hObject, eventdata, handles)
% hObject    handle to sychronize_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global system_status
global home;

try
    set_indicator(handles.fault_icon,'Processing','yellow')
    
    %% if inslanded transition into trans_to_ongrid
    if system_status == 4
        system_status = 5;
        update_status(handles.program_status,home,'Sending Sychronization Command')
    elseif system_status == 2
        update_status(handles.program_status,home,'Already Grid Connected')
    else
    end;
    
catch Me
    create_error_notification(home,Me.message,'Sychronization Error.txt');
end;

set_indicator(handles.fault_icon,'Ok','green')

% --- Executes on button press in power_factor.
function power_factor_Callback(hObject, eventdata, handles)
% hObject    handle to power_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of power_factor


% --- Executes on button press in fault_icon.
function fault_icon_Callback(hObject, eventdata, handles)
% hObject    handle to fault_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in testing_checkbox.
function testing_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to testing_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of testing_checkbox


% --- Executes on button press in shutdown_button.
function shutdown_button_Callback(hObject, eventdata, handles)
% hObject    handle to shutdown_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global system_status
global home;
global acknowledge_fault;

try
    update_status(handles.program_status,home,'Sending Shutdown Command')
    set_indicator(handles.fault_icon,'Processing','yellow')
    
    system_status = -1;
    acknowledge_fault = 1;
catch Me
    disp(Me.message)
end;
set_indicator(handles.fault_icon,'Ok','green')

% --- Executes on button press in blackstart_button.
function blackstart_button_Callback(hObject, eventdata, handles)
% hObject    handle to blackstart_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global system_status

system_status = 4;

function add_device_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_device_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of add_device_button as text
%        str2double(get(hObject,'String')) returns contents of add_device_button as a double



function remove_device_button_Callback(hObject, eventdata, handles)
% hObject    handle to remove_device_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of remove_device_button as text
%        str2double(get(hObject,'String')) returns contents of remove_device_button as a double


% --- Executes during object creation, after setting all properties.
function remove_device_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_device_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear_errors.
function clear_errors_Callback(hObject, eventdata, handles)
% hObject    handle to clear_errors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear any error files in System_Status

global system_status
%system_status = 0;

home = cd;

update_status(handles.program_status,home,'Clearing Errors')
set_indicator(handles.fault_icon,'Processing','yellow')

%% find all files in system_status and delete
cd(fullfile(home))
cd(fullfile(home,'System_Status'))

list_files = dir('*.txt');

for i = 1:length(list_files)
    delete(list_files(i).name)
end
cd(fullfile(home))

update_status(handles.program_status,home,'Clearing Errors Completed')
set_indicator(handles.fault_icon,'Ok','green')


% --- Executes on selection change in communication_listbox.
function communication_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to communication_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns communication_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from communication_listbox


% --- Executes during object creation, after setting all properties.
function communication_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to communication_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in operation_mode.
function operation_mode_Callback(hObject, eventdata, handles)
% hObject    handle to operation_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exit_program.
function exit_program_Callback(hObject, eventdata, handles)
% hObject    handle to exit_program (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global system_status
global home;
global SCADA_receive;
global SCADA_send;

try
    %% close SCADA connection
    set_indicator(handles.fault_icon,'Processing','yellow')
    close_SCADA(home,handles,SCADA_send,SCADA_receive)
    system_status = 9;
    update_status(handles.program_status,home,'Sending Shutdown Command')
    
    
    cd(fullfile(home))
    
    
catch Me
    create_error_notification(home,Me.message,'Exiting Error.txt');
end;


% --- Executes on button press in clear_emergency_Cache.
function clear_emergency_cache_Callback(hObject, eventdata, handles)
% hObject    handle to clear_emergency_cache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global system_status
global home;
system_status = 0;

%% delete all file in Emergency Cache
update_status(handles.program_status,home,'Clearing Emergency Cache')
set_indicator(handles.fault_icon,'Processing','yellow')

cd(fullfile(home))
cd(fullfile(home,'Emergency Cache'))

list_files = dir('*.txt');

for i = 1:length(list_files)
    delete(list_files(i).name)
end
cd(fullfile(home))

update_status(handles.program_status,home,'Clearing Emergency Cache Completed')
set_indicator(handles.fault_icon,'Ok','green')


% --- Executes on button press in system_costs.
function system_costs_Callback(hObject, eventdata, handles)
% hObject    handle to system_costs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of system_costs


% --- Executes on button press in demand_charge.
function demand_charge_Callback(hObject, eventdata, handles)
% hObject    handle to demand_charge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of demand_charge


% --- Executes on button press in loss_indicator.
function loss_indicator_Callback(hObject, eventdata, handles)
% hObject    handle to loss_indicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loss_indicator


% --- Executes on button press in voltage_indicator.
function voltage_indicator_Callback(hObject, eventdata, handles)
% hObject    handle to voltage_indicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of voltage_indicator


% --- Executes on button press in VPCC.
function VPCC_Callback(hObject, eventdata, handles)
% hObject    handle to VPCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VPCC


% --- Executes on button press in commitment_check.
function commitment_check_Callback(hObject, eventdata, handles)
% hObject    handle to commitment_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of commitment_check


% --- Executes on button press in acknowledge_error.
function acknowledge_error_Callback(hObject, eventdata, handles)
% hObject    handle to acknowledge_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global acknowledge_fault;
acknowledge_fault = 1;


% --- Executes on button press in clear_emergency_cache.
function clear_emergency_cache_Callback(hObject, eventdata, handles)
% hObject    handle to clear_emergency_cache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
