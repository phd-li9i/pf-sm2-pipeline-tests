clear all
close all
pkg load io
pkg load statistics

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");


map_name = 'warehouse';
system = 'amcl-icp';

scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts/';

% Data (pose errors) is stored/retrieved from here
data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data/');

% Here is where the figures are stored
save_eps_path = '';
if strcmp(system, 'amcl-icp')
  save_eps_path = strcat(pwd, '/boxplots/');
elseif strcmp(system, 'amcl-icp-dft')
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-paid-paper/figures/results/', map_name, '/partial_errors/');
endif

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts';

cached = 0;
if exist(strcat(data_path, map_name, '_error_5.mat')) == 2
  load(strcat(data_path, map_name, '_error_5.mat'));
  load(strcat(data_path, map_name, '_error_sizes_5.mat'));
  cached = 1;
endif



[top_most_dir_list] = dir(top_most_dir);


% For open-loop
m = 5;
if cached == 0
  disp('Generate cache first, then run me; returning...')
  return;
else % data is cached

  base_dir = strcat(top_most_dir, top_most_dir_list(m).name);

  load(strcat(data_path, map_name, '_error_', num2str(m), '.mat'))
  load(strcat(data_path, map_name, '_error_sizes_', num2str(m), '.mat'))

  % Place >W next to 100%
  xy = mean_errors(801:1000);
  mean_errors(401:1000) = mean_errors(201:800);
  mean_errors(201:400) = xy;

  % Remove 50% simulations
  mean_errors(401:600) = mean_errors(601:800);
  mean_errors(601:800) = mean_errors(801:1000);
  mean_errors(801:1000) = [];
  sizes_(801:1000) = [];


  % Rearrange into cells
  errors =       {mean_errors(1:100),   mean_errors(101:200),...
                  mean_errors(201:300), mean_errors(301:400),...
                  mean_errors(401:500), mean_errors(501:600),...
                  mean_errors(601:700), mean_errors(701:800)};

  errors_sizes = {sizes_(1:100),   sizes_(101:200),...
                  sizes_(201:300), sizes_(301:400),...
                  sizes_(401:500), sizes_(501:600),...
                  sizes_(601:700), sizes_(701:800)};

  x_min = 0;
  x_max = 15;

  if strcmp(map_name, 'corridor') == 1

    y_min = 0.005;
    y_max = 0.07;

    y_min_zoomed = 0.01;
    y_max_zoomed = 0.02;

  endif

  if strcmp(map_name, 'warehouse') == 1


    y_min = 0.022;
    y_max = 0.11;

    y_min_zoomed = 0.025;
    y_max_zoomed = 0.058;

  endif


  colours = [0,0,0; 227,74,51]/255;
  linewidth = 2;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  figure(1, 'position', [1 1 500 200])

  s1 = subplot(1,2,1);
  hold on
  [b1,h1] = boxplot(errors{1}, errors_sizes{1});
  c1 = get(gca,'children');
  size1 = size(c1,1);

  [b2,h2] = boxplot(errors{2}, errors_sizes{2});
  c2 = get(gca,'children');
  size2 = size(c2,1)-size1;

  [b3,h3] = boxplot(errors{3}, errors_sizes{3});
  c3 = get(gca,'children');
  size3 = size(c3,1)-size1-size2;

  [b4,h4] = boxplot(errors{4}, errors_sizes{4});
  c4 = get(gca,'children');
  size4 = size(c4,1)-size1-size2-size3;

  [b5,h5] = boxplot(errors{5}, errors_sizes{5});
  c5 = get(gca,'children');
  size5 = size(c5,1)-size1-size2-size3-size4;

  [b6,h6] = boxplot(errors{6}, errors_sizes{6});
  c6 = get(gca,'children');
  size6 = size(c6,1)-size1-size2-size3-size4-size5;

  [b7,h7] = boxplot(errors{7}, errors_sizes{7});
  c7 = get(gca,'children');
  size7 = size(c7,1)-size1-size2-size3-size4-size5-size6;

  [b8,h8] = boxplot(errors{8}, errors_sizes{8});
  c8 = get(gca,'children');
  size8 = size(c8,1)-size1-size2-size3-size4-size5-size6-size7;

  for i=1:size(c8,1)
    if i <= size8
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i >= size8+1 && i <= size8+size7
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+1 && i <= size8+size7+size6
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+1 && i <= size8+size7+size6+size5
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+size5+1 && i <= size8+size7+size6+size5+size4
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+size5+size4+1 && i <= size8+size7+size6+size5+size4+size3
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+size5+size4+size3+1 && i <= size8+size7+size6+size5+size4+size3+size2
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i > size8+size7+size6+size5+size4+size3+size2
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end
  end





  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})

  if strcmp(map_name, 'corridor') == 1
    set (gca, 'ytick', [0:0.01:0.07], 'yticklabel', {'$0.0$','$0.01$','$0.02$','$0.03$','$0.04$','$0.05$','$0.06$','$0.07$'})
    line([0 15], [0.01 0.01], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
    line([0 0],  [0.01 0.02], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
    line([0 15], [0.02 0.02], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
    line([15 15],[0.01 0.02], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  endif
  if strcmp(map_name, 'warehouse') == 1
    set (gca,  'ytick', [0:0.01:0.11], 'yticklabel', {'$0.0$','$0.01$','$0.02$','$0.03$','$0.04$','$0.05$','$0.06$','$0.07$','$0.08$','$0.09$','$0.10$','$0.11$'});
    line([0 15], [0.025 0.025], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
    line([0 0],  [0.025 0.058], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
    line([0 15], [0.058 0.058], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
    line([15 15],[0.025 0.058], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  endif
  grid
  box on

  axis([x_min x_max y_min y_max])

  title('Κατανομή μέσων σφαλμάτων εκτίμησης στάσης ανά μέθοδο επιλογής σωματιδίων');
  xlabel('Μέθοδος επιλογής');
  ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');




  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  s2 = subplot(1,2,2);
  hold on
  [b1,h1] = boxplot(errors{1}, errors_sizes{1});
  c1 = get(gca,'children');
  size1 = size(c1,1);

  [b2,h2] = boxplot(errors{2}, errors_sizes{2});
  c2 = get(gca,'children');
  size2 = size(c2,1)-size1;

  [b3,h3] = boxplot(errors{3}, errors_sizes{3});
  c3 = get(gca,'children');
  size3 = size(c3,1)-size1-size2;

  [b4,h4] = boxplot(errors{4}, errors_sizes{4});
  c4 = get(gca,'children');
  size4 = size(c4,1)-size1-size2-size3;

  [b5,h5] = boxplot(errors{5}, errors_sizes{5});
  c5 = get(gca,'children');
  size5 = size(c5,1)-size1-size2-size3-size4;

  [b6,h6] = boxplot(errors{6}, errors_sizes{6});
  c6 = get(gca,'children');
  size6 = size(c6,1)-size1-size2-size3-size4-size5;

  [b7,h7] = boxplot(errors{7}, errors_sizes{7});
  c7 = get(gca,'children');
  size7 = size(c7,1)-size1-size2-size3-size4-size5-size6;

  [b8,h8] = boxplot(errors{8}, errors_sizes{8});
  c8 = get(gca,'children');
  size8 = size(c8,1)-size1-size2-size3-size4-size5-size6-size7;

  for i=1:size(c8,1)
    if i <= size8
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i >= size8+1 && i <= size8+size7
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+1 && i <= size8+size7+size6
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+1 && i <= size8+size7+size6+size5
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+size5+1 && i <= size8+size7+size6+size5+size4
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+size5+size4+1 && i <= size8+size7+size6+size5+size4+size3
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end

    if i >= size8+size7+size6+size5+size4+size3+1 && i <= size8+size7+size6+size5+size4+size3+size2
      set(c8(i), 'color', [colours(2,:)], 'linewidth', linewidth);
    end

    if i > size8+size7+size6+size5+size4+size3+size2
      set(c8(i), 'color', [colours(1,:)], 'linewidth', linewidth);
    end
  end



  set(gca,'XTick', [1.5 5.5 9.5 13.5])
  set (gca, 'xticklabel', {'$100\\%$', '$>\\overline{W}$', '$10\\%$', 'top'})

  if strcmp(map_name, 'corridor') == 1
    set (gca, 'ytick', [0.01:0.002:0.02], 'yticklabel', {'$0.010$','$0.012$','$0.014$','$0.016$','$0.018$','$0.020$'});
    line([0 15], [0.01 0.01], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
    line([0 0],  [0.01 0.02], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
    line([0 15], [0.02 0.02], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
    line([15 15],[0.01 0.02], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  endif
  if strcmp(map_name, 'warehouse') == 1
    set (gca,  'ytick', [0.025:0.005:0.055], 'yticklabel', {'$0.025$','$0.030$','$0.035$','$0.040$','$0.045$','$0.050$','$0.055$'});
    line([0 15], [0.025 0.025], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
    line([0 0],  [0.025 0.058], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
    line([0 15], [0.058 0.058], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
    line([15 15],[0.025 0.058], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  endif
  grid
  box on

  axis([x_min x_max y_min_zoomed y_max_zoomed])
  title(strcat(upper(map_name), ' pose errors per pose selection method'));
  xlabel('Μέθοδος επιλογής');

  img_file = strcat(save_eps_path, map_name, '_mean_total_errors_per_selection.eps');
  drawnow ("epslatex", img_file, false)

endif
