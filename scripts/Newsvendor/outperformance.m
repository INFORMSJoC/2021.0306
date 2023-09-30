function [avg_cvar_cop,avg_cvar_sp,avg_cvar_saa,cop10,cop90,sp10,sp90,saa10,saa90] = outperformance(epsilon,Npoints,K)

seed = 1;
rng(seed);

trial = 100;
N = 5; % number of stocks
Spoints = 50000;
xi_l = 0; xi_u = 10; % xi_l <= xi <= xi_u
s_l = 0; s_u = 50; % s_l <= s <= s_u 
g = [2.5;3;3.5;4;4.5]*2;

   
cvar_cop_list = zeros(trial,1);
cvar_sp_list = zeros(trial,1);
cvar_saa_list = zeros(trial,1);
gap_saa = zeros(trial,1);
gap_sp = zeros(trial,1);

data_out = cell(trial,1);
data_in = cell(trial,1);

for i = 1:trial
    data_out{i,1} = generate_data(Spoints);
end 

for i = 1:trial
    data_in{i,1} = generate_data(Npoints);
end

data_cons = generate_data(K);

disp("finish generating data")

for i = 1:trial   
    
    % copositive programming    
    [x_cop,obj_cop] = Newsvendor_PLD_cop(data_cons,data_in{i,1},epsilon,K);
    x_cop = double(x_cop);
    obj_cop = double(obj_cop);
    
    cvar_cop_list(i) = obj_cvar2(x_cop,data_out{i,1},g,Spoints);
    disp("finish copositive")
    
    
    % S procedure programming
    [x_sp,obj_sp] = Newsvendor_PLD_sp(data_cons,data_in{i,1},epsilon,K);
    x_sp = double(x_sp);
    obj_sp = double(obj_sp);
    
    cvar_sp_list(i) = obj_cvar2(x_sp,data_out{i,1},g,Spoints);
    disp("finish S lemma")
    
    % SAA
    [x_saa,obj_saa] = SAA2(data_in{i,1});
    x_saa = double(x_saa);
    obj_saa = double(obj_saa);
    
    cvar_saa_list(i) = obj_cvar2(x_saa,data_out{i,1},g,Spoints);
    disp("finish SAA")
    
    gap_saa(i) = (cvar_saa_list(i) - cvar_cop_list(i))/cvar_saa_list(i);
    gap_sp(i) = (cvar_sp_list(i) - cvar_cop_list(i))/cvar_sp_list(i);
    X = ['tryyyyyyyyyyyyy ',num2str(i),'th trial for N =', num2str(Npoints),' lalalalalalalala'];
    disp(X);
end

% avg_obj_cop = mean(obj_cop_list);
% avg_obj_sp = mean(obj_sp_list);
% avg_obj_saa = mean(obj_saa_list);
% avg_obj_cop
% avg_obj_sp
% avg_obj_saa
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