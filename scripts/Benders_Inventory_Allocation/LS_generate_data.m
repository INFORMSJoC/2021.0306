function [data] = LS_generate_data(Npoints)

% seed = 1;
% rng(seed);

N       = 5; % number of locations
v_l = 40; v_u = 50; % v_l <= v <= v_u
u_l = 20 ; u_u = 40; % u_l <= u <= u_u 


% data1 = unifrnd(v_l,v_u,[N*N,Npoints]);
% v = data1;

% data1 = NaN;
% while size(data1,1)< Npoints
%     mu = ones(N*N,1)*3.97;
%     sigma = ones(N*N,1)*0.5;
%     corrmat = gallery('randcorr',N*N);
%     data1 = MvLogNRand(mu,sigma,Npoints*1000,corrmat);
%     data1_l = [];
%     i = 1;
%     while size(data1_l,1)< Npoints & i <= size(data1,1)
%         data0 = data1(i,data1(i,:) <= v_u & data1(i,:) >= v_l);
%         if size(data0,2) == N*N
%             data1_l = [data1_l;data0];
%         end
%         i = i+1;
%     end
%     data1 = data1_l;
% end
% data1 = data1(1:Npoints,:);
% v = data1';


mu_list = ones(N*N,1)*3;
sigma_list = ones(N*N,1)*0.1;

data1 = zeros(N*N,Npoints);
for i = 1:N*N
    mu = mu_list(i);
    sigma = sigma_list(i);
    pd2 = makedist('Lognormal','mu',mu,'sigma',sigma);
    t1 = truncate(pd2,v_l,v_u);
    data1(i,:) = random(t1,1,Npoints);
end
v = data1;

% v = ones(N*N,Npoints)*v_l;


% data2 = unifrnd(u_l,u_u,[N,Npoints]);
% u = data2;

% data2 = NaN;
% while size(data2,1)< Npoints
%     mu = [3.5;3.5;3.55;3.6;3.6];
%     sigma = [1/2;1/2;1/2;1/2;1/2];
%     corrmat = gallery('randcorr',N);
%     data2 = MvLogNRand(mu,sigma,Npoints*1000,corrmat); 
%     data2_l = [];
%     i = 1;
%     while size(data2_l,1)< Npoints & i <= size(data2,1)
%         data0 = data2(i,data2(i,:) <= u_u & data2(i,:) >= u_l);
%         if size(data0,2) == N
%             data2_l = [data2_l;data0];
%         end
%         i = i+1;
%     end
%     data2 = data2_l;
% end
% data2 = data2(1:Npoints,:);
% u = data2'; 

mu_list = [3;3;3.5;3.5;3.5];
sigma_list = [0.2;0.2;0.2;0.2;0.2];

data2 = zeros(N,Npoints);
for i = 1:N
    mu = mu_list(i);
    sigma = sigma_list(i);
    pd4= makedist('Lognormal','mu',mu,'sigma',sigma);
    t2 = truncate(pd4,u_l,u_u);
    data2(i,:) = random(t2,1,Npoints);
end
u = data2;


data = [v;u;ones(1,Npoints)];

end