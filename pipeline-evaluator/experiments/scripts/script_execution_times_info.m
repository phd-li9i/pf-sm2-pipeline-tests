clear all
pkg load io


a = {csv2cell("../execution_times")};

ca_loc = a{1};

s = ca_loc(3:end, 1);
ns = ca_loc(3:end, 2);

s = cell2mat(s);
ns = cell2mat(ns);

ca_loc = [s ns];

dp = ca_loc;

t = dp(:,1) + 10^(-9) * dp(:,2);

mean_t = mean(t);
min_t = min(t);
max_t = max(t);
std_t = std(t);

fprintf('------------------------------------------------------------------\n');
fprintf('----- Execution times --------------------------------------------\n');
fprintf('------------------------------------------------------------------\n');
fprintf('Mean execution time = %f \n', mean_t);
fprintf('STD execution time = %f \n', std_t);
fprintf('Min execution time = %f \n', min_t);
fprintf('Max execution time = %f \n', max_t);
