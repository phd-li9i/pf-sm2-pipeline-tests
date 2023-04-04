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

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(map_name, 'corridor')

  % open loop
  load(strcat(data_path, map_name, '_error_xy_5.mat'));
  load(strcat(data_path, map_name, '_error_t_5.mat'));
  load(strcat(data_path, map_name, '_error_sizes_5.mat'));
  amcl_open_loop_100_xy = mean_errors_xy(1:100, 1);
  amcl_open_loop_100_t = mean_errors_t(1:100, 1);

  % hybrid-closed-loop
  load(strcat(data_path, map_name, '_error_xy_4.mat'));
  load(strcat(data_path, map_name, '_error_t_4.mat'));
  load(strcat(data_path, map_name, '_error_sizes_4.mat'));
  system_xy = mean_errors_xy(601:700, 1);
  system_t = mean_errors_t(601:700, 1);

  prop = 0.75;
  figure(1, 'position', [1 1 prop*270 prop*210])
  xy = [amcl_open_loop_100_xy; system_xy];
  g_xy = [ones(size(system_xy)); 2*ones(size(system_xy))];
  boxplot(xy,g_xy);
  grid
  axis([0.5 2.5 0.008 0.022])
  img_file_xy = strcat(save_eps_path, 'best_xy_boxplot.eps');
  drawnow ("epslatex", img_file_xy, false)

  figure(2, 'position', [1 1 prop*270 prop*210])
  t = [amcl_open_loop_100_t; system_t];
  g_t = [ones(size(system_t)); 2*ones(size(system_t))];
  boxplot(t,g_t)
  grid
  axis([0.5 2.5 0.002 0.006])
  img_file_t = strcat(save_eps_path, 'best_t_boxplot.eps');
  drawnow ("epslatex", img_file_t, false)
endif

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(map_name, 'warehouse')

  % open loop
  load(strcat(data_path, map_name, '_error_xy_5.mat'));
  load(strcat(data_path, map_name, '_error_t_5.mat'));
  load(strcat(data_path, map_name, '_error_sizes_5.mat'));
  amcl_open_loop_100_xy = mean_errors_xy(1:100, 1);
  amcl_open_loop_100_t = mean_errors_t(1:100, 1);

  % hybrid-closed-loop
  load(strcat(data_path, map_name, '_error_xy_4.mat'));
  load(strcat(data_path, map_name, '_error_t_4.mat'));
  load(strcat(data_path, map_name, '_error_sizes_4.mat'));
  system_xy = mean_errors_xy(101:200, 1);
  system_t = mean_errors_t(101:200, 1);

  prop = 0.75;
  figure(1, 'position', [1 1 prop*270 prop*210])
  xy = [amcl_open_loop_100_xy; system_xy];
  g_xy = [ones(size(system_xy)); 2*ones(size(system_xy))];
  boxplot(xy,g_xy);
  grid
  axis([0.5 2.5 0.025 0.065])
  img_file_xy = strcat(save_eps_path, 'best_xy_boxplot.eps');
  drawnow ("epslatex", img_file_xy, false)

  figure(2, 'position', [1 1 prop*270 prop*210])
  t = [amcl_open_loop_100_t; system_t];
  g_t = [ones(size(system_t)); 2*ones(size(system_t))];
  boxplot(t,g_t)
  grid
  axis([0.5 2.5 0.0025 0.008])
  img_file_t = strcat(save_eps_path, 'best_t_boxplot.eps');
  drawnow ("epslatex", img_file_t, false)
endif
