function [data] = MS_generate_data(Npoints)

seed = 1;
rng(seed);

N       = 8; % number of patients
l_l = 20; l_u = 100; % l_l <= l <= l_u
pi_l = 1 ; pi_u = 10; % pi_l <= pi <= pi_u 

% A1 = 2;
% B1 = 6;
% A2 = 2;
% B2 = 8;
% 
% l_l_list = randi([l_l l_l+10],N,1);
% l_u_list = randi([l_u-10 l_u],N,1);
% pi_l_list = randi([pi_l pi_l+10],N,1);
% pi_u_list = randi([pi_u-10 pi_u],N,1);

% mu_list = [3.5;3.5;3.6;3.6;3.7;3.7;3.8;3.8];
mu_list = [3.1;3.2;3.3;3.4;3.5;3.6;3.7;3.8];
sigma_list = ones(N,1)*2;

data1 = zeros(N,Npoints);
for i = 1:N
    mu = mu_list(i);
    sigma = sigma_list(i);
    pd2 = makedist('Lognormal','mu',mu,'sigma',sigma);
    t1 = truncate(pd2,l_l,l_u);
    data1(i,:) = random(t1,1,Npoints);
end
l = data1;

% data1 = betarnd(A1,B1,N,Npoints);
% for i = 1:N
%     data1(i,:) = l_l_list(i) + (l_u_list(i) - l_l_list(i))*data1(i,:);
% end
% l = data1;

% mu_list = [2.9;2.8;2.7;2.6;2.5;2.4;2.3;2.2];
% mu_list = [2.2;2.3;2.4;2.5;2.6;2.7;2.8;2.9];
mu_list = [1;1;1.1;1.1;1.2;1.2;1.3;1.3];
sigma_list = [1/2;1/2;1/2;1/2;1/2;1/2;1/2;1/2]*4;

data2 = zeros(N,Npoints);
for i = 1:N
    mu = mu_list(i);
    sigma = sigma_list(i);
    pd4= makedist('Lognormal','mu',mu,'sigma',sigma);
    t2 = truncate(pd4,pi_l,pi_u);
    data2(i,:) = random(t2,1,Npoints);
end
pi = data2;

% data2 = betarnd(A2,B2,N,Npoints);
% for i = 1:N
%     data2(i,:) = pi_l_list(i) + (pi_u_list(i) - pi_l_list(i))*data2(i,:);
% end
% pi = data2;

data = [l;pi;ones(1,Npoints)];

end