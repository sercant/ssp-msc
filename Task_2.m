% Statistical Signal Processing MATLAB assignment
% 

close;
clc;
clear;
load data_high_snr;
plot(timet,10*log10(abs(data).^2));
dataPower = 10*log10(abs(data).^2);
initThreshold = double(rms(data));
initThreshold = 10*log10(initThreshold^2);
initMeanVec = initThreshold.*ones(1,max(size(data)));
hold on
plot(timet,initMeanVec,'r--');
disp(['Initial Probability of False Alarm is: ',num2str(qfunc(initThreshold))])
% logicalmat = 