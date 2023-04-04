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
data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data_not_means/');

% Here is where the figures are stored
save_eps_path = '';
if strcmp(system, 'amcl-icp')
  save_eps_path = strcat(pwd, '/boxplots/');
elseif strcmp(system, 'amcl-icp-dft')
  save_eps_path = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-paid-paper/figures/results/', map_name, '/partial_errors/');
endif

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd';

cached = 0;
if exist(strcat(data_path, map_name, '_amcl_position_error_5.mat')) == 2
  cached = cached + 1;
endif

[top_most_dir_list] = dir(top_most_dir);

amcl_position_errors_c = {};
dft_position_errors_c = {};

% For open-loop
if cached == 0
  disp('Generate cache first, then run me; returning...')
  return;
else
  base_dir = strcat(top_most_dir, top_most_dir_list(5).name);

  load(strcat(data_path, map_name, '_amcl_position_error_5.mat'))
  load(strcat(data_path, map_name, '_amcl_error_sizes_5.mat'))

  load(strcat(data_path, map_name, '_dft_position_error_5.mat'))
  load(strcat(data_path, map_name, '_dft_error_sizes_5.mat'))

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
  amcl_position_errors_c{1} = nonzeros(amcl_position_errors .* (amcl_sizes == 1))';
  dft_position_errors_c{1} = nonzeros(dft_position_errors .* (dft_sizes == 1))';

  %amcl_position_errors_c{2} = nonzeros(amcl_position_errors .* (amcl_sizes == 5))';
  %dft_position_errors_c{2} = nonzeros(dft_position_errors .* (dft_sizes == 5))';

  amcl_position_errors_c{3} = nonzeros(amcl_position_errors .* (amcl_sizes == 9))';
  dft_position_errors_c{3} = nonzeros(dft_position_errors .* (dft_sizes == 9))';

  amcl_position_errors_c{4} = nonzeros(amcl_position_errors .* (amcl_sizes == 13))';
  dft_position_errors_c{4} = nonzeros(dft_position_errors .* (dft_sizes == 13))';

  amcl_position_errors_c{2} = nonzeros(amcl_position_errors .* (amcl_sizes == 17))';
  dft_position_errors_c{2} = nonzeros(dft_position_errors .* (dft_sizes == 17))';

endif

% positions
errors= {amcl_position_errors_c{1}, dft_position_errors_c{1}, ...
         amcl_position_errors_c{2}, dft_position_errors_c{2}, ...
         amcl_position_errors_c{3}, dft_position_errors_c{3}, ...
         amcl_position_errors_c{4}, dft_position_errors_c{4}};

errors_sizes = { 1*ones(1,size(amcl_position_errors_c{1},2)),  2*ones(1,size(dft_position_errors_c{1},2)), ...
                 5*ones(1,size(amcl_position_errors_c{2},2)),  6*ones(1,size(dft_position_errors_c{2},2)), ...
                 9*ones(1,size(amcl_position_errors_c{3},2)), 10*ones(1,size(dft_position_errors_c{3},2)), ...
                13*ones(1,size(amcl_position_errors_c{4},2)), 14*ones(1,size(dft_position_errors_c{4},2))};





x_min = 0;
x_max = 15;

if strcmp(map_name, 'corridor') == 1

  y_min = 0.0;
  y_max = 1.0;

  y_min_zoomed = 0.0;
  y_max_zoomed = 0.02;

endif

if strcmp(map_name, 'warehouse') == 1


  y_min = 0.0;
  y_max = 5.0;

  y_min_zoomed = 0.0;
  y_max_zoomed = 0.1;

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
  set (gca, 'ytick', [0:0.1:1], 'yticklabel', {'$0.0$','$0.10$','$0.20$','$0.30$','$0.40$','$0.50$','$0.60$','$0.70$','$0.80$','$0.90$','$1.0$'})
  line([0 15], [0.00 0.00], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.02], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.02 0.02], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.02], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
endif
if strcmp(map_name, 'warehouse') == 1
  set (gca,  'ytick', [0:1:5], 'yticklabel', {'$0.0$','$1.0$','$2.0$','$3.0$','$4.0$','$5.0$'});
  line([0 15], [0.00 0.00], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.10], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.10 0.10], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.10], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
endif
grid
box on

axis([x_min x_max y_min y_max])
title('Κατανομή σφαλμάτων εκτίμησης θέσης ανά μέθοδο επιλογής σωματιδίων [m]');
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
  set (gca, 'ytick', [0.0:0.005:0.02], 'yticklabel', {'$0.0$','$0.005$','$0.010$','$0.015$','$0.020$'});
  line([0 15], [0.00 0.00], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.02], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.02 0.02], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.02], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
endif
if strcmp(map_name, 'warehouse') == 1
  set (gca, 'ytick', [0.0:0.02:0.1], 'yticklabel', {'$0.0$','$0.02$','$0.04$','$0.06$','$0.08$','$0.10$'});
  line([0 15], [0.00 0.00], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.10], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.10 0.10], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.10], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
endif
grid

axis([x_min x_max y_min_zoomed y_max_zoomed])
title(strcat(upper(map_name), ' position errors per pose selection method'));
xlabel('Μέθοδος επιλογής');
ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');

img_file = strcat(save_eps_path, map_name, '_all_position_errors_per_selection.eps');
drawnow ("epslatex", img_file, false)
