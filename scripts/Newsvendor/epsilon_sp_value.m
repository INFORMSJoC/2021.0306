function [epsilon0_sp] =  epsilon_sp_value(data_cons, data,K)

% seed = 1;
% rng(seed);
K0 = 2;
    % epsilon value
    P = cell(K,1);
    cons_points = data_cons;
    for k = 1:K
        P{k,1} = PLD_partitions(cons_points,k,K);
    end

    coeff = zeros(K,1);
    for k = 1:K
        I_k = News_PLD_nums(P{k,1}, data)/K0*(K0-1);
        R_k = News_PLD_radius(P{k,1}, cons_points, k);
        coeff(k) =  1/(R_k^2)*sqrt(I_k);
    end

coeff_avg = mean(coeff);
epsilon_sp_list = [50,100,300,500]*coeff_avg;

g = [2.5;3;3.5;4;4.5]*2;
Npoints = size(data,2);
obj_sp_list = zeros(1,K0);
obj_sp_avg_list = zeros(1,length(epsilon_sp_list));

% K fold preparation
data0 = cell(K0,1);
n = floor(Npoints/K0);
for i = 1:K0
    data0{i,1} = data(:,(i-1)*n+1:i*n);
end


for i = 1:length(epsilon_sp_list)
    epsilon_sp = epsilon_sp_list(i);
    for j = 1:K0
        data_test = data0{j,1};
        len = size(data_test,1);
        data_test = data_test(1:(len-1),:);
        data_train = [];
        for k = 1:K0
            if k ~= j
                data_train = [data_train,data0{k,1}];
            end
        end
        
        % S-procedure
        [x_sp,obj_sp] = Newsvendor_PLD_sp_CV(data_cons,data_train,epsilon_sp,K);
        x_sp = double(x_sp);
        obj_sp_list(j) = obj_cvar(x_sp,data_test,g,size(data_test,2));        
    end
    obj_sp_avg_list(i) = sum(obj_sp_list)/K0;
end

min_sp = 9999999;
min_sp_index = 0; 
for i = 1:length(epsilon_sp_list) 
    if obj_sp_avg_list(i) < min_sp
        min_sp = obj_sp_avg_list(i);
        min_sp_index = i;
    end
end

epsilon0_sp = epsilon_sp_list(min_sp_index);
end