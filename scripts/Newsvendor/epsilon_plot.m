seed = 1;
rng(seed);

trial = 100;
Npoints = 20;
K = Npoints/4;
Spoints = 50000;

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


    % epsilon value
    P = cell(K,1);
    cons_points = data_cons;
    for k = 1:K
        P{k,1} = PLD_partitions(cons_points,k,K);
    end

    coeff = zeros(K,1);
    for k = 1:K
        I_k = News_PLD_nums(P{k,1}, data_in{i,1});
        R_k = News_PLD_radius(P{k,1}, cons_points, k);
        coeff(k) =  1/(R_k^2)*sqrt(I_k);
    end

coeff_avg = mean(coeff);
epsilons = [0,10,50,100,200,500,1000];
epsilons = epsilons*coeff_avg;
epsilon_p = 0.5;
epsilon_p = epsilon_p/K*Npoints;

num = size(epsilons,2); 
n = size(epsilons,2);  
avg_cvar_cop_list = zeros(1,n);
avg_cvar_sp_list = zeros(1,n);
avg_cvar_saa_list =  zeros(1,n);
avg_cvar_cop_list_neg10 = zeros(1,n);
avg_cvar_cop_list_pos90 = zeros(1,n);
avg_cvar_sp_list_neg10 = zeros(1,n);
avg_cvar_sp_list_pos90 = zeros(1,n);
avg_cvar_saa_list_neg10 = zeros(1,n);
avg_cvar_saa_list_pos90 = zeros(1,n);

for i = 1:n
    X = ['epsilon =', num2str(epsilons(i)/coeff_avg),' lalalalalalalala'];
    disp(X);
    [avg_cvar_cop,avg_cvar_sp,avg_cvar_saa,cop10,cop90,sp10,sp90,saa10,saa90] = outperformance_general(epsilons(i),epsilon_p,Npoints,K);
    avg_cvar_cop_list(i) = avg_cvar_cop;
    avg_cvar_sp_list(i) = avg_cvar_sp;
    avg_cvar_saa_list(i) = avg_cvar_saa;
    avg_cvar_cop_list_neg10(i) = cop10;
    avg_cvar_cop_list_pos90(i) = cop90;
    avg_cvar_sp_list_neg10(i) = sp10;
    avg_cvar_sp_list_pos90(i) = sp90;
    avg_cvar_saa_list_neg10(i) = saa10;
    avg_cvar_saa_list_pos90(i) = saa90;  
end



% figure()
% xlabel("epsilon");
% ylabel("optimal cost");
% hold on
% plot_cop=plot(epsilons,avg_cvar_cop_list,'b'); 
% errorbar(epsilons,avg_cvar_cop_list,avg_cvar_cop_list_neg20,avg_cvar_cop_list_pos80,'b');
% plot_sp=plot(epsilons,avg_cvar_sp_list,'r'); 
% errorbar(epsilons,avg_cvar_sp_list,avg_cvar_sp_list_neg20,avg_cvar_sp_list_pos80,'r');
% plot_saa=plot(epsilons,avg_cvar_saa_list,'g'); 
% errorbar(epsilons,avg_cvar_saa_list,avg_cvar_saa_list_neg20,avg_cvar_saa_list_pos80,'g');
% legend([plot_cop plot_sp plot_saa],{'copositive','Slemma','SAA'});  

% plot of out of sample performance
font_size = 24;
alpha = 0.2;
color = [0.9290, 0.6940, 0.1250;
         0.4940, 0.1840, 0.5560;
         0.4660, 0.6740, 0.1880];

fig1 = figure(1);
hold on

epsilons = epsilons/coeff(K);

plot_cop = plot_with_shade(epsilons(1:num), avg_cvar_cop_list(1:num), avg_cvar_cop_list_neg10(1:num),avg_cvar_cop_list_pos90(1:num), alpha, color(1,:),'^');
plot_sp = plot_with_shade(epsilons(1:num), avg_cvar_sp_list(1:num), avg_cvar_sp_list_neg10(1:num),avg_cvar_sp_list_pos90(1:num), alpha, color(2,:),'o');
plot_saa = plot_with_shade(epsilons(1:num), avg_cvar_saa_list(1:num), avg_cvar_saa_list_neg10(1:num),avg_cvar_saa_list_pos90(1:num), alpha, color(3,:),'|');

set(gca,'XLim',[0 1300])
set(gca,'XTick',(0:200:1200))

grid on
set(gca, 'FontSize', font_size - 6);
xlabel('Robustness Parameter $\epsilon_K$', 'Interpreter', 'latex', 'FontSize', font_size);
ylabel('Out of Sample Cost', 'Interpreter', 'latex', 'FontSize', font_size);
lgd = legend([plot_cop plot_sp plot_saa], 'C1','C0','SAA', 'Location', 'northeast');
set(lgd,'Interpreter','latex', 'FontSize', font_size-6);
% saveas(gcf,'fig2-all','svg')

