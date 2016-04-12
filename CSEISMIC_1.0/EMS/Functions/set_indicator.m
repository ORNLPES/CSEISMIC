function set_indicator(icon_handle,message,color)
%[] = send_request(icon_handle, message, color)
% Changes the color and text on the gui block
% Currently supports: red/green/yellow/orange/blank.
% changes the color of the gui fault indicator

% [R G B]
if strcmp(color, 'red')
    set(icon_handle,'BackgroundColor',[1 0 0])
    set(icon_handle,'String',message)
elseif strcmp(color, 'green')
    set(icon_handle,'BackgroundColor',[0 1 0])
    set(icon_handle,'String',message)
elseif strcmp(color,'yellow')
    set(icon_handle,'BackgroundColor',[1 1 0.5])
    set(icon_handle,'String',message)
elseif strcmp(color,'orange')
    set(icon_handle,'BackgroundColor',[1 0.5 0])
    set(icon_handle,'String',message)
elseif strcmp(color,'blank')
    set(icon_handle,'BackgroundColor',[1 1 1])
    set(icon_handle,'String',message)
elseif strcmp(color,'black')
    set(icon_handle,'BackgroundColor',[0 0 0])
    set(icon_handle,'String',message)   
else
    set(icon_handle,'BackgroundColor',[0 0 0])
    set(icon_handle,'String','Unknown')
end;
pause(0.01)