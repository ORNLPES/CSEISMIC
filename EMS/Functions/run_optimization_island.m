function run_optimization_trans_to_island()
global home;

 try 
        cd(fullfile(home,'System Data','Setpoints'))
        setpointcontinue =0;
		while setpointcontinue <100
			fid = fopen('Setpoints.txt','w')
			if fid ==-1
				pause(0.05)
				setpointcontinue = setpointcontinue +1;
			else
				break
			end
		end
		

%         for i = 1:length(generators)
%             fprintf(fid,'%s,Real,%f\n',generators{i},0)
%             fprintf(fid,'%s,Reactive,%f\n',generators{i},0)
%             fprintf(fid,'%s,Voltage,%f\n',generators{i},480)
%             fprintf(fid,'%s,Frequency,%f\n',generators{i},60)
%         end;
       %for i = 1:length(P_b_solution)
            %% Uncomment here for ES1
             
			 %fprintf(fid,'%s,Real,%f\n','ES1 ',0)
             %fprintf(fid,'%s,Reactive,%f\n','ES1',0)
             %fprintf(fid,'%s,Voltage,%f\n','ES1',480)
             %fprintf(fid,'%s,Frequency,%f\n','ES1',60) 
			
			%% Uncomment here for ES2
			
			 fprintf(fid,'%s,Real,%f\n','ES2',0)
             fprintf(fid,'%s,Reactive,%f\n','ES2',0)
             fprintf(fid,'%s,Voltage,%f\n','ES2',480)
             fprintf(fid,'%s,Frequency,%f\n','ES2',60) 
			
			
% 			fprintf(fid,'%s,Real,%f\n','ES1',0.04*1000^2)
%             fprintf(fid,'%s,Reactive,%f\n','ES1',0.0*1000^2)%Q_b_solution(1)*1000^2)
%             fprintf(fid,'%s,Voltage,%f\n','ES1',480)
%             fprintf(fid,'%s,Frequency,%f\n','ES1',60) 
        %end;
        fclose(fid)
    catch Me
        create_error_notification(home,Me.message,'run optimization grid connected_saving setpoints file.txt');
    end