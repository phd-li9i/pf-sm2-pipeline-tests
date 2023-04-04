#! /usr/bin/octave

clear all
close all
pkg load io

if (nargin > 0)
  arg_list = argv();
  do_plot = arg_list{1}
else
  do_plot = false;
endif

P = function_load_files_to_cell_of_matrices();

% Ground truth file
gt = P{1};

% Amcl pose file
ap = P{2};

% icp-corrected file
ip = P{3};

% dft-corrected file
dp = P{4};

% execution-times file
et = P{5};

% execution times

% number of poses
Na = size(ap, 1);
Nd = size(dp, 1);

% Matrix of the difference between the amcl poses and the ground truth poses
d_a_gt = function_get_pose_error(ap, gt);

% Matrix of the difference between the icp-corrected poses and the ground truth
% poses
d_i_gt = function_get_pose_error(ip, gt);

% Matrix of the difference between the dft-corrected poses and the ground truth
% poses
d_d_gt = function_get_pose_error(dp, gt);


% Distance metrics -------------------------------------------------------------
mae_ap = function_get_mean_pose_error(d_a_gt);
mae_ip = function_get_mean_pose_error(d_i_gt);
mae_dp = function_get_mean_pose_error(d_d_gt);

% Time metrics
mean_t = mean(et);

% Total traversal time
ttt = function_convert_time(dp(end,1), dp(end,2)) - ...
      function_convert_time(dp(1,1), dp(1,2));


% Print results ----------------------------------------------------------------
fprintf('--------------------------------------------------------\n');
fprintf('Number of pipeline/amcl poses: %d/%d\n', Nd,Na);
fprintf('Mean execution time:           %d msec\n', 1000*mean_t);
fprintf('Total traversal time:          %d sec\n', ttt);
fprintf('--------------------------------------------------------\n');
fprintf('      (  MAE-x ,   MAE-y ,   MAE-d ,   MAE-θ,    MAE   )\n');
fprintf('amcl: (%f, %f, %f, %f, %f)\n', mae_ap(1), mae_ap(2), mae_ap(3), mae_ap(4), mae_ap(5));
fprintf('ICP:  (%f, %f, %f, %f, %f)\n', mae_ip(1), mae_ip(2), mae_ip(3), mae_ip(4), mae_ip(5));
fprintf('DFT:  (%f, %f, %f, %f, %f)\n', mae_dp(1), mae_dp(2), mae_dp(3), mae_dp(4), mae_dp(5));
fprintf('--------------------------------------------------------\n');

if (do_plot)
  figure(1)
  hold on
  grid on
  plot(abs(d_a_gt(:,1)), 'b')
  plot(abs(d_i_gt(:,1)), 'r')
  plot(abs(d_d_gt(:,1)), 'g')
  axis([0 size(d_a_gt,1) 0 0.1])

  figure(2)
  hold on
  grid on
  plot(abs(d_a_gt(:,2)), 'b')
  plot(abs(d_i_gt(:,2)), 'r')
  plot(abs(d_d_gt(:,2)), 'g')
  axis([0 size(d_a_gt,1) 0 0.1])

  figure(3)
  hold on
  grid on
  plot(abs(d_a_gt(:,3)), 'b')
  plot(abs(d_i_gt(:,3)), 'r')
  plot(abs(d_d_gt(:,3)), 'g')
  axis([0 size(d_a_gt,1) 0 0.01])

  figure(1,"position",get(0,"screensize"))
  figure(2,"position",get(0,"screensize"))

  pause
endif
