function [avg_cvar_cop,avg_cvar_sp,avg_cvar_saa,cop10,cop90,sp10,sp90,saa10,saa90] = outperformance_CV_MS(Npoints,K)

seed = 1;
rng(seed);

trial = 3;
N = 8; % number of patients
Spoints = 30000;
   
cvar_cop_list = zeros(trial,1);
cvar_sp_list = zeros(trial,1);
cvar_saa_list = zeros(trial,1);
gap_saa = zeros(trial,1);
gap_sp = zeros(trial,1);

data_out = cell(trial,1);
data_in = cell(trial,1);
data0_in = cell(trial,1);

for i = 1:trial
    data_out{i,1} = MS_generate_data(Spoints);
end 

for i = 1:trial
    data_in{i,1} = MS_generate_data(Npoints);
end

seed = 1;
rng(seed);
for i = 1:trial
    data_out{i,1} = MS_generate_data(Spoints);
end 
for i = 1:trial
    data0_in{i,1} = MS_generate_data(20);
end

disp("finish generating data")

if Npoints > 20
    epsilon_cop_list = zeros(trial,1);
    epsilon_sp_list = zeros(trial,1);
    i = 0;
    while i < trial
        i = i+1;
%         epsilon_cop_list(i) = MS_epsilon_cop_value(data0_in{i,1});
%         epsilon_sp_list(i) = MS_epsilon_sp_value(data0_in{i,1});
        epsilon_cop_list(i) = 10;
        epsilon_sp_list(i) = 10;
    end
    epsilon_cop_fix = max(epsilon_cop_list)
    epsilon_sp_fix = max(epsilon_sp_list)
end

for i = 1:trial
    % Cross Validation
    if Npoints <= 20
        epsilon_cop = MS_epsilon_cop_value(data_in{i,1});
        epsilon_sp = MS_epsilon_sp_value(data_in{i,1});
    else
        epsilon_cop = epsilon_cop_fix;
        epsilon_sp = epsilon_sp_fix;
    end
    
    % copositive programming 
    [x_cop,obj_cop] = MS_PLD_cop(data_in{i,1},epsilon_cop,K);
    x_cop = double(x_cop);
    obj_cop = double(obj_cop);
    
    cvar_cop_list(i) = obj_cvar_MS(x_cop,data_out{i,1});
    disp("finish copositive")
    
    
    % S procedure programming
    [x_sp,obj_sp] = MS_PLD_sp(data_in{i,1},epsilon_sp,K);
    x_sp = double(x_sp);
    obj_sp = double(obj_sp);
    
    cvar_sp_list(i) = obj_cvar_MS(x_sp,data_out{i,1});
    disp("finish S lemma")
    
    % SAA
    [x_saa,obj_saa] = MS_cvar_SAA(data_in{i,1});
    x_saa = double(x_saa);
    obj_saa = double(obj_saa);
    
    cvar_saa_list(i) = obj_cvar_MS(x_saa,data_out{i,1});
    disp("finish SAA")


    gap_saa(i) = (cvar_saa_list(i) - cvar_cop_list(i))/cvar_saa_list(i);
    gap_sp(i) = (cvar_sp_list(i) - cvar_cop_list(i))/cvar_sp_list(i);
    X = ['tryyyyyyyyyyyyy',num2str(i),'th trial for N =', num2str(Npoints),'lalalalalalalala'];
    disp(X)
    
end


avg_cvar_cop = mean(cvar_cop_list);
cop10 = quantile(cvar_cop_list,0.1);
cop90 = quantile(cvar_cop_list,0.9);
avg_cvar_sp = mean(cvar_sp_list);
sp10 = quantile(cvar_sp_list,0.1);
sp90 = quantile(cvar_sp_list,0.9);
avg_cvar_saa = mean(cvar_saa_list);
saa10 = quantile(cvar_saa_list,0.1);
saa90 = quantile(cvar_saa_list,0.9);
avg_gap_saa = mean(gap_saa);
avg_gap_sp = mean(gap_sp);
avg_cvar_cop
avg_cvar_sp
avg_cvar_saa
avg_gap_saa
avg_gap_sp
end