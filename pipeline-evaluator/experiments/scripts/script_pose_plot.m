clear all
pkg load io
graphics_toolkit("gnuplot")

P = function_load_files_to_cell_of_matrices();

% Plot actual paths
figure(1)
hold on
grid

% Ground truth
gt = P{1};
plot(gt(:,3), gt(:,4), "color", "k");

% Amcl pose
ap = P{2};
plot(ap(:,3), ap(:,4), "color", "r");

% icp-corrected pose
ip = P{3};
plot(ip(:,3), ip(:,4), "color", "b");

% dft-corrected pose
dp = P{4};
plot(dp(:,3), dp(:,4), "color", "g");
