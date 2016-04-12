function [new_string, message] = stringU32_unbundle(old_string)
%[new_string, message] = stringU32_unbundle(old_string)
% breaks string by first 4 characters and extacts message

 size_of_message = char(old_string(1:4));
 size_of_message_conv = cast(size_of_message,'uint8');
 size_of_message_receive = typecast(size_of_message_conv,'uint32');
 size_of_message_size = cast(size_of_message_receive,'double');

 message = {char([old_string(5:size_of_message_size+4)])};
 new_string = old_string(size_of_message_size+5:length(old_string))

 
