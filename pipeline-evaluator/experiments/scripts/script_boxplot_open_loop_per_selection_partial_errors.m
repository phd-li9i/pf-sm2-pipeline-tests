clear all
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
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-pipeline-localisation-paper/figures/results/', map_name, '/partial_errors/');
elseif strcmp(system, 'amcl-icp-dft')
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-paid-paper/figures/results/', map_name, '/partial_errors/');
endif

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/')

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts';

cached = 0;
if exist(strcat(data_path, map_name, '_error_xy_5.mat')) == 2
  load(strcat(data_path, map_name, '_error_xy_5.mat'));
  load(strcat(data_path, map_name, '_error_t_5.mat'));
  load(strcat(data_path, map_name, '_error_sizes_5.mat'));
  cached = 1;
endif



[top_most_dir_list] = dir(top_most_dir);


% For open-loop
m = 5;
if cached == 0
  disp("Generate cache first, then run me. Returning...")
  return;
else % data is cached

  base_dir = strcat(top_most_dir, top_most_dir_list(m).name);

  load(strcat(data_path, map_name, '_error_xy_', num2str(m), '.mat'))
  load(strcat(data_path, map_name, '_error_t_', num2str(m), '.mat'))
  load(strcat(data_path, map_name, '_error_sizes_', num2str(m), '.mat'))


  % Place >W next to 100%
  xy = mean_errors_xy(801:1000);
  t = mean_errors_t(801:1000);
  mean_errors_xy(401:1000) = mean_errors_xy(201:800);
  mean_errors_t(401:1000) = mean_errors_t(201:800);
  mean_errors_xy(201:400) = xy;
  mean_errors_t(201:400) = t;

  % Remove 50% simulations
  mean_errors_xy(401:600) = mean_errors_xy(601:800);
  mean_errors_xy(601:800) = mean_errors_xy(801:1000);
  mean_errors_xy(801:1000) = [];

  mean_errors_t(401:600) = mean_errors_t(601:800);
  mean_errors_t(601:800) = mean_errors_t(801:1000);
  mean_errors_t(801:1000) = [];
  sizes_(801:1000) = [];

  x_min = 0;
  x_max = 15;

  if strcmp(map_name, 'corridor') == 1

    y_min_xy = 0.0;
    y_max_xy = 0.08;
    y_min_t = 0.002;
    y_max_t = 0.012;

    y_min_xy_zoomed = 0.01;
    y_max_xy_zoomed = 0.022;
    y_min_t_zoomed = 0.0022;
    y_max_t_zoomed = 0.0067;

  endif

  if strcmp(map_name, 'warehouse') == 1


    y_min_xy = 0.025;
    y_max_xy = 0.12;
    y_min_t = 0.003;
    y_max_t = 0.025;

    y_min_xy_zoomed = 0.026;
    y_max_xy_zoomed = 0.064;
    y_min_t_zoomed = 0.003;
    y_max_t_zoomed = 0.0072;

  endif

  prop = 0.65;
  figure(1, 'position', [1 1 prop*400 prop*250])
  boxplot(mean_errors_xy, sizes_);
  grid
  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})
  axis([x_min x_max y_min_xy y_max_xy])
  title(strcat(upper(map_name), ' open-loop location errors'));
  xlabel('Pose selection method');
  img_file_amcl = strcat(save_eps_path, top_most_dir_list(m).name , '_xy_boxplot.eps');
  drawnow ("epslatex", img_file_amcl, false)

  figure(2, 'position', [1 1 prop*400 prop*250])
  boxplot(mean_errors_t, sizes_);
  grid
  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})
  axis([x_min x_max y_min_t y_max_t])
  title('Open-loop orientation errors');
  xlabel('Pose selection method');
  img_file_dft = strcat(save_eps_path, top_most_dir_list(m).name, '_t_boxplot.eps');
  drawnow ("epslatex", img_file_dft, false)

  prop = 0.65;
  figure(3, 'position', [1 1 prop*400 prop*250])
  boxplot(mean_errors_xy, sizes_);
  grid
  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})
  axis([x_min x_max y_min_xy_zoomed y_max_xy_zoomed])
  title('Open-loop location errors');
  xlabel('Pose selection method');
  img_file_amcl = strcat(save_eps_path, top_most_dir_list(m).name , '_xy_boxplot_zoomed.eps');
  drawnow ("epslatex", img_file_amcl, false)

  figure(4, 'position', [1 1 prop*400 prop*250])
  boxplot(mean_errors_t, sizes_);
  grid
  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})
  axis([x_min x_max y_min_t_zoomed y_max_t_zoomed])
  title('Open-loop orientation errors');
  xlabel('Pose selection method');
  img_file_dft = strcat(save_eps_path, top_most_dir_list(m).name, '_t_boxplot_zoomed.eps');
  drawnow ("epslatex", img_file_dft, false)
endif
