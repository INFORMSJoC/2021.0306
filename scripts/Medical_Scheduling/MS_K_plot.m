% seed = 1;
% rng(seed);

Npoints = 30;
Ks = [5,10,15,20,25,30];
trial = 20;

num = size(Ks,2);
n = size(Ks,2);  
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
    K = Ks(i)
    seed = 1;
    rng(seed);
    data0_in = cell(trial,1);
    for j = 1:trial
        data0_in{j,1} = MS_generate_data(30);
    end
    data_cons0 = MS_generate_data(K);
    epsilon_cop_list = zeros(trial,1);
    epsilon_sp_list = zeros(trial,1);
    j = 0;
    while j < trial
        j = j+1;
        epsilon_cop_list(j) = MS_epsilon_cop_value(data_cons0,data0_in{j,1},K);
        epsilon_sp_list(j) = MS_epsilon_sp_value(data_cons0,data0_in{j,1},K);
    end
    epsilon_cop_fix = mode(epsilon_cop_list)
    epsilon_sp_fix = mode(epsilon_sp_list)
    
    [avg_cvar_cop,avg_cvar_sp,avg_cvar_saa,avg_cvar_wass,cop10,cop90,sp10,sp90,saa10,saa90,wass10,wass90,avg_T_cop,avg_T_sp,avg_T_saa,avg_T_wass] = outperformance_CV_MS_wass(Npoints,K,epsilon_cop_fix,epsilon_sp_fix);
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
% xlabel("number of partitions");
% ylabel("optimal cost");
% hold on
% plot_cop=plot(Ks,avg_cvar_cop_list,'b'); 
% errorbar(Ks,avg_cvar_cop_list,avg_cvar_cop_list_neg20,avg_cvar_cop_list_pos80,'b');
% plot_sp=plot(Ks,avg_cvar_sp_list,'r'); 
% errorbar(Ks,avg_cvar_sp_list,avg_cvar_sp_list_neg20,avg_cvar_sp_list_pos80,'r');
% plot_saa=plot(Ks,avg_cvar_saa_list,'g'); 
% errorbar(Ks,avg_cvar_saa_list,avg_cvar_saa_list_neg20,avg_cvar_saa_list_pos80,'g');
% legend([plot_cop plot_sp plot_saa],{'copositive','Slemma','SAA'});    


% plot of out of sample performance
font_size = 24;
alpha = 0.2;
color = [0.9290, 0.6940, 0.1250;
         0.4940, 0.1840, 0.5560;
         0.4660, 0.6740, 0.1880];

fig1 = figure(1);
hold on

plot_cop = plot_with_shade(Ks(1:num), avg_cvar_cop_list(1:num), avg_cvar_cop_list_neg10(1:num),avg_cvar_cop_list_pos90(1:num), alpha, color(1,:),'^');
plot_sp = plot_with_shade(Ks(1:num), avg_cvar_sp_list(1:num), avg_cvar_sp_list_neg10(1:num),avg_cvar_sp_list_pos90(1:num), alpha, color(2,:),'o');
plot_saa = plot_with_shade(Ks(1:num), avg_cvar_saa_list(1:num), avg_cvar_saa_list_neg10(1:num),avg_cvar_saa_list_pos90(1:num), alpha, color(3,:),'|');

grid on
set(gca, 'FontSize', font_size - 6);
xlabel('Number of Partitions K', 'Interpreter', 'latex', 'FontSize', font_size);
ylabel('Out of Sample Cost', 'Interpreter', 'latex', 'FontSize', font_size);
lgd = legend([plot_cop plot_sp plot_saa], 'C1','C0','SAA', 'Location', 'northeast');
set(lgd,'Interpreter','latex', 'FontSize', font_size-6);
% saveas(gcf,'fig2-all','svg')

