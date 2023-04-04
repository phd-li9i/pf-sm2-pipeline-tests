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
if exist(strcat(data_path, map_name, '_error_xy_3.mat')) == 2
  load(strcat(data_path, map_name, '_error_xy_3.mat'));
  load(strcat(data_path, map_name, '_error_t_3.mat'));
  load(strcat(data_path, map_name, '_error_sizes_3.mat'));
endif

if exist(strcat(data_path, map_name, '_error_xy_4.mat')) == 2
  load(strcat(data_path, map_name, '_error_xy_4.mat'));
  load(strcat(data_path, map_name, '_error_t_4.mat'));
  load(strcat(data_path, map_name, '_error_sizes_4.mat'));
endif

if exist(strcat(data_path, map_name, '_error_xy_5.mat')) == 2
  load(strcat(data_path, map_name, '_error_xy_5.mat'));
  load(strcat(data_path, map_name, '_error_t_5.mat'));
  load(strcat(data_path, map_name, '_error_sizes_5.mat'));
endif

if exist(strcat(data_path, map_name, '_error_xy_6.mat')) == 2
  load(strcat(data_path, map_name, '_error_xy_6.mat'));
  load(strcat(data_path, map_name, '_error_t_6.mat'));
  load(strcat(data_path, map_name, '_error_sizes_6.mat'));
  cached = 1;
endif



[top_most_dir_list] = dir(top_most_dir);


if cached == 0

  % For every feedback mode
  for m=3:6

    mean_errors_xy = [];
    mean_errors_t = [];
    sizes_ = [];

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


      mae_amcl = [];
      mae_icp = [];
      mae_dft = [];
      num_amcl_poses = [];
      num_pipeline_poses = [];
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

        T = [s ns];

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

        % Matrix of the difference between the icp-corrected poses and the ground
        % truth poses
        d_i_gt = function_get_pose_error(ip, gt);

        % Matrix of the difference between the dft-corrected poses and the ground
        % truth poses
        d_d_gt = function_get_pose_error(dp, gt);


        t = T(:,1) + 10^(-9) * T(:,2);


        % Pose metrics -------------------------------------------------------------
        mae_ap = function_get_mean_pose_error(d_a_gt);
        mae_ip = function_get_mean_pose_error(d_i_gt);
        mae_dp = function_get_mean_pose_error(d_d_gt);
        num_ap = size(ap(2:end,:),1);
        num_dp = size(dp(2:end,:),1);

        mae_amcl = [mae_amcl; mae_ap];
        mae_icp = [mae_icp; mae_ip];
        mae_dft = [mae_dft; mae_dp];
        num_amcl_poses = [num_amcl_poses num_ap];
        num_pipeline_poses = [num_pipeline_poses num_dp];

        % Execution time metrics ---------------------------------------------------
        mean_t = mean(t);
        min_t = min(t);
        max_t = max(t);
        std_t = std(t);
        stat_t = [stat_t; mean_t min_t max_t std_t];

        fprintf('... Done\n')
      endfor % end for 1 batch

      mean_amcl_xy_error = mae_amcl(:,3);
      mean_dft_xy_error = mae_dft(:,3);

      mean_amcl_t_error = mae_amcl(:,4);
      mean_dft_t_error = mae_dft(:,4);

      mean_errors_xy = [mean_errors_xy; mean_amcl_xy_error; mean_dft_xy_error];
      mean_errors_t = [mean_errors_t; mean_amcl_t_error; mean_dft_t_error];

      sizes_ = [sizes_; (3*(i-2) + co) * ones(size(mean_amcl_xy_error)); (3*(i-2) + co+1) * ones(size(mean_dft_xy_error))];
      co = co + 1;

      % Compute execution times metrics
      %mean_mean_t = mean(stat_t(:,1));
      %mean_min_t = mean(stat_t(:,2));
      %mean_max_t = mean(stat_t(:,3));
      %mean_std_t = mean(stat_t(:,4));

    endfor % end for one mode of feedback

    % save to file
    errors_xy_file = strcat(data_path, map_name, '_error_xy_', num2str(m), '.mat');
    errors_t_file = strcat(data_path, map_name, '_error_t_', num2str(m), '.mat');
    errors_sizes_file = strcat(data_path, map_name, '_error_sizes_', num2str(m), '.mat');

    save(errors_xy_file, varname(mean_errors_xy));
    save(errors_t_file, varname(mean_errors_t));
    save(errors_sizes_file, varname(sizes_));

    % Return to scripts' path
    cd(scripts_path);

  endfor % end for mode of feedback
else

  for m=3:6
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


    if strcmp(map_name, 'corridor') == 1
      x_min = 0;
      x_max = 19;

      % hard-closed loop
      if (m == 3)
        y_min_xy = 0.009;
        y_max_xy = 0.014;
        y_min_t = 0.002;
        y_max_t = 0.007;
      endif

      % hybrid-closed loop
      if (m == 4)
        y_min_xy = 0.0095;
        y_max_xy = 0.0135;
        y_min_t = 0.002;
        y_max_t = 0.006;
      endif

      % open-loop
      if (m == 5)
        y_min_xy = 0.0;
        y_max_xy = 0.08;
        y_min_t = 0.002;
        y_max_t = 0.012;
      endif

      % soft
      if (m == 6)
        y_min_xy = 0.009;
        y_max_xy = 0.014;
        y_min_t = 0.0025;
        y_max_t = 0.006;
      endif
    endif

    if strcmp(map_name, 'warehouse') == 1
      x_min = 0;
      x_max = 19;

      % hard-closed loop
      if (m == 3)
        y_min_xy = 0.0;
        y_max_xy = 7.00;
        y_min_t = 0.0;
        y_max_t = 0.8;
      endif

      % hybrid-closed loop
      if (m == 4)
        y_min_xy = 0.025;
        y_max_xy = 0.05;
        y_min_t = 0.002;
        y_max_t = 0.012;
      endif

      % open-loop
      if (m == 5)
        y_min_xy = 0.025;
        y_max_xy = 0.12;
        y_min_t = 0.003;
        y_max_t = 0.025;
      endif

      % soft
      if (m == 6)
        y_min_xy = 0.02;
        y_max_xy = 0.2;
        y_min_t = 0.0;
        y_max_t = 0.09;
      endif
    endif

    prop = 0.65;
    figure(1, 'position', [1 1 prop*400 prop*180])
    boxplot(mean_errors_xy, sizes_);
    grid
    set(gca,'XTick', [1.5 5.5 9.5 13.5])
    axis([x_min x_max y_min_xy y_max_xy])
    img_file_amcl = strcat(save_eps_path, top_most_dir_list(m).name , '_xy_boxplot.eps')
    drawnow ("epslatex", img_file_amcl, false)

    figure(2, 'position', [1 1 prop*400 prop*180])
    boxplot(mean_errors_t, sizes_);
    grid
    set(gca,'XTick', [1.5 5.5 9.5 13.5])
    axis([x_min x_max y_min_t y_max_t])
    img_file_dft = strcat(save_eps_path, top_most_dir_list(m).name, '_t_boxplot.eps');
    drawnow ("epslatex", img_file_dft, false)
  endfor
endif
