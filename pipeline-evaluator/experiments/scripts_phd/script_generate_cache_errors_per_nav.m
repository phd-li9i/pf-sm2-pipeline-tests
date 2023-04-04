% Caches not means but aaaaaall errors
clear all
pkg load io
pkg load statistics

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");


map_name = 'warehouse';
system = 'amcl-icp';

scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd/';

% Data (pose errors) is stored/retrieved from here
data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data_per_nav/');

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd';

%cached = 0;
%if exist(strcat(data_path, map_name, '_error_3.mat')) == 2
  %load(strcat(data_path, map_name, '_error_3.mat'));
  %load(strcat(data_path, map_name, '_error_sizes_3.mat'));
  %cached = cached + 1;
%endif

%if exist(strcat(data_path, map_name, '_error_4.mat')) == 2
  %load(strcat(data_path, map_name, '_error_4.mat'));
  %load(strcat(data_path, map_name, '_error_sizes_4.mat'));
  %cached = cached + 1;
%endif

%if exist(strcat(data_path, map_name, '_error_5.mat')) == 2
  %load(strcat(data_path, map_name, '_error_5.mat'));
  %load(strcat(data_path, map_name, '_error_sizes_5.mat'));
  %cached = cached + 1;
%endif

%if exist(strcat(data_path, map_name, '_error_6.mat')) == 2
  %load(strcat(data_path, map_name, '_error_6.mat'));
  %load(strcat(data_path, map_name, '_error_sizes_6.mat'));
  %cached = cached + 1;
%endif

%if cached == 4
  %disp("Nothing to do, returning...")
  %return;
%endif


[top_most_dir_list] = dir(top_most_dir);


% For every feedback mode
for m=3:6

  amcl_position_errors = [];
  amcl_orientation_errors = [];
  dft_position_errors = [];
  dft_orientation_errors = [];
  amcl_sizes = [];
  dft_sizes = [];

  base_dir = strcat(top_most_dir, top_most_dir_list(m).name);
  [dir_list] = dir(base_dir);


  str_hline = '--------------------------------------------------------\n';
  fprintf(str_hline);
  if size(dir_list,1)-2 == 1
    fprintf('Found 1 batch in %s\n', base_dir)
  elseif size(dir_list,1)-2 > 1
    fprintf('Found %d batches in %s\n', size(dir_list,1)-2, base_dir)
  else
    fprintf('Nothing to do; returning\n')
  endif
  fprintf(str_hline);

  co = -2;
  % For every batch. A batch consists of N experiments
  for i=3:size(dir_list,1)

    dir_name = dir_list(i).name;
    batch_dir = strcat(base_dir, '/', dir_name);
    [i_dir_exps_list] = dir(batch_dir);
    num_experiments = size(i_dir_exps_list,1)-9;


    fprintf('Processing batch %s: %d simulations\n', dir_name, num_experiments)
    fprintf(str_hline);


    mae_amcl = {};
    mae_dft = {};
    stat_t = [];
    for j=1:num_experiments
      j_exp_dir = strcat(batch_dir, '/', num2str(j));
      cd(j_exp_dir);
      fprintf('Processing simulation #%d ', j)

      % You are now at
      % ~/catkin_ws/src/pipeline_evaluator/experiments/N/batch_i/experiment_j

      a = {csv2cell('ground_truth')};
      b = {csv2cell('amcl_pose')};
      c = {csv2cell('icp_corrected_pose')};
      d = {csv2cell('dft_corrected_pose')};

      p = [a b c d];

      % Load the pose files into P. P is a cell array of matrices.
      P = {};

      for k = 1:size(p,2)

        p_loc = p{k};

        s = p_loc(2:end, 1);
        ns = p_loc(2:end, 2);
        x = p_loc(2:end, 3);
        y = p_loc(2:end, 4);
        yaw = p_loc(2:end, 5);

        s = cell2mat(s);
        ns = cell2mat(ns);
        x = cell2mat(x);
        y = cell2mat(y);
        yaw = cell2mat(yaw);

        p_loc = [s ns x y yaw];

        P = [P p_loc];
      endfor

      % Load the execution times file into T. T is a cell array of matrices.
      e = {csv2cell("execution_times")};
      e_loc = e{1};

      s = e_loc(3:end, 1);
      ns = e_loc(3:end, 2);

      s = cell2mat(s);
      ns = cell2mat(ns);

      %T = [s ns];

      %%% Files are now loaded. Commence calculations
      % Ground truth file
      gt = P{1};

      % Amcl pose file
      ap = P{2};

      % icp-corrected file
      ip = P{3};

      % dft-corrected file
      dp = P{4};

      % Matrix of the difference between the amcl poses and the ground truth poses
      d_a_gt = function_get_pose_error(ap, gt);

      % Matrix of the difference between the dft-corrected poses and the ground
      % truth poses
      d_d_gt = function_get_pose_error(dp, gt);


      % Pose metrics for j-th navigation in batch i ----------------------------
      mae_amcl{j} = norm(d_a_gt, [], 'rows');
      mae_dft{j} = norm(d_d_gt, [], 'rows');

      fprintf('... Done\n')
    endfor % end for 1 batch (1 selection method)

    min_size_amcl = 10^10;
    min_size_dft = 10^10;
    for k = 1:size(mae_amcl,2)

      if numel(mae_amcl{k}) < min_size_amcl
        min_size_amcl = numel(mae_amcl{k});
      end
      if numel(mae_dft{k}) < min_size_dft
        min_size_dft = numel(mae_dft{k});
      end

    end

    % Calculcate means
    mean_trajectory_errors_amcl_i = 0;
    mean_trajectory_errors_dft_i = 0;
    for k = 1:size(mae_amcl,2)
      mean_trajectory_errors_amcl_i = mean_trajectory_errors_amcl_i + mae_amcl{k}(1:min_size_amcl);
      mean_trajectory_errors_dft_i = mean_trajectory_errors_dft_i + mae_dft{k}(1:min_size_dft);
    end

    mean_trajectory_errors_amcl_i = mean_trajectory_errors_amcl_i / size(mae_amcl,2);
    mean_trajectory_errors_dft_i = mean_trajectory_errors_dft_i / size(mae_dft,2);

    % Calculcate medians
    %mean_trajectory_errors_amcl_i = [];
    %mean_trajectory_errors_dft_i = [];
    %for k = 1:size(mae_amcl,2)
      %mean_trajectory_errors_amcl_i = [mean_trajectory_errors_amcl_i, mae_amcl{k}(1:min_size_amcl)];
      %mean_trajectory_errors_dft_i = [mean_trajectory_errors_dft_i, mae_dft{k}(1:min_size_dft)];
    %end

    %mean_trajectory_errors_amcl_i = median(mean_trajectory_errors_amcl_i,2);
    %mean_trajectory_errors_dft_i = median(mean_trajectory_errors_dft_i,2);

    % save to file
    amcl_trajectory_errors_file = strcat(data_path, map_name, '_amcl_mean_trajectory_error_batch_', num2str(i), '_feedback_', num2str(m), '.mat');
    dft_trajectory_errors_file = strcat(data_path, map_name, '_dft_mean_trajectory_error_batch_', num2str(i), '_feedback_', num2str(m), '.mat');


    save(amcl_trajectory_errors_file, varname(mean_trajectory_errors_amcl_i));
    save(dft_trajectory_errors_file , varname(mean_trajectory_errors_dft_i));

  endfor % end for one mode of feedback



  % Return to scripts' path
  cd(scripts_path);

endfor % end for mode of feedback
