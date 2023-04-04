function [min_ts, min_idx] = function_find_nearest_timestamp_pose(pose, ground_truth_logfile)

  % The pose's timestamp converted to seconds.fractional
  ts_p = pose(1) + 10^(-9) * pose(2);

  % The logfile poses' timestamp converted to seconds.fractional
  ts_gt = ground_truth_logfile(:,1) + 10^(-9) * ground_truth_logfile(:,2);

  % Subtract the former from the latter ...
  d_ts = abs(ts_gt - ts_p);

  % ... and find the index of the minimum time difference
  [~, min_idx] = min(min(d_ts,[],2));

  min_ts = ts_gt(min_idx);
