function [data] = generate_data(Npoints)

seed = 1;
rng(seed);

N       = 5; % number of stocks
% Npoints = 100; % number of data points

xi_l = 0; xi_u = 10; % xi_l <= xi <= xi_u
s_l = 0; s_u = 50; % s_l <= s <= s_u 

% data1 = NaN;
% while isnan(data1) | ~isempty(data1(data1(:,:) > xi_u)) | ~isempty(data1(data1(:,:) < xi_l))
%     mu = [0.5;0.75;1];
%     sigma = [1/2;1/2;1/2];
%     corrmat = gallery('randcorr',3);
%     data1 = MvLogNRand(mu,sigma,Npoints,corrmat);
% end
% 
% xi = data1';

% data1 = NaN;
% while size(data1,1)< Npoints
%     mu = [0.5;0.75;1];
%     sigma = [1;1;3/2];
%     corrmat = gallery('randcorr',N);
%     data1 = MvLogNRand(mu,sigma,Npoints*1000,corrmat);
%     data1_l = [];
%     i = 1;
%     while size(data1_l,1)< Npoints & i <= size(data1,1)
%         data0 = data1(i,data1(i,:) <= xi_u & data1(i,:) >= xi_l);
%         if size(data0,2) == N
%             data1_l = [data1_l;data0];
%         end
%         i = i+1;
%     end
%     data1 = data1_l;
% end
% data1 = data1(1:Npoints,:);
% xi = data1';

% % pd1 = makedist('Uniform','Lower',0,'Upper',2);
% % mu_list = random(pd1,N,1);
% mu_list = [0.5;0.75;1];
% % sigma_list = [1/2;1/2;1/2];
% sigma_list = [1/2;1/2;1/2];
% 
% % mu_list = [0.5;1];
% % sigma_list = [1/2;1/2];

mu_list = [0.8;0.9;1;1.1;1.2];
sigma_list = [1;1;1;1;1]*1;

data1 = zeros(N,Npoints);
for i = 1:N
    mu = mu_list(i);
    sigma = sigma_list(i);
    pd2 = makedist('Lognormal','mu',mu,'sigma',sigma);
    t1 = truncate(pd2,xi_l,xi_u);
    data1(i,:) = random(t1,1,Npoints);
end
xi = data1;
    


% data2 = NaN;
% while isnan(data2) | ~isempty(data2(data2(:,:) > s_u)) | ~isempty(data2(data2(:,:) < s_l))
%     mu = [3.2;3.25;3.2];
%     sigma = [1/4;1/4;1/4];
%     corrmat = gallery('randcorr',3);
%     data2 = MvLogNRand(mu,sigma,Npoints,corrmat);
% end  
% s = data2';

% data2 = NaN;
% while size(data2,1)< Npoints
%     mu = [3.2;3.25;3.2];
%     sigma = [1;1;1];
%     corrmat = gallery('randcorr',N);
%     data2 = MvLogNRand(mu,sigma,Npoints*1000,corrmat); 
%     data2_l = [];
%     i = 1;
%     while size(data2_l,1)< Npoints & i <= size(data2,1)
%         data0 = data2(i,data2(i,:) <= s_u & data2(i,:) >= s_l);
%         if size(data0,2) == N
%             data2_l = [data2_l;data0];
%         end
%         i = i+1;
%     end
%     data2 = data2_l;
% end
% data2 = data2(1:Npoints,:);
% s = data2';        

% % pd3 = makedist('Uniform','Lower',3.2,'Upper',3.3);
% % mu_list = random(pd3,N,1);
% mu_list = [3.2;3.35;3.3];
% sigma_list = [1/4;1/4;1/4];
% 
% % mu_list = [3.3;3.2];
% % sigma_list = [1/2;1/2];
% 
% mu_list = [3.2;3.2;3.25;3.3;3.3];
mu_list = [3.2;3.2;3.3;3.3;3.4];
sigma_list = [1;1;1;1;1]*2;

data2 = zeros(N,Npoints);
for i = 1:N
    mu = mu_list(i);
    sigma = sigma_list(i);
    pd4= makedist('Lognormal','mu',mu,'sigma',sigma);
    t2 = truncate(pd4,s_l,s_u);
    data2(i,:) = random(t2,1,Npoints);
end
s = data2;

data = [xi;s;ones(1,Npoints)];

end