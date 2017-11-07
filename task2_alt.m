clearvars; clc; close all; format long;

load data_high_snr;

mf = ones(size(data));

value_in_dbm = @(val) 10 * log10(abs(val) .^ 2);

threshold = mf' * data.^2;
threshold_in_dbm = value_in_dbm(threshold);

dbm_threshold_plot = threshold_in_dbm .* ones(size(data));

data_in_dbm = value_in_dbm(data);

more_than_threshold = data_in_dbm >= threshold_in_dbm;

over_threshold_data = data_in_dbm(more_than_threshold);
over_threshold_timet = timet(more_than_threshold);

less_than_threshold = data_in_dbm < threshold_in_dbm;

under_threshold_data = data_in_dbm(less_than_threshold);
under_threshold_timet = timet(less_than_threshold);

under_threshold_complex_data = data(abs(data) < abs(threshold));
noise_var = var(under_threshold_complex_data);
disp("noise var=" + noise_var);

% in-phase quatratic samples follow rician distribution
% but since our noise is 0 mean, it follows rayleigh distribution

% variance of rayleigh dist = (4 - pi) / 2 * sig_sq
sig_sq = noise_var * 2 / (4 - pi);

% not sure here if i need to use the siq_sq from the equation above
% or the variance of the noise samples directly.
pdf = @(x) x / noise_var .* exp(-x .^ 2 / (2 .* noise_var));
pfa = integral(pdf, abs(threshold), Inf);
disp("pfa=" + pfa);

plot(timet, data_in_dbm, 'b');
hold on;
plot(over_threshold_timet, over_threshold_data, 'go');
% hold on;
% plot(under_threshold_timet, under_threshold_data, 'r');
hold on;
plot(timet,dbm_threshold_plot,'r--');