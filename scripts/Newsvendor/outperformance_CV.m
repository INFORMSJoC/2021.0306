function [avg_cvar_cop,avg_cvar_sp,avg_cvar_saa,cop10,cop90,sp10,sp90,saa10,saa90,avg_T_cop,avg_T_sp,avg_T_saa] = outperformance_CV(Npoints,K)

seed = 1;
rng(seed);

trial = 50;
trial_CV = 50;
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

T_cop = zeros(trial,1);
T_sp = zeros(trial,1);
T_saa = zeros(trial,1);

data_out = cell(trial,1);
data_in = cell(trial,1);
data0_in = cell(trial,1);

N0 = 40;
K0 = N0*K/Npoints;

for i = 1:trial
    data_out{i,1} = generate_data(Spoints);
end 

for i = 1:trial
    data_in{i,1} = generate_data(Npoints);
end

data_cons = generate_data(K);
data_cons0 = generate_data(K0);

seed = 1;
rng(seed);
for i = 1:trial
    data_out{i,1} = generate_data(Spoints);
end 
for i = 1:trial_CV
    data0_in{i,1} = generate_data(N0);
end
     
disp("finish generating data")

if Npoints > N0
    epsilon_cop_list = zeros(trial_CV,1);
    epsilon_sp_list = zeros(trial_CV,1);
    i = 0;
    while i < trial_CV
        i = i+1;
        epsilon_cop_list(i) = epsilon_cop_value(data_cons0,data0_in{i,1},K0);
        epsilon_sp_list(i) = epsilon_sp_value(data_cons0,data0_in{i,1},K0);
    end
    epsilon_cop_fix = mode(epsilon_cop_list);
    epsilon_sp_fix = mode(epsilon_sp_list);
end

cop_cont = true;
sp_cont = true;
if Npoints > 80
    cop_cont = false;
end
for i = 1:trial
    % Cross Validation
    if Npoints <= N0
        epsilon_cop = epsilon_cop_value(data_cons, data_in{i,1},K);
        epsilon_sp = epsilon_sp_value(data_cons, data_in{i,1},K);
    else
        epsilon_cop = epsilon_cop_fix;
        epsilon_sp = epsilon_sp_fix;
    end
    
    % copositive programming    
    if cop_cont
        [x_cop,obj_cop,runtime_cop] = Newsvendor_PLD_cop(data_cons,data_in{i,1},epsilon_cop,K);
        if runtime_cop > 30*60
            cop_cont = false;
            T_cop(i) = NaN;
            cvar_cop_list(i) = NaN;
        else  
            T_cop(i) = runtime_cop;
            x_cop = double(x_cop);
            cvar_cop_list(i) = obj_cvar2(x_cop,data_out{i,1},g,Spoints);
        end
    else
        T_cop(i) = NaN;
        cvar_cop_list(i) = NaN;       
    end
    disp("finish copositive")

    
    % S procedure programming 
    if sp_cont
        [x_sp,obj_sp,runtime_sp] = Newsvendor_PLD_sp(data_cons,data_in{i,1},epsilon_sp,K);
        if runtime_sp > 30*60
            sp_cont = false;
            T_sp(i) = NaN;
            cvar_sp_list(i) = NaN;
        else  
            T_sp(i) = runtime_sp;
            x_sp = double(x_sp);
            cvar_sp_list(i) = obj_cvar2(x_sp,data_out{i,1},g,Spoints);
        end
    else
        T_sp(i) = NaN;
        cvar_sp_list(i) = NaN;       
    end
    disp("finish S lemma")
         

    % SAA
    
    [x_saa,obj_saa,runtime_saa] = SAA2(data_in{i,1});
    T_saa(i) = runtime_saa;
    x_saa = double(x_saa);
    obj_saa = double(obj_saa);
%     disp("finish in-sample SAA")
        
    cvar_saa_list(i) = obj_cvar2(x_saa,data_out{i,1},g,Spoints);
    disp("finish SAA")
    
    gap_saa(i) = (cvar_saa_list(i) - cvar_cop_list(i))/cvar_saa_list(i);
    gap_sp(i) = (cvar_sp_list(i) - cvar_cop_list(i))/cvar_sp_list(i);
    X = ['tryyyyyyyyyyyyy ',num2str(i),'th trial for N =', num2str(Npoints),' lalalalalalalala'];
    disp(X)
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
avg_T_cop = mean(T_cop);
avg_T_sp = mean(T_sp);
avg_T_saa = mean(T_saa);
avg_gap_saa = mean(gap_saa);
avg_gap_sp = mean(gap_sp);
avg_cvar_cop
avg_cvar_sp
avg_cvar_saa
avg_gap_saa
avg_gap_sp
avg_T_cop
avg_T_sp
avg_T_saa
end