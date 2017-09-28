clearvars; clc; close all; format long;
syms thetha n;
% PDF of the IID U[0, thetha] RVs is:
pdf = 1 / (thetha ^ n);

% to get the MLE we take log likelihood of the pdf
log_pdf = log(pdf);
% take the first derrivative with respect to thetha
diff_log_pdf = simplify(diff(log_pdf, thetha));
disp(diff_log_pdf);
disp('= 0');
% we see here that to maximise the pdf we have to pick thetha value as big
% as possible and we have the condition where thetha > x[n] > 0.
% So MLE we conclude is MLE_est = max(x[n]).
%%%%%%%%%%%%%%%%%%%%%%%

% initialize MC loop
thetha = 3;
N = 100;

MC = 100000;

MLE_estimations = zeros(MC, 1);
A_estimations = zeros(MC, 1);
for mc = 1:MC
    rvs = thetha * rand(N, 1);
    
    MLE_est = max(rvs);
    A_est_mean = mean(rvs) * 2;
    
    MLE_estimations(mc, 1) = MLE_est;
    A_estimations(mc, 1) = A_est_mean;
end

[p, x] = hist(MLE_estimations, 512);
plot(x, p, 'r-');
hold on;
[p, x] = hist(A_estimations, 512);
plot(x, p, 'b-');

legend('MLE estimation', 'A est mean');