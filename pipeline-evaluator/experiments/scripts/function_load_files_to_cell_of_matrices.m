function M = function_load_files_to_cell_of_matrices()

  a = {csv2cell("../ground_truth")};
  b = {csv2cell("../amcl_pose")};
  c = {csv2cell("../icp_corrected_pose")};
  d = {csv2cell("../dft_corrected_pose")};

  ca = [a b c d];

  % Load the files into CA. CA is a cell array of matrices.
  CA = {};

  % record everything except for the header, even the second line which is
  % erroneous (it's four seconds behind the third one)
  for i = 1:size(ca,2)

    ca_loc = ca{i};

    s = ca_loc(2:end, 1);
    ns = ca_loc(2:end, 2);
    x = ca_loc(2:end, 3);
    y = ca_loc(2:end, 4);
    yaw = ca_loc(2:end, 5);

    s = cell2mat(s);
    ns = cell2mat(ns);
    x = cell2mat(x);
    y = cell2mat(y);
    yaw = cell2mat(yaw);

    ca_loc = [s ns x y yaw];

    CA = [CA ca_loc];
  endfor

  % Append execution times to CA
  e = {csv2cell("../execution_times")};
  e_loc = e{1};

  s = e_loc(2:end, 1);
  ns = e_loc(2:end, 2);
  s = cell2mat(s);
  ns = cell2mat(ns);

  T = [s ns];
  t = T(:,1) + 10^(-9) * T(:,2);

  CA = [CA t];


  M = CA;
