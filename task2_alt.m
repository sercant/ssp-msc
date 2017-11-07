clearvars; clc; close all; format long;

value_in_dbm = @(val) 10 * log10(abs(val) .^ 2);

load data_high_snr;

% energy detector
threshold = sum(data .^ 2);

threshold_in_dbm = value_in_dbm(threshold);
data_in_dbm = value_in_dbm(data);

% comparator for seperating samples
more_than_threshold = data_in_dbm >= threshold_in_dbm;
over_threshold_data = data_in_dbm(more_than_threshold);
over_threshold_timet = timet(more_than_threshold);

% comparator for seperating samples
less_than_threshold = data_in_dbm < threshold_in_dbm;
under_threshold_data = data_in_dbm(less_than_threshold);
under_threshold_timet = timet(less_than_threshold);

% in-phase quatrature noise samples follow rayleigh distribution
% but we will use the absolute squared version of the samples so they will
% act will be distributed exponentially. We tested this by plotting the
% histogram of the samples

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal power, threshold, and H1 samples
subplot(2, 2, 1);

dbm_threshold_plot = threshold_in_dbm .* ones(size(data));
plot(timet, data_in_dbm, 'b');
hold on;
% plot(under_threshold_timet, under_threshold_data, 'ro');
% hold on;
plot(timet,dbm_threshold_plot,'r--');
hold on;
plot(over_threshold_timet, over_threshold_data, 'go');

title("Signal Power");
legend("data", "threshold dbm", "H1 samples");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Noise characteristics and pfa

subplot(2, 2, 2);

under_threshold_complex_data = data(abs(data) < abs(threshold));
noise_abs_sq = abs(under_threshold_complex_data) .^ 2;

[p, x] = hist(noise_abs_sq, 16);
plot(x, p / (sum(p) * (x(2) - x(1))), 'b-');
hold on;

plot(x, exppdf(x, mean(noise_abs_sq)), 'r-');
hold on;
title("Noise Distrubution");
legend("Measured", "Simulated");

pfa = 1 - expcdf(abs(threshold), mean(noise_abs_sq));
disp("pfa =" + pfa);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pulse width and period
subplot(2,2,3);

[pks, locs, w, p] = findpeaks(data_in_dbm, timet, 'MinPeakHeight', threshold_in_dbm, 'MinPeakProminence', 5);
plot(w, 'o-');
title("Widths of the pulse");
hold on;

subplot(2,2,4);
periods = zeros(1, length(locs)-1);
for i = 1:(length(locs)-1)
   periods(1, i) = locs(1, i + 1) - locs(1, i);
end

plot(periods, 'o-');
title("Periods of the pulse");

disp("Pulse Width mean=" + mean(w) + " variance=" + var(w));
disp("Pulse Period mean=" + mean(periods) + " variance=" + var(periods));
