home = cd;
P_b_solution = 1:1:288;
SOC_b_solution = 1:1:288;

cd(fullfile(home,'System Data','Optimized Results'));
fid = fopen('Optimization Results.csv','w');

fprintf(fid,'Time (5 minute),')

for i = 1:288
    fprintf(fid,'%f,',i);
end;

fprintf(fid,'\n')


fprintf(fid,'Battery kW,')

for i = 1:length(P_b_solution)
    fprintf(fid,'%f,',P_b_solution(i));
end;

fprintf(fid,'\n')

fprintf(fid,'SOC,')

for i = 1:length(SOC_b_solution)
    fprintf(fid,'%f,',SOC_b_solution(i));
end;

fprintf(fid,'\n')

fclose(fid);
cd(fullfile(home))