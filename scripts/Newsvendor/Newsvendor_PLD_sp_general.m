function [x,obj,runtime] =  Newsvendor_PLD_sp_general(cons_points,data,epsilon0_sp,epsilon_p,K)

yalmip clear;

%% Parameters

N       = 5; % number of stocks
Npoints = size(data,2); % number of data points

xi_l = 0; xi_u = 10; % xi_l <= xi <= xi_u
s_l = 0; s_u = 50; % s_l <= s <= s_u 
delta = 0.1; % risk attitude
B1 = 30; % total supply

g = [2.5;3;3.5;4;4.5]*2;


% Define P_k
P = cell(K,1);
for k = 1:K
    P{k,1} = PLD_partitions(cons_points,k,K);
end


epsilon = cell(K,1);
for k = 1:K
    I_k = News_PLD_nums(P{k,1}, data);
    R_k = News_PLD_radius(P{k,1}, cons_points, k);
    if I_k > 0
        epsilon{k,1} = epsilon0_sp*R_k^2/sqrt(I_k);
    else
        epsilon{k,1} = 9999999999;
    end
end

epsilon_p = epsilon_p*K/Npoints;


Omega = cell(K,1);
num = cell(K,1);
for k = 1:K
    Omega{k,1} = zeros(size(data,1),size(data,1));
    num{k} = 0;
    for i = 1:Npoints
        if P{k,1}*data(:,i) >= 0
            Omega{k,1} = Omega{k,1} + data(:,i)*data(:,i)';
            num{k} = num{k} + 1;
        end
    end
    if num{k} > 0
        Omega{k,1} = Omega{k,1}/num{k};
    end
end

vector = @(x) x(:); %transfer a matrix to a vector

%% Decision Variables

l = size(P{1},1);
x = sdpvar(N,1);
kappa = sdpvar(1,1);
for k = 1:K; Q{k} = sdpvar(2*N+1,2*N+1,'full');end
for k = 1:K; theta{k} = sdpvar(1,1,'full');end
for k = 1:K; Y1{k} = sdpvar(N,2*N+1,'full');end
for k = 1:K; Y2{k} = sdpvar(N,2*N+1,'full');end
for k = 1:K; beta{k} = sdpvar(1,1,'full');end
for k = 1:K; V1{k} = sdpvar(2*N+1,2*N+1,'full');end
for k = 1:K; V2{k} = sdpvar(2*N+1,2*N+1,'full');end
for k = 1:K; V3{k} = sdpvar(2*N+1,2*N+1,'full');end
for k = 1:K; W1{k} = sdpvar(2*N+1,2*N+1);end
for k = 1:K; W2{k} = sdpvar(2*N+1,2*N+1);end
for k = 1:K; W3{k} = sdpvar(2*N+1,2*N+1);end
for k = 1:K; theta1{k} = sdpvar(l,1);end
for k = 1:K; theta2{k} = sdpvar(l,1);end
for k = 1:K; theta3{k} = sdpvar(l,1);end
for k = 1:K; n{k} = sdpvar(N,1);end
for k = 1:K; b{k} = sdpvar(N,1);end
for k = 1:K; d{k} = sdpvar(N,1);end
for k = 1:K; h{k} = sdpvar(N,1);end
for k = 1:K; M{k} = sdpvar(l,N);end
for k = 1:K; A{k} = sdpvar(l,N);end
for k = 1:K; C{k} = sdpvar(l,N);end
for k = 1:K; F{k} = sdpvar(l,N);end
for k = 1:K; pi{k} = sdpvar(1,1);end
for k = 1:K; B{k} = sdpvar(2*N+1,2*N+1);end
eta0 = sdpvar(1,1);
omega = sdpvar(1,1);
for k = 1:K; r{k} = sdpvar(1,1);end
for k = 1:K; s{k} = sdpvar(1,1);end

%% Constraints

constraints = {};
constraints{end+1} = x >= 0;
constraints{end+1} = sum(x) <= B1;
constraints{end+1} = omega >= 0;

for k = 1:K
    %% 

    constraints{end+1} = theta{k}+kappa >= 0; 
    constraints{end+1} = 0.5*((Q{k}-[zeros(2*N,1);1]*g'*Y1{k}-[zeros(N);eye(N);zeros(1,N)]*Y2{k})+(Q{k}-[zeros(2*N,1);1]*g'*Y1{k}-[zeros(N);eye(N);zeros(1,N)]*Y2{k})')-theta{k}*[zeros(2*N,1);1]*[zeros(2*N,1);1]' == V2{k};

    %% 

    constraints{end+1} = beta{k} >= 0;
    constraints{end+1} = 0.5*(Q{k}+Q{k}')-beta{k}*[zeros(2*N,1);1]*[zeros(2*N,1);1]' == V3{k};
    %% 
    
    constraints{end+1} = B{k} + pi{k}*[zeros(2*N,1);1]*[zeros(2*N,1);1]' == V1{k};
 
    %% SDP Approximation
    constraints{end+1} = V1{k} == W1{k}+0.5*(P{k}'*theta1{k}*[zeros(2*N,1);1]'+[zeros(2*N,1);1]*theta1{k}'*P{k});
    constraints{end+1} = theta1{k} >= 0;
    constraints{end+1} = W1{k} >= 0;    
    constraints{end+1} = V2{k} == W2{k}+0.5*(P{k}'*theta2{k}*[zeros(2*N,1);1]'+[zeros(2*N,1);1]*theta2{k}'*P{k});
    constraints{end+1} = theta2{k} >= 0;
    constraints{end+1} = W2{k} >= 0;
    constraints{end+1} = V3{k} == W3{k}+0.5*(P{k}'*theta3{k}*[zeros(2*N,1);1]'+[zeros(2*N,1);1]*theta3{k}'*P{k});
    constraints{end+1} = theta3{k} >= 0;
    constraints{end+1} = W3{k} >= 0;


    %% 

    constraints{end+1} = M{k} >= 0;
    constraints{end+1} = n{k}-x >= 0;
    constraints{end+1} = Y1{k}+[eye(N),zeros(N,N+1)]-M{k}'*P{k}-n{k}*[zeros(2*N,1);1]' == 0;

    %%
    constraints{end+1} = A{k} >= 0;
    constraints{end+1} = b{k}+x >= 0;
    constraints{end+1} = Y2{k}-[eye(N),zeros(N,N+1)]-A{k}'*P{k}-b{k}*[zeros(2*N,1);1]' == 0;

    %%

    constraints{end+1} = C{k} >= 0;
    constraints{end+1} = d{k} >= 0;
    constraints{end+1} = Y1{k}-C{k}'*P{k}-d{k}*[zeros(2*N,1);1]' == 0;

    %%

    constraints{end+1} = F{k} >= 0;
    constraints{end+1} = h{k} >= 0;
    constraints{end+1} = Y2{k}-F{k}'*P{k}-h{k}*[zeros(2*N,1);1]' == 0;

    %%
    constraints{end+1} = s{k} + eta0 <= omega;
    constraints{end+1} = sqrt(4*r{k}^2+(s{k}+eta0)^2) <= (2*omega-s{k}-eta0);
    value = cell(K,1);
    value{k} = pi{k}+epsilon{k}*norm(Q{k}'+B{k},'fro') + vector(Q{k}')'*vector(Omega{k})+ vector(B{k})'*vector(Omega{k});  
    constraints{end+1} = value{k} <= s{k};
    
end

%% objective: min
obj = epsilon_p*omega - eta0 + 2*omega*1; % Infinite-norm + last component
for k = 1:K
    obj = obj - 2*num{k}/Npoints*r{k};
end

     
obj = kappa+1/delta*obj; % Infinite-norm + last component

%% solving and post-processing

options = sdpsettings('dualize',0,'verbose', 0, 'solver', 'mosek');

out = optimize([constraints{:}],obj,options);
runtime = out.solvertime;


end