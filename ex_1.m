clearvars; clc; close all; format long;

% input variables
A = 3;
r = 0.2;
N = 100;
sigma_squared = 0.5;
MC = 10000;

% initialize r^n matix since we will use it several times
n = 0:N-1;
R = transpose(r.^n);

% calculate CRLB where CRLB = var(estimator_A) = sigma^2 / sum(R)
CRLB = sigma_squared / dot(R, R');
disp(strcat('CRLB is:', num2str(CRLB)));

% initialize estimations array
estimations = zeros(MC, 1);
for mc = 1:MC
    % calculate simulated X values where X is Nx1 matrix
    X = A * R + sqrt(sigma_squared) * randn(N, 1);
    % fill up estimations according to the estimator we found:
    estimations(mc, 1) = dot(X, R') / dot(R, R');
end

% calculate the stats of the estimator
stats = [mean(estimations) var(estimations)];
disp(strcat('estimated mean : ', num2str(stats(1))));
disp(strcat('estimated variance : ', num2str(stats(2))));

bias_sum = 0;
for mc = 1:MC
    bias_sum = bias_sum + estimations(mc, 1) - A;
end
bias = bias_sum / MC;
disp(strcat('estimated bias : ', num2str(bias)));

% display histogram of the estimator
[n, x] = hist(estimations, 56);
plot(x, n / (sum(n) * (x(2) - x(1))), 'r-', x, normpdf(x, A, sqrt(sigma_squared)));
legend('Simulated', 'Theoretical');
