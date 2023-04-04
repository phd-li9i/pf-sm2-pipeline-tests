clear all
close all
pkg load io
pkg load statistics

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");


map_name = 'corridor';
system = 'amcl-icp';

scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd/';

% Data (pose errors) is stored/retrieved from here
data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data_per_nav/medians/');

% Here is where the figures are stored
save_eps_path = '';
if strcmp(system, 'amcl-icp')
  save_eps_path = strcat(pwd, '/figures/');
elseif strcmp(system, 'amcl-icp-dft')
  return;
endif

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd';

disp('Make sure to run `script_generate_cache_errors_per_nav` first.');

w = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% H1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
errors_h1 = {};

load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h1{1} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_7_feedback_5.mat'));
errors_h1{2} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_5_feedback_5.mat'));
errors_h1{3} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_6_feedback_5.mat'));
errors_h1{4} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% H2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
errors_h2 = {};

load(strcat(data_path, map_name, '_dft_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h2{1} = filter(ones(w,1)/w, 1, mean_trajectory_errors_dft_i);
load(strcat(data_path, map_name, '_dft_mean_trajectory_error_batch_7_feedback_5.mat'));
errors_h2{2} = filter(ones(w,1)/w, 1, mean_trajectory_errors_dft_i);
load(strcat(data_path, map_name, '_dft_mean_trajectory_error_batch_5_feedback_5.mat'));
errors_h2{3} = filter(ones(w,1)/w, 1, mean_trajectory_errors_dft_i);
load(strcat(data_path, map_name, '_dft_mean_trajectory_error_batch_6_feedback_5.mat'));
errors_h2{4} = filter(ones(w,1)/w, 1, mean_trajectory_errors_dft_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h2{5} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_7_feedback_5.mat'));
errors_h2{6} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_5_feedback_5.mat'));
errors_h2{7} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_6_feedback_5.mat'));
errors_h2{8} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% H3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
errors_h3 = {};

load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_5.mat'));
errors_h3{1} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_6.mat'));
errors_h3{2} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_4.mat'));
errors_h3{3} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);
load(strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_3_feedback_3.mat'));
errors_h3{4} = filter(ones(w,1)/w, 1, mean_trajectory_errors_amcl_i);

sizes_h3 = [size(errors_h3{1},1), size(errors_h3{2},1), size(errors_h3{3},1), size(errors_h3{4},1)];
size_h3_min = min(sizes_h3);
size_h3_max = size(errors_h3{4},1);
usf = floor(size_h3_max/size_h3_min);

errors_h3_4_new = [];
for i = 1:usf:size_h3_max
  errors_h3_4_new = [errors_h3_4_new; errors_h3{4}(i)];
end
errors_h3{4} = errors_h3_4_new;






colours = [0,0,0; 228,26,28; 55,126,184; 77,175,74]/255;
colours = [0,0,0;233,163,201; 161,215,106]/255;
linewidth = 2;

figure(1, 'position', [1 1 150 200])
hold on
plot(errors_h1{1}, 'color', [colours(1,:)], 'linewidth', linewidth);
plot(errors_h1{2}, 'color', [colours(2,:)], 'linewidth', linewidth);
plot(errors_h1{3}, 'color', [colours(3,:)], 'linewidth', linewidth);
%plot(errors_h1{4}, 'color', [colours(4,:)], 'linewidth', linewidth);
xlim([200 1200])
ylim([0.005 0.02])
box on
set(gca, 'xtick', [200 600 1000], 'xticklabel', {'$200$','$600$','$1000$'});
set(gca, 'ytick', [0.005 0.01 0.015 0.20], 'xticklabel', {'$0.005$','$0.010$','$0.015$', '$0.20$'});
xlabel('Αριθμός εκτιμήσεων στάσης στο χρόνο')
ylabel('Μέσο σφάλμα εκτίμησης ανά εκτιμώμενη στάση')


img_file_h1 = strcat(save_eps_path, map_name, '_h1.eps');
drawnow ("epslatex", img_file_h1, false)

figure(2, 'position', [1 1 250 200])
hold on
plot(errors_h2{1}, 'color', [colours(1,:)]);
plot(errors_h2{5}, 'color', 'k');

img_file_h2 = strcat(save_eps_path, map_name, '_h2_100.eps');
drawnow ("epslatex", img_file_h2, false)

figure(3, 'position', [1 1 250 200])
hold on
plot(errors_h2{2}, 'color', [colours(2,:)]);
plot(errors_h2{6}, 'color', 'k');

img_file_h2 = strcat(save_eps_path, map_name, '_h2_W.eps');
drawnow ("epslatex", img_file_h2, false)

figure(4, 'position', [1 1 250 200])
hold on
plot(errors_h2{3}, 'color', [colours(3,:)]);
plot(errors_h2{7}, 'color', 'k');

img_file_h2 = strcat(save_eps_path, map_name, '_h2_10.eps');
drawnow ("epslatex", img_file_h2, false)

figure(5, 'position', [1 1 250 200])
hold on
plot(errors_h2{4}, 'color', [colours(4,:)]);
plot(errors_h2{8}, 'color', 'k');

img_file_h2 = strcat(save_eps_path, map_name, '_h2_top.eps');
drawnow ("epslatex", img_file_h2, false)

figure(6, 'position', [1 1 250 200])
hold on
plot(errors_h3{1}, 'color', [colours(1,:)]);
plot(errors_h3{2}, 'color', [colours(2,:)]);
plot(errors_h3{3}, 'color', [colours(3,:)]);
plot(errors_h3{4}, 'color', [colours(4,:)]);

img_file_h3 = strcat(save_eps_path, map_name, '_h3.eps');
drawnow ("epslatex", img_file_h3, false)
