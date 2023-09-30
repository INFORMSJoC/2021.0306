function [data] = FLP_generate_data(Npoints)

% seed = 1;
% rng(seed);

J       = 5; % number of locations
% d_l = 1; d_u = 50; % v_l <= v <= v_u
d_l = 50; d_u = 300; % v_l <= v <= v_u

% d_l = 20; d_u = 500; % v_l <= v <= v_u
% mu_list = ones(J,1)*4;
% sigma_list = ones(J,1)*1.5;

mu_list = ones(J,1)*3;
sigma_list = ones(J,1)*1;

data1 = zeros(J,Npoints);
for i = 1:J
    mu = mu_list(i);
    sigma = sigma_list(i);
    pd2 = makedist('Lognormal','mu',mu,'sigma',sigma);
    t1 = truncate(pd2,d_l,d_u);
    data1(i,:) = random(t1,1,Npoints);
end
v = data1;

data = [v;ones(1,Npoints)];

end