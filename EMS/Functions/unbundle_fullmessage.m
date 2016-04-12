function [size_of_message_size] = unbundle_fullmessage(number)
%[size_of_message_size] = unbundle_fullmessage(number)
% unbundles message from SCADA type cast from character to double.

 size_of_message = char(number);
 size_of_message_conv = cast(size_of_message,'uint8');
 size_of_message_receive = typecast(size_of_message_conv,'uint32');
 size_of_message_size = cast(size_of_message_receive,'double');


