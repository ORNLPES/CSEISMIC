function close_SCADA(home,handles,SCADA_send,SCADA_receive) 
%[] = close_SCADA(home,handles,SCADA_send,SCADA_receive) 
% closes connection to SCADA

%% updates status indicator 
try
    update_status(handles.program_status,home,'SCADA connections closing')
catch Me
    create_error_notification(home,Me.message,'close SCADA_update status.txt');
end;

%% send SCADA a '0' for closing
try 
    close_request_SCADA = cast(typecast(cast(0,'uint32'),'uint8'),'char')
    try
        fwrite(SCADA_send,close_request_SCADA,'char');
        fclose(SCADA_send)
        fclose(SCADA_receive)
    catch Me
         create_error_notification(home,Me.message,'Closing SCADA.txt');
    end;
catch
     create_error_notification(home,Me.message,'close SCADA_close SCADA channels.txt');
end;

%% update status
try
    update_status(handles.program_status,home,'SCADA connections closed')
catch Me
    create_error_notification(home,Me.message,'close SCADA_update status 2.txt');
end;
