clear all
close all
pkg load io
pkg load geometry

store = 0;

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");

maps = {"corridor", "warehouse_karto"};


figure_counter = 0;
for m = 1:size(maps,2)
  figure_counter = figure_counter + 1;
  h = figure(figure_counter);
  hold on


  % Load map
  map = maps(m){1};
  map_str = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-pipeline-localisation-paper/figures/maps/map_', map);
  ms = csv2cell(map_str);

  map_x = ms(2:end, 1);
  map_y = ms(2:end, 2);

  map_x = cell2mat(map_x);
  map_y = cell2mat(map_y);

  M = [map_x map_y];

  if strcmp(map, 'corridor')

    plot(M(:,1), M(:,2), 'o', "markersize", 1);

    axis([3 15 3 15])

    pose_a = [11.56 12.2];
    pose_b = [5.0 6.0];
    tip_a = pose_a + [0.5 0];
    tip_b = pose_b + [0.5 0];
  endif

  % Warehouse-specific %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if strcmp(map, 'warehouse_karto')

    % Rotate figure manually
    R = [0 -1; 1 0];
    M = R * M';
    M = M';

    M(:,1) = M(:,1) + 21.0;

    plot(M(:,1), M(:,2), 'o', "markersize", 1);

    axis([-5 27 -2 44])
    pose_a = R * [2.083190 3.015576]';
    pose_b = R * [40.0 15.0]';

    pose_a = pose_a';
    pose_b = pose_b';

    pose_a(1,1) = pose_a(1,1) + 21;
    pose_b(1,1) = pose_b(1,1) + 21;

    tip_a = pose_a + [0 1];
    tip_b = pose_b + [0 1];

  endif

  axis equal

  % Print pose as arrow
  arrow_a = [pose_a tip_a];
  arrow_b = [pose_b tip_b];

  h_a = drawArrow (arrow_a, 1, 0.5 , 0.1);
  h_b = drawArrow (arrow_b, 1, 0.5 , 0.1);

  arrayfun(@(x,y)set(x,'color',y), [h_a.body; h_a.wing(:)], 'g',1,1);
  arrayfun(@(x,y)set(x,'color',y), [h_b.body; h_b.wing(:)], 'r',1,1);

  if strcmp(map, 'corridor')
    x = xlabel("x [m]");
    y = ylabel("y [m]");

    set(h,'position',[1 1 200 200]);
  endif

  if strcmp(map, 'warehouse_karto')
    x = xlabel("x [m]");
    y = ylabel("y [m]");

    set(h,'position',[1 1 200 250]);
    %set (gca, 'xtick', [56 60 65 70])
  endif

  if (store == 1)
    img_file = strcat('/media/ext/backup_files/AUTh/RELIEF/relief-pipeline-localisation-paper/figures/maps/', map, '.eps');
    drawnow ("epslatex", img_file, false)
  endif

endfor
