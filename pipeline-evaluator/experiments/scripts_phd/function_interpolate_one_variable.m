% This function finds the value of a variable v at time t in [t_1, t_2]
% assuming a linear connection between v_1 and v_2 between t_1 and t_2.
function v = function_interpolate_one_variable(v_1, t_1, v_2, t_2, t)

  if (t_1 == t_2)
    v = v_1;
  else
    v = v_1 + (v_2 - v_1) / (t_2 - t_1) * (t - t_1);
  endif
