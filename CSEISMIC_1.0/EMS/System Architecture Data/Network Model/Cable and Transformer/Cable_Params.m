clc
clear

format long g

tic;
home = cd;

% res = 1.724*10^-8; 
% ohm-meter @ 75C

%% Read CSV files

fid = fopen(fullfile(home,'MIT-LL Cables and Transformers.csv'));
data = textscan(fid,'%s%s%s%s%s%s%s%s','Delimiter',',');
fclose(fid);

cables_transformers = cell(length(data{1}),length(data));
for i = 1:length(data{1})
    for j = 1:length(data)
        cables_transformers(i,j) = data{j}(i);
    end
end
R_col_num=length(data)+1;% column # of R
X_col_num=length(data)+2;% column # of X
% Add columns for calculated R and X parameters
cables_transformers(1,R_col_num) = {'R in Ohms'};
cables_transformers(1,X_col_num) = {'X in Ohms'};


% Cable Specs
fid = fopen(fullfile(home,'Cable model.csv'));
data = textscan(fid,'%s%s%s%s%s','Delimiter',',');
fclose(fid);

cable_model = cell(length(data{1}),length(data));
for i = 1:length(data{1})
    for j = 1:length(data)
        cable_model(i,j) = data{j}(i);
    end
end

% Transformer Specs
fid = fopen(fullfile(home,'Transformer model.csv'));
data = textscan(fid,'%s%s%s%s%s','Delimiter',',');
fclose(fid);

transformer_model = cell(length(data{1}),length(data));
for i = 1:length(data{1})
    for j = 1:length(data)
        transformer_model(i,j) = data{j}(i);
    end
end
%% Conductor R and X calculation
for i = 2:length(cables_transformers(:,1))

        % Determine conductor type (cables or transformer)
        Conductor_type = cables_transformers{i,4};
        if Conductor_type == 'C';% it is a cable
        disp ('It is a Cable!')
        c_awg = cables_transformers{i,6};% cable AWG
        c_length = str2double(cables_transformers{i,7});% cable length in ft
        I_c_awg = cell2mat(cellfun(@(x) strcmp(c_awg,{x}),cable_model(:,1),'UniformOutput',false));% find the row index of corresponding AWG

        voltage_level=str2double(cables_transformers{i,5});% cable voltage level
                 if voltage_level<5000  %600V-5000V nonshielded
                     r_c = str2double(cable_model(I_c_awg,2))*c_length/1000;
                     x_c = str2double(cable_model(I_c_awg,3))*c_length/1000;
                 else                   %5000V-15000V shielded
                     r_c = str2double(cable_model(I_c_awg,4))*c_length/1000;
                     x_c = str2double(cable_model(I_c_awg,5))*c_length/1000;
                 end
        cables_transformers(i,R_col_num) = {num2str(r_c)};% add calculated R and X to cell matrix 
        cables_transformers(i,X_col_num) = {num2str(x_c)};
        else % it is a transformer
        disp('It is a transformer!')
        voltage_rating=str2double(cables_transformers{i,5});% transformer secondary voltage level
        t_cap=cables_transformers{i,8};% transformer capacity
        t_Zbase=(voltage_rating)^2/str2double(t_cap)/1000;% base Z value
        I_t_cap = cell2mat(cellfun(@(x) strcmp(t_cap,{x}),transformer_model(:,1),'UniformOutput',false));% find the row index of corresponding capacity
        r_t=str2double(transformer_model(I_t_cap,3))*t_Zbase/100;%R values of transformner in Ohms
        x_t=str2double(transformer_model(I_t_cap,4))*t_Zbase/100;%X values of transformner in Ohms

        cables_transformers(i,R_col_num) = {num2str(r_t)};% add calculated R and X to cell matrix 
        cables_transformers(i,X_col_num) = {num2str(x_t)};
        end
end
% Write Cables File
fid = fopen(fullfile(home,'MIT-LL_Cable_and_Transformer_Parameters.csv'),'w');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',cables_transformers{1,1},cables_transformers{1,2},cables_transformers{1,3},cables_transformers{1,4},cables_transformers{1,5},...
                                              cables_transformers{1,6},cables_transformers{1,7},cables_transformers{1,8},cables_transformers{1,9},cables_transformers{1,10});
for j = 2:length(cables_transformers(:,1))
    fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',cables_transformers{j,1},cables_transformers{j,2},cables_transformers{j,3},cables_transformers{j,4},cables_transformers{j,5},...
                                                  cables_transformers{j,6},cables_transformers{j,7},cables_transformers{j,8},cables_transformers{j,9},cables_transformers{j,10});
end
fclose(fid);

toc













