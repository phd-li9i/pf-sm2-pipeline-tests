% Plots aaaall errors, not means
clear all
close all
pkg load io
pkg load statistics

graphics_toolkit("gnuplot")
warning("off","print:missing_fig2dev");
warning("off","print:missing_epstool");

percents_selections = e_function_barchart_percent_improvement_per_selection();
percents_feedbacks = e_function_barchart_percent_improvement_per_feedback();
percents_smsm = e_function_barchart_percent_improvement_smsm();


% Here is where the figures are stored
%save_eps_path = strcat(pwd, '/barcharts/');
%img_file_orientation = strcat(save_eps_path, map_name, '_all_orientation_errors_per_feedback.eps');
%drawnow ("epslatex", img_file_orientation, false)
