function [epsilon0_p_cop] =  epsilon_p_cop_value(data_cons, data,K,epsilon_cop)


K0 = 2;

g = [2.5;3;3.5;4;4.5]*2;
Npoints = size(data,2);

epsilon_p_cop_list = [0,0.1,0.5]/K*Npoints;

obj_cop_list = zeros(1,K0);
obj_cop_avg_list = zeros(1,length(epsilon_p_cop_list));

% K fold preparation
data0 = cell(K0,1);
n = floor(Npoints/K0);
for i = 1:K0
    data0{i,1} = data(:,(i-1)*n+1:i*n);
end


for i = 1:length(epsilon_p_cop_list)
    epsilon_p_cop = epsilon_p_cop_list(i);
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
        [x_cop,obj_cop] = Newsvendor_PLD_cop_general(data_cons, data_train,epsilon_cop,epsilon_p_cop,K);
        x_cop = double(x_cop);
        obj_cop_list(j) = obj_cvar2(x_cop,data_test,g,size(data_test,2));       
    end
    obj_cop_avg_list(i) = sum(obj_cop_list)/K0;
end


min_cop = 9999999;
min_cop_index = 0;
for i = 1:length(epsilon_p_cop_list) 
    if obj_cop_avg_list(i) < min_cop
        min_cop = obj_cop_avg_list(i);
        min_cop_index = i;
    end
end

epsilon0_p_cop = epsilon_p_cop_list(min_cop_index);
end