function percents = e_function_barchart_percent_improvement_smsm()
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


  base_dir = strcat(top_most_dir, top_most_dir_list(5).name);

  load(strcat(data_path, map_name, '_amcl_orientation_error_5.mat'));
  load(strcat(data_path, map_name, '_amcl_position_error_5.mat'));
  load(strcat(data_path, map_name, '_amcl_error_sizes_5.mat'));

  load(strcat(data_path, map_name, '_dft_orientation_error_5.mat'));
  load(strcat(data_path, map_name, '_dft_position_error_5.mat'));
  load(strcat(data_path, map_name, '_dft_error_sizes_5.mat'));

  % Right now the structure in *_errors is
  %__________________________________
  %| 100 | 50 | 10 | top | >W
  %__________________________________
  %
  % We would like to present results as
  %__________________________________
  %| 100 | >W | 10 | top |
  %__________________________________


  % Identify only those for selection = 100% | >W | 10 | top
  amcl_orientation_errors_c{1} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 1))';
  amcl_orientation_errors_c{3} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 9))';
  amcl_orientation_errors_c{4} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 13))';
  amcl_orientation_errors_c{2} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 17))';

  amcl_position_errors_c{1} = nonzeros(amcl_position_errors .* (amcl_sizes == 1))';
  amcl_position_errors_c{3} = nonzeros(amcl_position_errors .* (amcl_sizes == 9))';
  amcl_position_errors_c{4} = nonzeros(amcl_position_errors .* (amcl_sizes == 13))';
  amcl_position_errors_c{2} = nonzeros(amcl_position_errors .* (amcl_sizes == 17))';

  dft_orientation_errors_c{1} = nonzeros(dft_orientation_errors .* (dft_sizes == 1))';
  dft_orientation_errors_c{3} = nonzeros(dft_orientation_errors .* (dft_sizes == 9))';
  dft_orientation_errors_c{4} = nonzeros(dft_orientation_errors .* (dft_sizes == 13))';
  dft_orientation_errors_c{2} = nonzeros(dft_orientation_errors .* (dft_sizes == 17))';

  dft_position_errors_c{1} = nonzeros(dft_position_errors .* (dft_sizes == 1))';
  dft_position_errors_c{3} = nonzeros(dft_position_errors .* (dft_sizes == 9))';
  dft_position_errors_c{4} = nonzeros(dft_position_errors .* (dft_sizes == 13))';
  dft_position_errors_c{2} = nonzeros(dft_position_errors .* (dft_sizes == 17))';


  min_size = min([size(amcl_orientation_errors_c{1},2), ...
                  size(amcl_position_errors_c{1},2),    ...
                  size(amcl_orientation_errors_c{2},2), ...
                  size(amcl_position_errors_c{2},2),    ...
                  size(amcl_orientation_errors_c{3},2), ...
                  size(amcl_position_errors_c{3},2),    ...
                  size(amcl_orientation_errors_c{4},2), ...
                  size(amcl_position_errors_c{4},2),    ...
                  size(dft_orientation_errors_c{1},2),  ...
                  size(dft_position_errors_c{1},2),     ...
                  size(dft_orientation_errors_c{2},2),  ...
                  size(dft_position_errors_c{2},2),     ...
                  size(dft_orientation_errors_c{3},2),  ...
                  size(dft_position_errors_c{3},2),     ...
                  size(dft_orientation_errors_c{4},2),  ...
                  size(dft_position_errors_c{4},2)]);

  amcl_orientation_errors_c{1} = amcl_orientation_errors_c{1}(1:min_size);
  amcl_position_errors_c{1} = amcl_position_errors_c{1}(1:min_size);
  amcl_orientation_errors_c{2} = amcl_orientation_errors_c{2}(1:min_size);
  amcl_position_errors_c{2} = amcl_position_errors_c{2}(1:min_size);
  amcl_orientation_errors_c{3} = amcl_orientation_errors_c{3}(1:min_size);
  amcl_position_errors_c{3} = amcl_position_errors_c{3}(1:min_size);
  amcl_orientation_errors_c{4} = amcl_orientation_errors_c{4}(1:min_size);
  amcl_position_errors_c{4} = amcl_position_errors_c{4}(1:min_size);

  amcl_errors_c{1} = sqrt(amcl_orientation_errors_c{1}.^2 + amcl_position_errors_c{1}.^2);
  amcl_errors_c{2} = sqrt(amcl_orientation_errors_c{2}.^2 + amcl_position_errors_c{2}.^2);
  amcl_errors_c{3} = sqrt(amcl_orientation_errors_c{3}.^2 + amcl_position_errors_c{3}.^2);
  amcl_errors_c{4} = sqrt(amcl_orientation_errors_c{4}.^2 + amcl_position_errors_c{4}.^2);


  dft_orientation_errors_c{1} = dft_orientation_errors_c{1}(1:min_size);
  dft_position_errors_c{1} = dft_position_errors_c{1}(1:min_size);
  dft_orientation_errors_c{2} = dft_orientation_errors_c{2}(1:min_size);
  dft_position_errors_c{2} = dft_position_errors_c{2}(1:min_size);
  dft_orientation_errors_c{3} = dft_orientation_errors_c{3}(1:min_size);
  dft_position_errors_c{3} = dft_position_errors_c{3}(1:min_size);
  dft_orientation_errors_c{4} = dft_orientation_errors_c{4}(1:min_size);
  dft_position_errors_c{4} = dft_position_errors_c{4}(1:min_size);

  dft_errors_c{1} = sqrt(dft_orientation_errors_c{1}.^2 + dft_position_errors_c{1}.^2);
  dft_errors_c{2} = sqrt(dft_orientation_errors_c{2}.^2 + dft_position_errors_c{2}.^2);
  dft_errors_c{3} = sqrt(dft_orientation_errors_c{3}.^2 + dft_position_errors_c{3}.^2);
  dft_errors_c{4} = sqrt(dft_orientation_errors_c{4}.^2 + dft_position_errors_c{4}.^2);



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WAREHOUSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  map_name = 'warehouse';
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


  base_dir = strcat(top_most_dir, top_most_dir_list(5).name);

  load(strcat(data_path, map_name, '_amcl_orientation_error_5.mat'));
  load(strcat(data_path, map_name, '_amcl_position_error_5.mat'));
  load(strcat(data_path, map_name, '_amcl_error_sizes_5.mat'));

  load(strcat(data_path, map_name, '_dft_orientation_error_5.mat'));
  load(strcat(data_path, map_name, '_dft_position_error_5.mat'));
  load(strcat(data_path, map_name, '_dft_error_sizes_5.mat'));


  % Right now the structure in *_errors is
  %__________________________________
  %| 100 | 50 | 10 | top | >W
  %__________________________________
  %
  % We would like to present results as
  %__________________________________
  %| 100 | >W | 10 | top |
  %__________________________________


  % Identify only those for selection = 100% | >W | 10 | top
  amcl_orientation_errors_w{1} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 1))';
  amcl_orientation_errors_w{3} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 9))';
  amcl_orientation_errors_w{4} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 13))';
  amcl_orientation_errors_w{2} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 17))';

  amcl_position_errors_w{1} = nonzeros(amcl_position_errors .* (amcl_sizes == 1))';
  amcl_position_errors_w{3} = nonzeros(amcl_position_errors .* (amcl_sizes == 9))';
  amcl_position_errors_w{4} = nonzeros(amcl_position_errors .* (amcl_sizes == 13))';
  amcl_position_errors_w{2} = nonzeros(amcl_position_errors .* (amcl_sizes == 17))';

  dft_orientation_errors_w{1} = nonzeros(dft_orientation_errors .* (dft_sizes == 1))';
  dft_orientation_errors_w{3} = nonzeros(dft_orientation_errors .* (dft_sizes == 9))';
  dft_orientation_errors_w{4} = nonzeros(dft_orientation_errors .* (dft_sizes == 13))';
  dft_orientation_errors_w{2} = nonzeros(dft_orientation_errors .* (dft_sizes == 17))';

  dft_position_errors_w{1} = nonzeros(dft_position_errors .* (dft_sizes == 1))';
  dft_position_errors_w{3} = nonzeros(dft_position_errors .* (dft_sizes == 9))';
  dft_position_errors_w{4} = nonzeros(dft_position_errors .* (dft_sizes == 13))';
  dft_position_errors_w{2} = nonzeros(dft_position_errors .* (dft_sizes == 17))';


  min_size = min([size(amcl_orientation_errors_w{1},2), ...
                  size(amcl_position_errors_w{1},2),    ...
                  size(amcl_orientation_errors_w{2},2), ...
                  size(amcl_position_errors_w{2},2),    ...
                  size(amcl_orientation_errors_w{3},2), ...
                  size(amcl_position_errors_w{3},2),    ...
                  size(amcl_orientation_errors_w{4},2), ...
                  size(amcl_position_errors_w{4},2),    ...
                  size(dft_orientation_errors_w{1},2),  ...
                  size(dft_position_errors_w{1},2),     ...
                  size(dft_orientation_errors_w{2},2),  ...
                  size(dft_position_errors_w{2},2),     ...
                  size(dft_orientation_errors_w{3},2),  ...
                  size(dft_position_errors_w{3},2),     ...
                  size(dft_orientation_errors_w{4},2),  ...
                  size(dft_position_errors_w{4},2)]);

  amcl_orientation_errors_w{1} = amcl_orientation_errors_w{1}(1:min_size);
  amcl_position_errors_w{1} = amcl_position_errors_w{1}(1:min_size);
  amcl_orientation_errors_w{2} = amcl_orientation_errors_w{2}(1:min_size);
  amcl_position_errors_w{2} = amcl_position_errors_w{2}(1:min_size);
  amcl_orientation_errors_w{3} = amcl_orientation_errors_w{3}(1:min_size);
  amcl_position_errors_w{3} = amcl_position_errors_w{3}(1:min_size);
  amcl_orientation_errors_w{4} = amcl_orientation_errors_w{4}(1:min_size);
  amcl_position_errors_w{4} = amcl_position_errors_w{4}(1:min_size);

  amcl_errors_w{1} = sqrt(amcl_orientation_errors_w{1}.^2 + amcl_position_errors_w{1}.^2);
  amcl_errors_w{2} = sqrt(amcl_orientation_errors_w{2}.^2 + amcl_position_errors_w{2}.^2);
  amcl_errors_w{3} = sqrt(amcl_orientation_errors_w{3}.^2 + amcl_position_errors_w{3}.^2);
  amcl_errors_w{4} = sqrt(amcl_orientation_errors_w{4}.^2 + amcl_position_errors_w{4}.^2);


  dft_orientation_errors_w{1} = dft_orientation_errors_w{1}(1:min_size);
  dft_position_errors_w{1} = dft_position_errors_w{1}(1:min_size);
  dft_orientation_errors_w{2} = dft_orientation_errors_w{2}(1:min_size);
  dft_position_errors_w{2} = dft_position_errors_w{2}(1:min_size);
  dft_orientation_errors_w{3} = dft_orientation_errors_w{3}(1:min_size);
  dft_position_errors_w{3} = dft_position_errors_w{3}(1:min_size);
  dft_orientation_errors_w{4} = dft_orientation_errors_w{4}(1:min_size);
  dft_position_errors_w{4} = dft_position_errors_w{4}(1:min_size);

  dft_errors_w{1} = sqrt(dft_orientation_errors_w{1}.^2 + dft_position_errors_w{1}.^2);
  dft_errors_w{2} = sqrt(dft_orientation_errors_w{2}.^2 + dft_position_errors_w{2}.^2);
  dft_errors_w{3} = sqrt(dft_orientation_errors_w{3}.^2 + dft_position_errors_w{3}.^2);
  dft_errors_w{4} = sqrt(dft_orientation_errors_w{4}.^2 + dft_position_errors_w{4}.^2);


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOTH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Bring them both in a single vector
  amcl_errors{1} = [amcl_errors_c{1}, amcl_errors_w{1}];
  amcl_errors{2} = [amcl_errors_c{2}, amcl_errors_w{2}];
  amcl_errors{3} = [amcl_errors_c{3}, amcl_errors_w{3}];
  amcl_errors{4} = [amcl_errors_c{4}, amcl_errors_w{4}];

  dft_errors{1} = [dft_errors_c{1}, dft_errors_w{1}];
  dft_errors{2} = [dft_errors_c{2}, dft_errors_w{2}];
  dft_errors{3} = [dft_errors_c{3}, dft_errors_w{3}];
  dft_errors{4} = [dft_errors_c{4}, dft_errors_w{4}];


  errors_amcl = {amcl_errors{1}, amcl_errors{2}, amcl_errors{3}, amcl_errors{4}};
  errors_dft = {dft_errors{1}, dft_errors{2}, dft_errors{3}, dft_errors{4}};
  percents = {nnz(errors_dft{1} <= errors_amcl{1})/numel(errors_amcl{1}),
              nnz(errors_dft{2} <= errors_amcl{1})/numel(errors_amcl{1}),
              nnz(errors_dft{3} <= errors_amcl{1})/numel(errors_amcl{1}),
              nnz(errors_dft{4} <= errors_amcl{1})/numel(errors_amcl{1})};
end
