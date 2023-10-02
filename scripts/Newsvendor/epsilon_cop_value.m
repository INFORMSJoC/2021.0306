function [epsilon0_cop] =  epsilon_cop_value(data_cons, data,K)

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
epsilon_cop_list = [50,100,300,500]*coeff_avg;

g = [2.5;3;3.5;4;4.5]*2;
Npoints = size(data,2);
obj_cop_list = zeros(1,K0);
obj_cop_avg_list = zeros(1,length(epsilon_cop_list));

% K fold preparation
data0 = cell(K0,1);
n = floor(Npoints/K0);
for i = 1:K0
    data0{i,1} = data(:,(i-1)*n+1:i*n);
end


for i = 1:length(epsilon_cop_list)
    epsilon_cop = epsilon_cop_list(i);
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
        % copositive 
        [x_cop,obj_cop] = Newsvendor_PLD_cop_CV(data_cons, data_train,epsilon_cop,K);
        x_cop = double(x_cop);
        obj_cop_list(j) = obj_cvar2(x_cop,data_test,g,size(data_test,2));       
    end
    obj_cop_avg_list(i) = sum(obj_cop_list)/K0;
end


min_cop = 9999999;
min_cop_index = 0;
for i = 1:length(epsilon_cop_list) 
    if obj_cop_avg_list(i) < min_cop
        min_cop = obj_cop_avg_list(i);
        min_cop_index = i;
    end
end

epsilon0_cop = epsilon_cop_list(min_cop_index);
end