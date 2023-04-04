% This function finds the values of all variables  at time t_1 <= t <= t_2,
% assuming a linear connection between p_1 and p_2 between t_1 and t_2.
% p_1(1) = t_1 (sec)
% p_1(2) = t_1 (nsec)
% p_1(3) = x_1
% p_1(4) = y_1
% p_1(5) = theta_1
% p_2(1) = t_2 (sec)
% p_2(2) = t_2 (nsec)
% p_2(3) = x_2
% p_2(4) = y_2
% p_2(5) = theta_2

function p = function_interpolate_pose(p_1, p_2, t)

  ts_p_1 = function_convert_time(p_1(1), p_1(2));
  ts_p_2 = function_convert_time(p_2(1), p_2(2));

  x_int  = function_interpolate_one_variable(p_1(3), ts_p_1, p_2(3), ts_p_2, t);
  y_int  = function_interpolate_one_variable(p_1(4), ts_p_1, p_2(4), ts_p_2, t);
  th_int = function_interpolate_one_variable(p_1(5), ts_p_1, p_2(5), ts_p_2, t);

  p = [x_int, y_int, th_int];
