function [new_string, message] = stringU8_unbundle(old_string)
%[new_string, message] = stringU8_unbundle(old_string)
% breaks string by first character and extacts message

 size_of_message = char(old_string(1));
 size_of_message_conv = cast(size_of_message,'uint8');
 size_of_message_receive = typecast(size_of_message_conv,'uint8');
 size_of_message_size = cast(size_of_message_receive,'double');

 message = {char([old_string(2:size_of_message_size+1)])};
 new_string = old_string(size_of_message_size+2:length(old_string))

 
