function t = function_convert_time(t_sec, t_nsec)
  t = t_sec + 10^(-9) * t_nsec;
