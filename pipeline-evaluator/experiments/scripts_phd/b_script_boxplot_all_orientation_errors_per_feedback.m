% Plots aaaall errors, not means
clear all
close all
pkg load io
pkg load statistics

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");


map_name = 'corridor';
system = 'amcl-icp';

scripts_path = '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts/';

% Data (pose errors) is stored/retrieved from here
data_path = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system,  '/eps=-1/', map_name, '/data_not_means/');

% Here is where the figures are stored
save_eps_path = strcat(pwd, '/boxplots/');

% Batches are stored here
top_most_dir = strcat('/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/amcl_selection_particles_tests/', system, '/eps=-1/', map_name, '/by_feedback/');

addpath '/home/li9i/catkin_ws/src/pipeline_evaluator/experiments/scripts_phd';

cached = 0;
if exist(strcat(data_path, map_name, '_amcl_orientation_error_3.mat')) == 2
  cached = cached + 1;
endif

if exist(strcat(data_path, map_name, '_amcl_orientation_error_4.mat')) == 2
  cached = cached + 1;
endif

if exist(strcat(data_path, map_name, '_amcl_orientation_error_5.mat')) == 2
  cached = cached + 1;
endif

if exist(strcat(data_path, map_name, '_amcl_orientation_error_6.mat')) == 2
  cached = cached + 1;
endif


[top_most_dir_list] = dir(top_most_dir);

amcl_orientation_errors_c = {};
dft_orientation_errors_c = {};

if cached == 0
  disp('Generate cache first, then run me; returning...')
  return;
else
  for m=3:6
    base_dir = strcat(top_most_dir, top_most_dir_list(m).name);

    load(strcat(data_path, map_name, '_amcl_orientation_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_amcl_error_sizes_', num2str(m), '.mat'))

    load(strcat(data_path, map_name, '_dft_orientation_error_', num2str(m), '.mat'))
    load(strcat(data_path, map_name, '_dft_error_sizes_', num2str(m), '.mat'))


    % Identify only those for selection = 100%
    amcl_orientation_errors_c{m} = nonzeros(amcl_orientation_errors .* (amcl_sizes == 1))';
    dft_orientation_errors_c{m} = nonzeros(dft_orientation_errors .* (dft_sizes == 1))';

  endfor
endif

% Right now the structure in *_errors is
%__________________________________
%| hard | soft-50 | open | soft-1 |
%__________________________________
%
% We would like to present results as
%__________________________________
%| open | soft-1 | soft-50 | hard |
%__________________________________

% Orientations
errors= {amcl_orientation_errors_c{5}, dft_orientation_errors_c{5}, ...
         amcl_orientation_errors_c{6}, dft_orientation_errors_c{6}, ...
         amcl_orientation_errors_c{4}, dft_orientation_errors_c{4}, ...
         amcl_orientation_errors_c{3}, dft_orientation_errors_c{3}};

errors_sizes = { 1*ones(1,size(amcl_orientation_errors_c{5},2)),  2*ones(1,size(dft_orientation_errors_c{5},2)), ...
                 5*ones(1,size(amcl_orientation_errors_c{6},2)),  6*ones(1,size(dft_orientation_errors_c{6},2)), ...
                 9*ones(1,size(amcl_orientation_errors_c{4},2)), 10*ones(1,size(dft_orientation_errors_c{4},2)), ...
                13*ones(1,size(amcl_orientation_errors_c{3},2)), 14*ones(1,size(dft_orientation_errors_c{3},2))};



x_min = 0;
x_max = 15;

if strcmp(map_name, 'corridor') == 1

  y_min = 0.0;
  y_max = 0.08;

  y_min_zoomed = 0.0;
  y_max_zoomed = 0.01;

endif

if strcmp(map_name, 'warehouse') == 1

  y_min = 0.0;
  y_max = 5.0;

  y_min_zoomed = 0.0;
  y_max_zoomed = 0.01;

endif


colours = [0,0,0; 227,74,51]/255;
linewidth = 2;

%% Print normal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

set(gca,'xtick', [1.5 5.5 9.5 13.5])
set (gca, 'xticklabel', {'open', 'soft-$1$', 'soft-$50$', 'hard'})

if strcmp(map_name, 'corridor') == 1
  set (gca, 'ytick', [0:0.01:0.08], 'yticklabel', {'$0.0$','$0.01$','$0.02$','$0.03$','$0.04$','$0.05$','$0.06$','$0.07$','$0.08$'})
  line([0 15], [0.00 0.00], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.01], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.01 0.01], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.01], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
endif
if strcmp(map_name, 'warehouse') == 1
  set (gca,  'ytick', [0:1:5], 'yticklabel', {'$0.0$','$1.0$','$2.0$','$3.0$','$4.0$','$5.0$'});
  line([0 15], [0.00 0.00], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.01], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.01 0.01], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.01], 'linestyle', ':', 'color', 'm', 'linewidth', linewidth)
endif
grid
box on



axis([x_min x_max y_min y_max])
title('Κατανομή σφαλμάτων εκτίμησης προανατολισμού ανά μέθοδο ανάδρασης [rad]');
xlabel('Μέθοδος ανάδρασης');
ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');









%% Print zoomed-in %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
set (gca, 'xticklabel', {'open', 'soft-$1$', 'soft-$50$', 'hard'})

if strcmp(map_name, 'corridor') == 1
  set (gca, 'ytick', [0.0, 0.0025, 0.005, 0.0075, 0.01], 'yticklabel', {'$0.0$','$0.025$','$0.005$','$0.075$','$0.01$'});
  line([0 15], [0.00 0.00], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.01], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.01 0.01], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.01], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
endif
if strcmp(map_name, 'warehouse') == 1
  set (gca, 'ytick', [0.0, 0.0025, 0.005, 0.0075, 0.01], 'yticklabel', {'$0.0$','$0.025$','$0.005$','$0.075$','$0.01$'});
  line([0 15], [0.00 0.00], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 0],  [0.00 0.01], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([0 15], [0.01 0.01], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
  line([15 15],[0.00 0.01], 'linestyle', '-', 'color', 'm', 'linewidth', linewidth)
endif
grid

axis([x_min x_max y_min_zoomed y_max_zoomed])
title(strcat(upper(map_name), ' orientation errors per feedback method'));
xlabel('Μέθοδος ανάδρασης');
ylabel('$\overline{\|e\|_{2,i}}$, $i = \{1,2,\dots,N\}$');

img_file_orientation = strcat(save_eps_path, map_name, '_all_orientation_errors_per_feedback.eps');
drawnow ("epslatex", img_file_orientation, false)
