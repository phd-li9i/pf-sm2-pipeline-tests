function percents = e_function_barchart_percent_improvement_per_feedback()
  pkg load io
  pkg load statistics

  graphics_toolkit("gnuplot")
  warning("off","print:missing_fig2dev");
  warning("off","print:missing_epstool");


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CORRIDOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  map_name = 'corridor';
  system = 'amcl-icp';

  scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd/';

  % Data (pose errors) is stored/retrieved from here
  data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data_not_means/');

  % Here is where the figures are stored
  save_eps_path = strcat(pwd, '/barcharts/');

  % Batches are stored here
  top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

  addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd';

  [top_most_dir_list] = dir(top_most_dir);

  amcl_errors_c = {};
  dft_errors_c = {};

  for m=3:6
    base_dir = strcat(top_most_dir, top_most_dir_list(m).name);

    load(strcat(data_path, map_name, '_amcl_orientation_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_amcl_position_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_amcl_error_sizes_', num2str(m), '.mat'))

    load(strcat(data_path, map_name, '_dft_orientation_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_dft_position_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_dft_error_sizes_', num2str(m), '.mat'))


    % Identify only those for selection = 100%
    amcl_orientation_errors_c = nonzeros(amcl_orientation_errors .* (amcl_sizes == 1))';
    amcl_position_errors_c = nonzeros(amcl_position_errors .* (amcl_sizes == 1))';

    dft_orientation_errors_c = nonzeros(dft_orientation_errors .* (dft_sizes == 1))';
    dft_position_errors_c = nonzeros(dft_position_errors .* (dft_sizes == 1))';

    min_size = min([size(amcl_orientation_errors_c,2), ...
                    size(amcl_position_errors_c,2),    ...
                    size(dft_orientation_errors_c,2),  ...
                    size(dft_position_errors_c,2)]);

    amcl_orientation_errors_c = amcl_orientation_errors_c(1:min_size);
    amcl_position_errors_c = amcl_position_errors_c(1:min_size);
    dft_orientation_errors_c = dft_orientation_errors_c(1:min_size);
    dft_position_errors_c = dft_position_errors_c(1:min_size);

    amcl_errors_c{m} = sqrt(amcl_orientation_errors_c.^2 + amcl_position_errors_c.^2);
    dft_errors_c{m} = sqrt(dft_orientation_errors_c.^2 + dft_position_errors_c.^2);


  endfor


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WAREHOUSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  map_name = 'warehouse';
  system = 'amcl-icp';

  % Data (pose errors) is stored/retrieved from here
  data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data_not_means/');

  % Here is where the figures are stored
  save_eps_path = strcat(pwd, '/barcharts/');

  % Batches are stored here
  top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

  addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd';

  [top_most_dir_list] = dir(top_most_dir);

  amcl_errors_w = {};
  dft_errors_w = {};

  for m=3:6
    base_dir = strcat(top_most_dir, top_most_dir_list(m).name);

    load(strcat(data_path, map_name, '_amcl_orientation_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_amcl_position_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_amcl_error_sizes_', num2str(m), '.mat'))

    load(strcat(data_path, map_name, '_dft_orientation_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_dft_position_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_dft_error_sizes_', num2str(m), '.mat'))


    % Identify only those for selection = 100%
    amcl_orientation_errors_w = nonzeros(amcl_orientation_errors .* (amcl_sizes == 1))';
    amcl_position_errors_w = nonzeros(amcl_position_errors .* (amcl_sizes == 1))';

    dft_orientation_errors_w = nonzeros(dft_orientation_errors .* (dft_sizes == 1))';
    dft_position_errors_w = nonzeros(dft_position_errors .* (dft_sizes == 1))';

    min_size = min([size(amcl_orientation_errors_w,2), ...
                    size(amcl_position_errors_w,2),    ...
                    size(dft_orientation_errors_w,2),  ...
                    size(dft_position_errors_w,2)]);

    amcl_orientation_errors_w = amcl_orientation_errors_w(1:min_size);
    amcl_position_errors_w = amcl_position_errors_w(1:min_size);
    dft_orientation_errors_w = dft_orientation_errors_w(1:min_size);
    dft_position_errors_w = dft_position_errors_w(1:min_size);

    amcl_errors_w{m} = sqrt(amcl_orientation_errors_w.^2 + amcl_position_errors_w.^2);
    dft_errors_w{m} = sqrt(dft_orientation_errors_w.^2 + dft_position_errors_w.^2);

  endfor


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOTH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % For a valid basis of comparison; corridor
  min_size_c = min([size(amcl_errors_c{3},2),  ...
                    size(amcl_errors_c{4},2),  ...
                    size(amcl_errors_c{5},2),  ...
                    size(amcl_errors_c{6},2)]);

  usf = floor(size(amcl_errors_c{3},2)/min_size_c);

  amcl_errors_c_3_new = [];
  for i = 1:usf:size(amcl_errors_c{3},2)
    amcl_errors_c_3_new = [amcl_errors_c_3_new, amcl_errors_c{3}(i)];
  end
  amcl_errors_c{3} = amcl_errors_c_3_new;

  amcl_errors_c{3} = amcl_errors_c{3}(1:min_size_c);
  amcl_errors_c{4} = amcl_errors_c{4}(1:min_size_c);
  amcl_errors_c{5} = amcl_errors_c{5}(1:min_size_c);
  amcl_errors_c{6} = amcl_errors_c{6}(1:min_size_c);

  % For a valid basis of comparison; warehouse
  min_size_w = min([size(amcl_errors_w{3},2),  ...
                    size(amcl_errors_w{4},2),  ...
                    size(amcl_errors_w{5},2),  ...
                    size(amcl_errors_w{6},2)]);

  usf = floor(size(amcl_errors_w{3},2)/min_size_w);

  amcl_errors_w_3_new = [];
  for i = 1:usf:size(amcl_errors_w{3},2)
    amcl_errors_w_3_new = [amcl_errors_w_3_new, amcl_errors_w{3}(i)];
  end
  amcl_errors_w{3} = amcl_errors_w_3_new;

  amcl_errors_w{3} = amcl_errors_w{3}(1:min_size_w);
  amcl_errors_w{4} = amcl_errors_w{4}(1:min_size_w);
  amcl_errors_w{5} = amcl_errors_w{5}(1:min_size_w);
  amcl_errors_w{6} = amcl_errors_w{6}(1:min_size_w);


  % Bring them both in a single vector
  amcl_errors{3} = [amcl_errors_c{3}, amcl_errors_w{3}];
  amcl_errors{4} = [amcl_errors_c{4}, amcl_errors_w{4}];
  amcl_errors{5} = [amcl_errors_c{5}, amcl_errors_w{5}];
  amcl_errors{6} = [amcl_errors_c{6}, amcl_errors_w{6}];



  % Right now the structure in *_errors is
  %__________________________________
  %| hard | soft-50 | open | soft-1 |
  %__________________________________
  %
  % We would like to present results as
  %__________________________________
  %| open | soft-1 | soft-50 | hard |
  %__________________________________

  errors = {amcl_errors{5}, amcl_errors{6}, amcl_errors{4}, amcl_errors{3}};
  percents = {...
              nnz(errors{2} <= errors{1})/numel(errors{1}),
              nnz(errors{3} <= errors{1})/numel(errors{1}),
              nnz(errors{4} <= errors{1})/numel(errors{1})};
end
