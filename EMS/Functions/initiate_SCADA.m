function [SCADA_send,SCADA_receive] = initiate_SCADA(program_status,home,testing_checkbox)
% [SCADA_send,SCADA_receive] = initiate_SCADA(program_status,home,testing_checkbox)
% initiate connection to SCADA on local host.

try 
     %% SCADA connections
     SCADA_send = tcpip('localhost',4013,'NetworkRole','Client'); 
     SCADA_send.OutputBufferSize = 10^4;
     SCADA_send.InputBufferSize = 10^4;
     SCADA_send.timeout = 10;
     fopen(SCADA_send);

     SCADA_receive = tcpip('localhost',4012,'NetworkRole','Client'); 
     SCADA_receive.OutputBufferSize = 10^4;
     SCADA_receive.InputBufferSize = 10^4;
     SCADA_receive.timeout = 10;
     fopen(SCADA_receive);

catch Me
    create_error_notification(home,Me.message,'Initiating Interconnection to SCADA_Comm Setup.txt');    
end


%% MODBUS FILES
try 
    % go to location of modbus files
    cd(fullfile(home))
    cd(fullfile(home,'System Architecture Data','Communications'))
    
    % access files in .ini folder
    file_list = dir('*.ini');

    update_status(program_status,home,strcat('Modbus Files found:',num2str(length(file_list))))
    
    store_file_names_modbus = [];
    %% go through and send files %%%%%%%%%%%%%%%%
    try
        for i = 1:length(file_list)
            %%%% if file_list is not a structure with length because only one file
            %%%% was found in the directory

            if length(file_list) == 1
                % extract file name
                store_file_names_modbus{i} = file_list.name;
                send_file(program_status, home,SCADA_receive,SCADA_send,store_file_names_modbus{i})

                %%%%% if file_list has many files.
            else
                store_file_names_modbus{i} = file_list(i).name;
                send_file(program_status, home,SCADA_receive,SCADA_send,store_file_names_modbus{i})

            end;
        end;
    catch Me
        create_error_notification(home,Me.message,'Initiating Interconnection to SCADA_Modbus file send.txt');    
    end;
catch Me
     create_error_notification(home,Me.message,'Initiating Interconnection to SCADA_Modbus file.txt');    
end;


%% identify locally all of the files and names %%%%%%
try 
    cd(fullfile(home))
    cd(fullfile(home,'System Architecture Data'))
    
    fid = fopen('Modbus_File_names_located.txt','w')
    for i = 1:length(store_file_names_modbus)
        fprintf(fid,'%s\n',store_file_names_modbus{i});   
    end;
    fclose(fid)
catch Me
    create_error_notification(home,Me.message,'Initiating Interconnection to SCADA_System Architecture File.txt');    
end

%% if no files are found throw an error  %%%%%%
try
    if length(file_list) < 1
        message = 'No Modbus files found/function initiate_SCADA';
        update_status(handles.program_status,home,message)
        create_error_notification(home,message,'CID_error.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
catch
    update_status(handles.program_status,home,'Communication failure')
    create_error_notification(home,'Communication failure','Communication failure.txt'); 
    set_indicator(handles.fault_icon,'Error','red')
end;

cd(fullfile(home))
