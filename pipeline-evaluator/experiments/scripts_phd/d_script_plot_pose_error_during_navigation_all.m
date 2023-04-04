clear all
close all
pkg load io

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");


system = 'amcl-icp';

% Data (pose errors) is stored/retrieved from here
data_path_corridor = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/corridor/data_per_nav/medians/');
data_path_warehouse = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/warehouse/data_per_nav/medians/');

% Here is where the figures are stored
save_eps_path = '';
if strcmp(system, 'amcl-icp')
  save_eps_path = strcat(pwd, '/figures/');
elseif strcmp(system, 'amcl-icp-dft')
  return;
endif

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd';

disp('Make sure to run `script_generate_cache_errors_per_nav` first.');

w = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% H1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
errors_h1 = {};
map_name = 'corridor';

load(strcat(data_path_corridor, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h1{1} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path_corridor, map_name, '_amcl_mean_trajectory_error_batch_7_feedback_5.mat'));
errors_h1{2} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path_corridor, map_name, '_amcl_mean_trajectory_error_batch_5_feedback_5.mat'));
errors_h1{3} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% H2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = 10;
errors_h2 = {};
map_name = 'warehouse';

load(strcat(data_path_warehouse, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h2{1} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path_warehouse, map_name,  '_dft_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h2{2} = filter(ones(w,1)/w, 1, mean_trajectory_errors_dft_i);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% H3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
errors_h3 = {};
map_name = 'warehouse';

load(strcat(data_path_warehouse, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h3{1} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path_warehouse, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_4.mat'));
errors_h3{2} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colours_h1 = [0,0,0;233,163,201; 161,215,106]/255;
colours_h2 = [0,0,0; 227,74,51]/255;
colours_h3 = [0,0,0; 190,190,190]/255;
linewidth = 3;

figure(1, 'position', [1 1 500 200])
subplot(1,3,1)
hold on
plot(errors_h1{1}, 'color', [colours_h1(1,:)], 'linewidth', linewidth);
plot(errors_h1{2}, 'color', [colours_h1(2,:)], 'linewidth', linewidth);
plot(errors_h1{3}, 'color', [colours_h1(3,:)], 'linewidth', linewidth);
xlim([200 1200])
ylim([0.005 0.02])
box on
set(gca, 'xtick', [200 600 1000], 'xticklabel', {'$200$','$600$','$1000$'});
set(gca, 'ytick', [0.005 0.01 0.015 0.20], 'yticklabel', {'$0.005$','$0.010$','$0.015$', '$0.20$'});
xlabel('Αριθμός εκτιμήσεων στάσης στο χρόνο')
ylabel('Μέσο σφάλμα εκτίμησης ανά εκτιμώμενη στάση')

subplot(1,3,2)
hold on
plot(errors_h2{1}, 'color', [colours_h2(1,:)], 'linewidth', linewidth);
plot(errors_h2{2}, 'color', [colours_h2(2,:)], 'linewidth', linewidth);
box on
xlim([0 360])
ylim([0 0.10])
set(gca, 'xtick', [0 100 200 300], 'xticklabel', {'$0$','$100$','$200$','$300$'});
set(gca, 'ytick', [0.0 0.02 0.04 0.06 0.08 0.10],'yticklabel',  {'$0$','$0.02$','$0.04$','$0.06$','$0.08$','$0.10$'});

subplot(1,3,3)
hold on
plot(errors_h3{1}, ':','color', [colours_h3(1,:)], 'linewidth', linewidth);
plot(errors_h3{2}, 'color', [colours_h3(1,:)], 'linewidth', linewidth);
box on
xlim([0 360])
ylim([0 0.1])
set(gca, 'xtick', [0 100 200 300], 'xticklabel', {'$0$','$100$','$200$','$300$'});
set(gca, 'ytick', [0.0 0.02 0.04 0.06 0.08 0.10], 'yticklabel', {'$0$','$0.02$','$0.04$','$0.06$','$0.08$','$0.10$'});


img_file_h123 = strcat(save_eps_path, 'h_123.eps');
drawnow ("epslatex", img_file_h123, false)
