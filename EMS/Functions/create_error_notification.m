function create_error_notification(home,message,filename)
%[] = create_error_notification(home,message,filename)
% creates an error file and changes system_status to -1

global system_status;

cd(fullfile(home))
cd(fullfile(home,'System_Status'))

%% file name based on time and error message 
current_time = clock;
current_time_str = strcat(num2str(current_time(1),'%04.0f'),'_',num2str(current_time(2),'%02.0f'),'_',...
    num2str(current_time(3),'%02.0f'),'_',num2str(current_time(4),'%02.0f'),'_',num2str(current_time(5),'%02.0f'),'_',...
    num2str(current_time(6),'%02.3f'),'_');
fid = fopen(strcat(current_time_str,filename),'w')
fprintf(fid,'%s',message)
fclose(fid)

system_status = -1;

cd(fullfile(home))