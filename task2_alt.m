load data_high_snr;

mf = ones(size(data));
threshold = mf' * data.^2;
threshold_in_dbm = 10 * log10(abs(threshold).^2);

dbm_threshold_plot = threshold_in_dbm.*ones(1,max(size(data)));

plot(timet,10*log10(abs(data).^2), 'b');
hold on;
plot(timet,dbm_threshold_plot,'r--');