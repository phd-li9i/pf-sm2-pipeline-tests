function E = function_get_pose_error(p,gt)

  % Matrix of the difference between the poses and the ground truth poses
  E = [];
  for i=1:size(p,1)
    [gt_min_t, gt_min_dt_idx] = function_find_nearest_timestamp_pose(p(i,:), gt);

    time_p = function_convert_time(p(i,1), p(i,2));

    gt_at_time_p = [];

    if (time_p == gt_min_t)
      gt_at_time_p = gt(gt_min_dt_idx,3:end);
    else
      if (time_p < gt_min_t)
        if (gt_min_dt_idx > 1)
          gt_1 = gt(gt_min_dt_idx - 1,:);
          gt_2 = gt(gt_min_dt_idx,:);
        else
          gt_1 = gt(gt_min_dt_idx,:);
          gt_2 = gt(gt_min_dt_idx,:);
        endif
      endif

      if (time_p > gt_min_t)
        gt_1 = gt(gt_min_dt_idx,:);
        gt_2 = gt(gt_min_dt_idx + 1,:);
      endif

      if (gt_1(5) >= 0 && gt_1(5) <= pi && gt_2(5) <= 0)
        if (abs(gt_2(5)) > 1.0)
          gt_2(5) = gt_2(5) + 2*pi;
        endif
      endif

      if (gt_1(5) <= 0 && gt_2(5) >= 0 && gt_2(5) <= pi)
        if (abs(gt_2(5)) > 1.0)
          gt_1(5) = gt_1(5) + 2*pi;
        endif
      endif

      gt_at_time_p = function_interpolate_pose(gt_1, gt_2, time_p);
    endif



    dx = gt_at_time_p(1) - p(i,3);
    dy = gt_at_time_p(2) - p(i,4);

    gt_at_time_p(3) = rem(gt_at_time_p(3) + 5*pi, 2*pi) - pi;
    p(i,5) = rem(p(i,5) + 5*pi, 2*pi) - pi;

    if (gt_at_time_p(3) >= 0 && p(i,5) <= 0)

      dt = gt_at_time_p(3) + p(i,5);

    elseif (gt_at_time_p(3) <= 0 && p(i,5) >= 0)

      if (abs(gt_at_time_p) > 1.0)
        gt_at_time_p(3) = gt_at_time_p(3) + 2*pi;
      endif

      dt = gt_at_time_p(3) - p(i,5);
    else
      dt = gt_at_time_p(3) - p(i,5);
    endif



%    if (abs(dt) > 0.1)
      %i
      %gt_min_dt_idx
      %gt(gt_min_dt_idx,5)
      %gt_at_time_p(3)
      %p(i,5)
    %endif


    d_pose = [dx dy dt];
    E = [E; d_pose];
  endfor
