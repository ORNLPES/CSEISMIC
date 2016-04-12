function create_error_notification_ongrid_optimization(home,message,filename)

global stop_optimization;

cd(fullfile(home))
cd(fullfile(home,'System_Status'))

%#TODO list - add 2 digit spacing on date/numbers
current_time = clock;
current_time_str = strcat(num2str(current_time(1),'%04.0f'),'_',num2str(current_time(2),'%02.0f'),'_',...
    num2str(current_time(3),'%02.0f'),'_',num2str(current_time(4),'%02.0f'),'_',num2str(current_time(5),'%02.0f'),'_',...
    num2str(current_time(6),'%02.3f'),'_');
fid = fopen(strcat(current_time_str,filename),'w')
fprintf(fid,'%s',message)
fclose(fid)

stop_optimization = 1;

cd(fullfile(home))