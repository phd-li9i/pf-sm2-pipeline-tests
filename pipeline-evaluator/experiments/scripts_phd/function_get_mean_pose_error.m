function E = function_get_mean_pose_error(e)

  mae_distance_gt_x = mean(abs(e(:,1)));
  mae_distance_gt_y = mean(abs(e(:,2)));
  distance_gt = sqrt(e(:,1).^2 + e(:,2).^2);
  mae_distance_gt = mean(distance_gt);
  mae_yaw_gt = mean(abs(e(:,3)));
  all = sqrt(e(:,1).^2 + e(:,2).^2 + e(:,3).^2);
  mae_all = mean(all);

  E = [mae_distance_gt_x mae_distance_gt_y mae_distance_gt mae_yaw_gt mae_all];
