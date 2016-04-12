function send_activation_request(handles)
%[] = send_activation_request(handles)
% sends SCADA an activation command for the devices.

global home;
global system_status;
global SCADA_send;
global SCADA_receive;

if system_status == 1
    try
       %% load generator device list
       cd(fullfile(home,'System Architecture Data'))
       generators = importdata('generator_device_list.txt');
       energy_storage = importdata('ES_device_list.txt');
    catch Me
         create_error_notification(home,Me.message,'Send Activation Request_loading files.txt');
    end
end;
 
if system_status == 1
    try 
        cd(fullfile(home,'System Data','Setpoints'))
		%% Ensure file not open
		setpointcontinue =0;
		while setpointcontinue <100
			fid = fopen('Setpoints.txt','w')
			if fid ==-1
				pause(0.05)
				setpointcontinue = setpointcontinue +1;
			else
				break
			end
		end
		%%
		
		for i = 1:length(generators)
            fprintf(fid,'%s,Real,%f\n',generators{i},0)
            fprintf(fid,'%s,Reactive,%f\n',generators{i},0)
            fprintf(fid,'%s,Voltage,%f\n',generators{i},480)
            fprintf(fid,'%s,Frequency,%f\n',generators{i},60)
        end;
        for i = 1:length(energy_storage)
            fprintf(fid,'%s,Real,%f\n',energy_storage{i},0)
            fprintf(fid,'%s,Reactive,%f\n',energy_storage{i},0)
            fprintf(fid,'%s,Voltage,%f\n',energy_storage{i},480)
            fprintf(fid,'%s,Frequency,%f\n',energy_storage{i},60) 
        end;
    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_save setpoints file.txt');
    end
end

%% load setpoints
if system_status == 1
    try
        cd(fullfile(home,'System Data','Setpoints'))
        optimization_setpoints = importdata('Setpoints.txt');
    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_opening file.txt');
    end
end;
 
%% pulling ID names and setpoints
if system_status == 1
    try
        optimization_info = optimization_setpoints.textdata
        IEDnames = optimization_info(:,1);
        setpointnames = optimization_info(:,2);
        setpoints = optimization_setpoints.data;

    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_parsing data.txt');
    end
end;

%% Sending all setpoints to SCADA
if system_status == 1
    try
        send_request_setpoints(handles.program_status, home, SCADA_receive,SCADA_send, IEDnames,setpointnames,setpoints)
    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_sending request.txt');
    end;
end;

%% Getting response from SCADA as to whether setpoints were set successfully
if system_status == 1
    try
        [IEDname,setpointname] = receive_request_fullsetpoints(handles.program_status, home, SCADA_receive)
    catch Me
            create_error_notification(home,Me.message,'Send Activation Request_getting confirmation.txt');
    end;    
end;

%% Crafting Activate Message for SCADA
if system_status == 1
    try
        message = 'Activate';
        message_bytes = length(message);
        message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');

        % size of entire message(new_full_send)
        new_full_message = [message_send,message];
        new_full_bytes = length(new_full_message);
        new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
        new_full_message_full = [new_full_send, new_full_message] ;

    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_message bundle.txt');
    end
end;

%% Sending Activate message to SCADA
if system_status == 1
    try 
        fwrite(SCADA_send,new_full_message_full,'char');
        update_status(handles.program_status,home,strcat('Message',message,'Sent'))
        set_indicator(handles.fault_icon,'Ok','green')

    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_fwrite.txt');
        set_indicator(handles.fault_icon,'Error','red')       
    end
end;

%% Reading response from SCADA after sending Activate message.
if system_status == 1
    try

        set_indicator(handles.fault_icon,'Processing','yellow') 
         SCADA_receive.timeout = 100;
        % only read size of entire message
        datalength = fread(SCADA_receive,4,'char');
        [message_length] = unbundle_fullmessage(datalength)
        SCADA_receive.timeout = 10;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % read rest of message
        data_information = fread(SCADA_receive,message_length,'char');

        [newstring, message] = stringU8_unbundle(data_information)

    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_fread.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end;
end;

%% Process return message from SCADA after Activate message.
if system_status == 1
    try
         % confirm message as expected.
         if strcmp(message{1}','Activate_success')
            update_status(handles.program_status,home,'File Message Received')
            set_indicator(handles.fault_icon,'Ok','green')
         else
            create_error_notification(home,strcat('Bad message received from SCADA:',message{1}'),'Send Activation Request_unknown command.txt');
            set_indicator(handles.fault_icon,'Error','red')
         end;
    catch Me
        create_error_notification(home,Me.message,'Send Activation Request_unbundle message.txt');
        set_indicator(handles.fault_icon,'Error','red')
    end
end;

%% move status to on-grid
if system_status == 1
    system_status = 2;
end;

