clear all
close all
pkg load io
pkg load statistics

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");


map_name = 'warehouse';
system = 'amcl-icp';

scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts/';

% Data (pose errors) is stored/retrieved from here
data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data/');

% Here is where the figures are stored
save_eps_path = '';
if strcmp(system, 'amcl-icp')
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-pipeline-localisation-paper/figures/results/', map_name, '/total_errors/');
elseif strcmp(system, 'amcl-icp-dft')
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-paid-paper/figures/results/', map_name, '/total_errors/');
endif

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts';

cached = 0;
if exist(strcat(data_path, map_name, '_error_3.mat')) == 2
  load(strcat(data_path, map_name, '_error_3.mat'));
  load(strcat(data_path, map_name, '_error_sizes_3.mat'));
  cached = cached + 1;
endif

if exist(strcat(data_path, map_name, '_error_4.mat')) == 2
  load(strcat(data_path, map_name, '_error_4.mat'));
  load(strcat(data_path, map_name, '_error_sizes_4.mat'));
  cached = cached + 1;
endif

if exist(strcat(data_path, map_name, '_error_5.mat')) == 2
  load(strcat(data_path, map_name, '_error_5.mat'));
  load(strcat(data_path, map_name, '_error_sizes_5.mat'));
  cached = cached + 1;
endif

if exist(strcat(data_path, map_name, '_error_6.mat')) == 2
  load(strcat(data_path, map_name, '_error_6.mat'));
  load(strcat(data_path, map_name, '_error_sizes_6.mat'));
  cached = cached + 1;
endif


[top_most_dir_list] = dir(top_most_dir);

errors_v = [];

if cached == 0
  disp('Generate cache first, then run me; returning...')
  return;
else
  for m=3:6
    base_dir = strcat(top_most_dir, top_most_dir_list(m).name);

    load(strcat(data_path, map_name, '_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_error_sizes_', num2str(m), '.mat'))

    errors_v = [errors_v, mean_errors(1:200)];

  endfor
endif

% Right now the structure in errors_v_* is
%__________________________________
%| hard | soft-50 | open | soft-1 |
%__________________________________
%
% We would like to present results as
%__________________________________
%| open | soft-1 | soft-50 | hard |
%__________________________________

errors_v_sorted = [errors_v(401:600) ...
                      errors_v(601:800) ...
                      errors_v(201:400) ...
                      errors_v(1:200)];

errors_sizes_sorted = [1*ones(1,100), 2*ones(1,100), ...
                       5*ones(1,100), 6*ones(1,100), ...
                       9*ones(1,100), 10*ones(1,100), ...
                       13*ones(1,100), 14*ones(1,100)];


x_min = 0;
x_max = 15;

if strcmp(map_name, 'corridor') == 1

  y_min = 0.008;
  y_max = 0.06;

  y_min_zoomed = 0.0105;
  y_max_zoomed = 0.0131;

endif

if strcmp(map_name, 'warehouse') == 1

  y_min = 0.02;
  y_max = 5.0;

  y_min_zoomed = 0.021;
  y_max_zoomed = 0.07;

endif

prop = 0.65;
figure(1, 'position', [1 1 prop*400 prop*250])
boxplot(errors_v_sorted, errors_sizes_sorted);
grid
set(gca,'XTick', [1.5 5.5 9.5 13.5])
set (gca, 'xticklabel', {'open', 'soft-$1$', 'soft-$50$', 'hard'})
axis([x_min x_max y_min y_max])
title(strcat(upper(map_name), ' pose errors per feedback method'));
xlabel('Feedback method');
ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');
img_file_amcl = strcat(save_eps_path, 'feedbacks_boxplot.eps');
drawnow ("epslatex", img_file_amcl, false)

%% Print zoomed-in
prop = 0.65;
figure(2, 'position', [1 1 prop*400 prop*250])
boxplot(errors_v_sorted, errors_sizes_sorted);
grid
set(gca,'XTick', [1.5 5.5 9.5 13.5])
set (gca, 'xticklabel', {'open', 'soft-$1$', 'soft-$50$', 'hard'})
axis([x_min x_max y_min_zoomed y_max_zoomed])
title(strcat(upper(map_name), ' pose errors per feedback method'));
xlabel('Feedback method');
ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');
img_file_amcl = strcat(save_eps_path, 'feedbacks_boxplot_zoomed.eps');
drawnow ("epslatex", img_file_amcl, false)
