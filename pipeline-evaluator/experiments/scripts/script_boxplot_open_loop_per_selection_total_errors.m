clear all
close all
pkg load io
pkg load statistics

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");


map_name = 'corridor';
system = 'amcl-icp';

scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts/';

% Data (pose errors) is stored/retrieved from here
data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data/');

% Here is where the figures are stored
save_eps_path = '';
if strcmp(system, 'amcl-icp')
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-pipeline-localisation-paper/figures/results/', map_name, '/total_errors/');
elseif strcmp(system, 'amcl-icp-dft')
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-paid-paper/figures/results/', map_name, '/partial_errors/');
endif

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts';

cached = 0;
if exist(strcat(data_path, map_name, '_error_5.mat')) == 2
  load(strcat(data_path, map_name, '_error_5.mat'));
  load(strcat(data_path, map_name, '_error_sizes_5.mat'));
  cached = 1;
endif



[top_most_dir_list] = dir(top_most_dir);


% For open-loop
m = 5;
if cached == 0
  disp('Generate cache first, then run me; returning...')
  return;
else % data is cached

  base_dir = strcat(top_most_dir, top_most_dir_list(m).name);

  load(strcat(data_path, map_name, '_error_', num2str(m), '.mat'))
  load(strcat(data_path, map_name, '_error_sizes_', num2str(m), '.mat'))


  % Place >W next to 100%
  xy = mean_errors(801:1000);
  mean_errors(401:1000) = mean_errors(201:800);
  mean_errors(201:400) = xy;

  % Remove 50% simulations
  mean_errors(401:600) = mean_errors(601:800);
  mean_errors(601:800) = mean_errors(801:1000);
  mean_errors(801:1000) = [];
  sizes_(801:1000) = [];

  x_min = 0;
  x_max = 15;

  if strcmp(map_name, 'corridor') == 1

    y_min = 0.005;
    y_max = 0.07;

    y_min_zoomed = 0.01;
    y_max_zoomed = 0.02;

  endif

  if strcmp(map_name, 'warehouse') == 1


    y_min = 0.025;
    y_max = 0.12;

    y_min_zoomed = 0.025;
    y_max_zoomed = 0.058;

  endif

  prop = 0.65;
  figure(1, 'position', [1 1 prop*400 prop*250])
  boxplot(mean_errors, sizes_);
  grid
  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})
  axis([x_min x_max y_min y_max])
  title(strcat(upper(map_name), ' pose errors per pose selection method'));
  xlabel('Pose selection method');
  ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');
  img_file_amcl = strcat(save_eps_path, top_most_dir_list(m).name , '_boxplot.eps');
  drawnow ("epslatex", img_file_amcl, false)

  prop = 0.65;
  figure(2, 'position', [1 1 prop*400 prop*250])
  boxplot(mean_errors, sizes_);
  grid
  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})
  axis([x_min x_max y_min_zoomed y_max_zoomed])
  title(strcat(upper(map_name), ' pose errors per pose selection method'));
  xlabel('Pose selection method');
  ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');
  img_file_amcl = strcat(save_eps_path, top_most_dir_list(m).name , '_boxplot_zoomed.eps');
  drawnow ("epslatex", img_file_amcl, false)

endif
