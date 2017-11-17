% (2557739) Sercan Turkmen
% (2557726) Mahalakshmy Seetharaman
% Task 3

clearvars; clc; close all; format long;
syms thetha n;
% Likelihood function of the IID U[0, thetha] RVs is:
likelihood = 1 / (thetha ^ n);

% to get the MLE we take log likelihood of the pdf
log_likelihood = log(likelihood);
% take the first derrivative with respect to thetha
diff_log_likelihood = simplify(diff(log_likelihood, thetha));
disp('MLE estimator is:');
disp(diff_log_likelihood);
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
disp('------ mean ------');
disp(strcat('MLE mean : ', num2str(mean(MLE_estimations))));
disp(strcat('A estimator mean : ', num2str(mean(A_estimations))));
disp('------------------');

disp('------ bias ------');
bias_sum = 0;
for mc = 1:MC
    bias_sum = bias_sum + MLE_estimations(mc, 1) - thetha;
end
bias = bias_sum / MC;
disp(strcat('MLE estimated bias : ', num2str(bias)));

bias_sum = 0;
for mc = 1:MC
    bias_sum = bias_sum + A_estimations(mc, 1) - thetha;
end
bias = bias_sum / MC;
disp(strcat('A estimated bias : ', num2str(bias)));
disp('------------------');

disp('---- variance ----');
disp(strcat('MLE variance : ', num2str(var(MLE_estimations))));
disp(strcat('A estimator variance : ', num2str(var(A_estimations))));
disp('------------------');

subplot(1, 2, 1);
[p, x] = hist(MLE_estimations, 512);
plot(x, p, 'r-');
hold on;
[p, x] = hist(A_estimations, 512);
plot(x, p, 'b-');

title('thetha=3');
legend('MLE estimation', 'A est mean');

hold on;

thetha = 1;
MLE_estimations_t_1 = zeros(MC, 1);
for mc=1:MC
    rvs = thetha * rand(N, 1);
    MLE_est = max(rvs);
    MLE_estimations_t_1(mc, 1) = MLE_est;
end

subplot(1, 2, 2);
[p, x] = hist(MLE_estimations_t_1, 512);
plot(x, p / (sum(p) * (x(2) - x(1))), 'r-');
hold on;
k = N;
beta = betapdf(x, k, k - N + 1);
plot(x, beta);

title('thetha=1');
legend('Simulated MLE', 'Theoretical MLE');
