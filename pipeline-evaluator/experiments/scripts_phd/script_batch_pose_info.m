clear all
pkg load io

scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts';
addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts';

base_dir = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/N';
[dir_list] = dir(base_dir);

str_hline = '--------------------------------------------------------\n';
fprintf(str_hline);
if size(dir_list,1)-2 == 1
  fprintf('Found 1 batch\n')
elseif size(dir_list,1)-2 > 1
  fprintf('Found %d batches\n', size(dir_list,1)-2)
else
  fprintf('Nothing to do; returning\n')
endif
fprintf(str_hline);

% For every batch. A batch consists of N experiments
for i=3:size(dir_list,1)

  dir_name = dir_list(i).name;
  batch_dir = strcat(base_dir, '/', dir_name);
  [i_dir_exps_list] = dir(batch_dir);
  num_experiments = size(i_dir_exps_list,1)-8; % .,..,pipeline.launcher,pipeline.cpp

  if (exist(strcat(batch_dir, "/stats.csv")) == 2)
    continue;
  endif

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
  endfor

  % Compute mean, min, max for all variables
  % amcl
  mean_amcl_x = mean(mae_amcl(:,1));
  min_amcl_x = min(mae_amcl(:,1));
  max_amcl_x = max(mae_amcl(:,1));

  mean_amcl_y = mean(mae_amcl(:,2));
  min_amcl_y = min(mae_amcl(:,2));
  max_amcl_y = max(mae_amcl(:,2));

  mean_amcl_d = mean(mae_amcl(:,3));
  min_amcl_d = min(mae_amcl(:,3));
  max_amcl_d = max(mae_amcl(:,3));

  mean_amcl_theta = mean(mae_amcl(:,4));
  min_amcl_theta = min(mae_amcl(:,4));
  max_amcl_theta = max(mae_amcl(:,4));

  mean_amcl_error = mean(mae_amcl(:,5));
  min_amcl_error = min(mae_amcl(:,5));
  max_amcl_error = max(mae_amcl(:,5));

  % icp
  mean_icp_x = mean(mae_icp(:,1));
  min_icp_x = min(mae_icp(:,1));
  max_icp_x = max(mae_icp(:,1));

  mean_icp_y = mean(mae_icp(:,2));
  min_icp_y = min(mae_icp(:,2));
  max_icp_y = max(mae_icp(:,2));

  mean_icp_d = mean(mae_icp(:,3));
  min_icp_d = min(mae_icp(:,3));
  max_icp_d = max(mae_icp(:,3));

  mean_icp_theta = mean(mae_icp(:,4));
  min_icp_theta = min(mae_icp(:,4));
  max_icp_theta = max(mae_icp(:,4));

  mean_icp_error = mean(mae_icp(:,5));
  min_icp_error = min(mae_icp(:,5));
  max_icp_error = max(mae_icp(:,5));

  % dft
  mean_dft_x = mean(mae_dft(:,1));
  min_dft_x = min(mae_dft(:,1));
  max_dft_x = max(mae_dft(:,1));

  mean_dft_y = mean(mae_dft(:,2));
  min_dft_y = min(mae_dft(:,2));
  max_dft_y = max(mae_dft(:,2));

  mean_dft_d = mean(mae_dft(:,3));
  min_dft_d = min(mae_dft(:,3));
  max_dft_d = max(mae_dft(:,3));

  mean_dft_theta = mean(mae_dft(:,4));
  min_dft_theta = min(mae_dft(:,4));
  max_dft_theta = max(mae_dft(:,4));

  mean_dft_error = mean(mae_dft(:,5));
  min_dft_error = min(mae_dft(:,5));
  max_dft_error = max(mae_dft(:,5));

  mean_num_amcl_poses = mean(num_amcl_poses);
  mean_num_pipeline_poses = mean(num_pipeline_poses);

  % Compute execution times metrics
  mean_mean_t = mean(stat_t(:,1));
  mean_min_t = mean(stat_t(:,2));
  mean_max_t = mean(stat_t(:,3));
  mean_std_t = mean(stat_t(:,4));

  % Write statistics to file
  str_num_amcl_poses = strcat('# amcl poses', ',', num2str(mean_num_amcl_poses), ',', '\n\n');
  str_num_pipeline_poses = strcat('# pipeline poses', ',', num2str(mean_num_pipeline_poses), ',', '\n\n');
  str_mae = strcat('mae-x', ',', 'mae-y', ',', 'mae-d', ',', 'mae-θ', ',', 'mae', ',', 'mean_t');
  str_mae_1 = strcat('', ',', str_mae, ',', '\n');
  str_mae_2 = strcat('amcl', ',', num2str(mean_amcl_x), ',', num2str(mean_amcl_y), ',', num2str(mean_amcl_d), ',', num2str(mean_amcl_theta), ',', num2str(mean_amcl_error), ',', '\n');
  str_mae_3 = strcat('icp', ',', num2str(mean_icp_x), ',', num2str(mean_icp_y), ',', num2str(mean_icp_d), ',', num2str(mean_icp_theta), ',', num2str(mean_icp_error), ',', '\n');
  str_mae_4 = strcat('dft', ',', num2str(mean_dft_x), ',', num2str(mean_dft_y), ',', num2str(mean_dft_d), ',', num2str(mean_dft_theta), ',', num2str(mean_dft_error), ',', num2str(mean_mean_t), ',', '\n');
  str_mae_5 = '\n';
  str_mae_6 = '\n';

  str_min = strcat('min mae-x', ',', 'min mae-y', ',', 'min mae-d', ',', 'min mae-θ', ',', 'min_t');
  str_min_1 = strcat('', ',', str_min, ',', '\n');
  str_min_2 = strcat('amcl', ',', num2str(min_amcl_x), ',', num2str(min_amcl_y), ',', num2str(min_amcl_d), ',', num2str(min_amcl_theta), ',', num2str(min_amcl_error), ',', '\n');
  str_min_3 = strcat('icp', ',', num2str(min_icp_x), ',', num2str(min_icp_y), ',', num2str(min_icp_d), ',', num2str(min_icp_theta), ',', num2str(min_icp_error), ',', '\n');
  str_min_4 = strcat('dft', ',', num2str(min_dft_x), ',', num2str(min_dft_y), ',', num2str(min_icp_d), ',', num2str(min_dft_theta), ',', num2str(min_dft_error), ',', num2str(mean_min_t), ',', '\n');
  str_min_5 = '\n';
  str_min_6 = '\n';

  str_max = strcat('max mae-x', ',', 'max mae-y', ',', 'max mae-d', ',', 'max mae-θ', ',', 'max_t');
  str_max_1 = strcat('', ',', str_max, ',', '\n');
  str_max_2 = strcat('amcl', ',', num2str(max_amcl_x), ',', num2str(max_amcl_y), ',', num2str(max_amcl_d), ',', num2str(max_amcl_theta), ',', num2str(max_amcl_error), ',', '\n');
  str_max_3 = strcat('icp', ',', num2str(max_icp_x), ',', num2str(max_icp_y), ',', num2str(max_icp_d), ',', num2str(max_icp_theta), ',', num2str(max_icp_error), ',', '\n');
  str_max_4 = strcat('dft', ',', num2str(max_dft_x), ',', num2str(max_dft_y), ',', num2str(max_dft_d), ',', num2str(max_dft_theta), ',', num2str(max_dft_error), ',', num2str(mean_max_t), ',', '\n');
  str_max_5 = '\n';
  str_max_6 = '\n';

  filename = strcat(batch_dir, '/', 'stats.csv');
  fid = fopen (filename, 'w');

  fprintf (fid, str_num_amcl_poses);
  fprintf (fid, str_num_pipeline_poses);
  fprintf (fid, str_mae_1);
  fprintf (fid, str_mae_2);
  fprintf (fid, str_mae_3);
  fprintf (fid, str_mae_4);
  fprintf (fid, str_mae_5);
  fprintf (fid, str_mae_6);

  fprintf (fid, str_min_1);
  fprintf (fid, str_min_2);
  fprintf (fid, str_min_3);
  fprintf (fid, str_min_4);
  fprintf (fid, str_min_5);
  fprintf (fid, str_min_6);

  fprintf (fid, str_max_1);
  fprintf (fid, str_max_2);
  fprintf (fid, str_max_3);
  fprintf (fid, str_max_4);
  fprintf (fid, str_max_5);
  fprintf (fid, str_max_6);

  fclose (fid);


  % Print results ----------------------------------------------------------------
  fprintf(str_hline);
  fprintf('Batch %s, %d simulations\n', dir_name, num_experiments);
  fprintf(str_hline);
  fprintf('Mean number of amcl poses:     %f\n', mean_num_amcl_poses);
  fprintf('Mean number of pipeline poses: %f\n', mean_num_pipeline_poses);
  fprintf('Mean execution time:           %f ms\n', 1000*mean_t);
  fprintf(str_hline);
  fprintf('      (  MAE-x ,   MAE-y ,   MAE-d ,   MAE-θ,    MAE   )\n');
  fprintf('amcl: (%f, %f, %f, %f, %f)\n', mean_amcl_x, mean_amcl_y, mean_amcl_d, mean_amcl_theta, mean_amcl_error);
  fprintf('ICP:  (%f, %f, %f, %f, %f)\n', mean_icp_x, mean_icp_y, mean_icp_d, mean_icp_theta, mean_icp_error);
  fprintf('DFT:  (%f, %f, %f, %f, %f)\n', mean_dft_x, mean_dft_y, mean_dft_d, mean_dft_theta, mean_dft_error);
  fprintf(str_hline);
endfor

% Return to scripts' path
cd(scripts_path);
