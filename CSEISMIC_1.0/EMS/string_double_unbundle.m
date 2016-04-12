function [number] = string_double_unbundle(old_string)
%[number] = string_double_unbundle(old_string)
% unbundles strings

 number_bits = cast(old_string,'uint8');
 number = typecast(number_bits,'double');
