function [filextention] = current_time()
%[] = current_time()
% pulls a file name based on current time.

current_time = clock;
filextention = strcat(num2str(current_time(1)),'_',num2str(current_time(2)),'_',num2str(current_time(3)),'_',...
    num2str(current_time(4)),'_',...
    num2str(current_time(5)),'_',num2str(current_time(6)));