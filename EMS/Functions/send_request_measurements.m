function send_request_measurements(program_status, home, SCADA_receive,SCADA_send, IEDnames,measurement_names,relay_names,device_types)
%[] = send_request_measurements(program_status, home, SCADA_receive,SCADA_send, IEDnames,measurement_names,relay_names,device_types)
% send request for measurements to SCADA 

    %% SCADA message
    message = 'Measurement_get_multiple';
    message_bytes = length(message);
    message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');
 
    %% size of IED name
    for i = 1:length(IEDnames)
        if (device_types(i)  == 4 || device_types(i)  == 3 || device_types(i)  == 1)
            for k = 1:length(relay_names)
                if i == 1 && k == 1
                    IEDname_hold = IEDnames{i};
                    measurement_names_hold = relay_names{k};
                else
                    IEDname_hold = [IEDname_hold,',',IEDnames{i}]
                    measurement_names_hold = [measurement_names_hold,',',relay_names{k}]
                end;
            end;
        end;

        if device_types(i) == 2
            for k = 1:length(measurement_names)
                if i == 1 && k == 1
                    IEDname_hold = IEDnames{i}
                    measurement_names_hold = measurement_names{k}
                else
                    %%%%%%%%% SOC only for batteries %%%%%
                    IEDname_hold = [IEDname_hold,',',IEDnames{i}]
                    measurement_names_hold = [measurement_names_hold,',',measurement_names{k}]
               
                end;
            end;
        end;
    end;
      
    %% IED info        
    IED_bytes = length(IEDname_hold);
    IED_send = cast(typecast(cast(IED_bytes,'uint32'),'uint8'),'char');
    
    %%%% size of measurement name
    measurementname_bytes = length(measurement_names_hold);
    measurementname_send = cast(typecast(cast(measurementname_bytes,'uint32'),'uint8'),'char');

    % size of entire message(new_full_send)
    new_full_message = [message_send,message,IED_send,IEDname_hold,measurementname_send,measurement_names_hold];
    new_full_bytes = length(new_full_message);
    new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
    new_full_message_full = [new_full_send, new_full_message] ;

try
    fwrite(SCADA_send,new_full_message_full,'char');
    update_status(program_status,home,strcat('Message',message,'Sent'))
catch Me
    create_error_notification(home,Me.message,'get system measurement_send request measurements_fwrite.txt');
end;