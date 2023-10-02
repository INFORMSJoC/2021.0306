Npoints = [10,20,40,80,160];
num = size(Npoints,2);
n = size(Npoints,2);
optimal_cost = 11970;


avg_cvar_cop_list = zeros(1,n);
avg_cvar_sp_list = zeros(1,n);
avg_cvar_saa_list =  zeros(1,n);
avg_cvar_wass_list =  zeros(1,n);
avg_cvar_cop_list_neg10 = zeros(1,n);
avg_cvar_cop_list_pos90 = zeros(1,n);
avg_cvar_sp_list_neg10 = zeros(1,n);
avg_cvar_sp_list_pos90 = zeros(1,n);
avg_cvar_saa_list_neg10 = zeros(1,n);
avg_cvar_saa_list_pos90 = zeros(1,n);
avg_cvar_wass_list_neg10 = zeros(1,n);
avg_cvar_wass_list_pos90 = zeros(1,n);
avg_T_cop_list = zeros(1,n);
avg_T_sp_list = zeros(1,n);
avg_T_saa_list = zeros(1,n);
avg_T_wass_list = zeros(1,n);

i = 0;
% cont = true;
while i < n 
    i = i+1;
    N = Npoints(i)
    K = N;
    [avg_cvar_cop,avg_cvar_sp,avg_cvar_saa,avg_cvar_wass,cop10,cop90,sp10,sp90,saa10,saa90,wass10,wass90,avg_T_cop,avg_T_sp,avg_T_saa,avg_T_wass] = outperformance_CV_MS_wass(N,K);
%     if avg_T_wass == 999999 || avg_T_cop == 999999 || avg_T_sp == 999999
%         cont = false;
%         num = i - 1;
%     end
    
    avg_cvar_cop_list(i) = avg_cvar_cop;
    avg_cvar_sp_list(i) = avg_cvar_sp;
    avg_cvar_saa_list(i) = avg_cvar_saa;
    avg_cvar_wass_list(i) = avg_cvar_wass;
    avg_cvar_cop_list_neg10(i) = cop10;
    avg_cvar_cop_list_pos90(i) = cop90;
    avg_cvar_sp_list_neg10(i) = sp10;
    avg_cvar_sp_list_pos90(i) = sp90;
    avg_cvar_saa_list_neg10(i) = saa10;
    avg_cvar_saa_list_pos90(i) = saa90;
    avg_cvar_wass_list_neg10(i) = wass10;
    avg_cvar_wass_list_pos90(i) = wass90; 
    
    avg_T_cop_list(i) = avg_T_cop;
    avg_T_sp_list(i) = avg_T_sp;
    avg_T_saa_list(i) = avg_T_saa;
    avg_T_wass_list(i) = avg_T_wass;
    
end

% plot of out of sample performance
font_size = 24;
alpha = 0.2;
color = [0.9290, 0.6940, 0.1250;
         0.4940, 0.1840, 0.5560;
         0.4660, 0.6740, 0.1880;
         0.3010, 0.7450, 0.9330];

fig1 = figure(1);
hold on
% plot_cop=plot(Npoints(1:num),avg_cvar_cop_list(1:num),'b'); 
% errorbar(Npoints(1:num),avg_cvar_cop_list(1:num),avg_cvar_cop_list_neg20(1:num),avg_cvar_cop_list_pos80(1:num),'b');
% plot_sp=plot(Npoints(1:num),avg_cvar_sp_list(1:num),'r'); 
% errorbar(Npoints,avg_cvar_sp_list(1:num),avg_cvar_sp_list_neg20(1:num),avg_cvar_sp_list_pos80(1:num),'r');
% plot_saa=plot(Npoints(1:num),avg_cvar_saa_list(1:num),'g'); 
% % errorbar(Npoints(1:num),avg_cvar_saa_list(1:num),avg_cvar_saa_list_neg20(1:num),avg_cvar_saa_list_pos80(1:num),'g');
% plot_wass=plot(Npoints(1:num),avg_cvar_wass_list(1:num),'y'); 
% errorbar(Npoints(1:num),avg_cvar_wass_list(1:num),avg_cvar_wass_list_neg20(1:num),avg_cvar_wass_list_pos80(1:num),'y');

plot_cop = plot_with_shade(Npoints(1:num), avg_cvar_cop_list(1:num), avg_cvar_cop_list_neg10(1:num),avg_cvar_cop_list_pos90(1:num), alpha, color(1,:),'^');
plot_sp = plot_with_shade(Npoints(1:num), avg_cvar_sp_list(1:num), avg_cvar_sp_list_neg10(1:num),avg_cvar_sp_list_pos90(1:num), alpha, color(2,:),'o');
plot_saa = plot_with_shade(Npoints(1:num), avg_cvar_saa_list(1:num), avg_cvar_saa_list_neg10(1:num),avg_cvar_saa_list_pos90(1:num), alpha, color(3,:),'|');
% plot_wass = plot_with_shade(Npoints(1:num), avg_cvar_wass_list(1:num), avg_cvar_wass_list_neg20(1:num),avg_cvar_wass_list_pos80(1:num), alpha, color(4,:));
plot_optimal = plot(Npoints(1:num), ones(1,num)*optimal_cost,'linewidth', 3, 'color','r','marker','.','markersize',12);

grid on
set(gca, 'FontSize', font_size - 6);
xlabel('Number of In-sample Points N', 'Interpreter', 'latex', 'FontSize', font_size);
ylabel('Out of Sample Cost', 'Interpreter', 'latex', 'FontSize', font_size);
lgd = legend([plot_cop plot_sp plot_saa plot_optimal], 'C1','C0','SAA','optimal','Location', 'northeast');
set(lgd,'Interpreter','latex', 'FontSize', font_size-6);
% saveas(gcf,'fig2-all','svg')


% plot of running time
fig2 = figure(2);
hold on
plot_cop_T = plot(Npoints(1:num),avg_T_cop_list(1:num),'linewidth', 3,'color', color(1,:)); 
plot_sp_T=plot(Npoints(1:num),avg_T_sp_list(1:num),'linewidth', 3,'color', color(2,:)); 
plot_saa_T=plot(Npoints(1:num),avg_T_saa_list(1:num),'linewidth', 3,'color', color(3,:)); 
% plot_wass_T=plot(Npoints(1:num),avg_T_wass_list(1:num),'linewidth', 3,'color', color(4,:)); 

grid on
set(gca, 'FontSize', font_size - 6);
xlabel('Number of In-sample Points', 'Interpreter', 'latex', 'FontSize', font_size);
ylabel('Average Runtime(sec)', 'Interpreter', 'latex', 'FontSize', font_size);
lgd = legend([plot_cop_T plot_sp_T plot_saa_T], 'C1','C0','SAA', 'Location', 'northeast');
set(lgd,'Interpreter','latex', 'FontSize', font_size-6);
% saveas(gcf,'fig2-all','svg')