function update_status(program_status,home,information_string)
% [] = update_status(string_handle,main_directory_handle,display_string)
% Displays the requested text onto information panel on GUI
% allows for voice that says displayed text (currently disabled).

set(program_status,'String',information_string)
pause(.01) % for display of information/string not visible without pause

