function device_startup(program_status, home, SCADA_send,SCADA_receive,fault_icon)

cd(fullfile(home,'System Architecture Data'))

device_names = importdata('Device_names_and_types.txt');

cd(fullfile(home))

for i = 1:length(device_names)
    send_request(program_status, home, SCADA_send,'Device_activate',device_names{i})
	[message, data] = receive_request(program_status, home, SCADA_receive)
    
    if strcmp('Device_activate_success',message{1}')
        update_status(program_status,home,strcat(device_names{i},'_Successfully started'))
        set_indicator(fault_icon,'Ok','green')
    elseif strcmp('Device_activate_failure',message{1}')
         update_status(program_status,home,strcat(device_names{i},'_Device_activate_failure'))
         create_error_notification(home,'Device_activate_failure','Device_activate_failure.txt');
         set_indicator(fault_icon,'Error','red')
    else
         update_status(program_status,home,strcat(device_names{i},'_Unknown Text'))
         create_error_notification(home,'Unknown Text','Unknown text.txt');
         set_indicator(fault_icon,'Error','red')
    end;
end;
