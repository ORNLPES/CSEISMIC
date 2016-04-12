function send_request_setpoints_trans_island(program_status, home, SCADA_receive,SCADA_send, IEDnames,setpointnames,setpoints)
% [] =  send_request_setpoints_trans_island(program_status, home, SCADA_receive,SCADA_send, IEDnames,setpointnames,setpoints)
% sends setpoints to SCADA for controllabe devices

%% SCADA message
message = 'Setpoint_multiple_set';

message_bytes = length(message);
message_send = cast(typecast(cast(message_bytes,'uint8'),'uint8'),'char');
  
%%%% size of IED name
for i = 1:length(IEDnames)
         if i == 1 
            IEDname_hold = IEDnames{i};
            setpointnames_hold = setpointnames{i};
        else
            %%%%%%%%% SOC only for batteries %%%%%
                IEDname_hold = [IEDname_hold,',',IEDnames{i}];
                setpointnames_hold = [setpointnames_hold,',',setpointnames{i}];
                  
        end;
end;
  
%% size of IED devices
IED_bytes = length(IEDname_hold);
IED_send = cast(typecast(cast(IED_bytes,'uint32'),'uint8'),'char');

%% size of measurement name
setpointnames_bytes = length(setpointnames_hold);
setpointnames_send = cast(typecast(cast(setpointnames_bytes,'uint32'),'uint8'),'char');

%% data_array
setpoints_send = cast(typecast(setpoints,'uint8'),'char')

%% size of entire message(new_full_send)
new_full_message = [message_send,message,IED_send,IEDname_hold,setpointnames_send,setpointnames_hold,setpoints_send];

new_full_bytes = length(new_full_message);
new_full_send = cast(typecast(cast(new_full_bytes,'uint32'),'uint8'),'char');
new_full_message_full = [new_full_send, new_full_message] ;


fwrite(SCADA_send,new_full_message_full,'char');

