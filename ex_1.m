clearvars; clc; close all; format long;

% input variables
A = 3;
r = 0.5;
N = 100;
sigma_squared = 0.5;
MC = 10000;

% initialize r^n matix since we will use it several times
n = 0:N-1;
R = transpose(r.^n);

% calculate CRLB where CRLB = var(estimator_A) = sigma^2 / sum(R)
CRLB = sigma_squared / dot(R, R);
disp(CRLB);

% initialize estimations array
estimations = zeros(MC, 1);
for mc = 0:MC-1
    % calculate X values where X is Nx1 matrix
    X = A * R + sqrt(sigma_squared) * randn(N, 1);
    % fill up estimations according to the estimator we found:
    % estimator_A = sum(x[n]*r[n]) / sum(r[n]^2)
    estimations(mc + 1, 1) = dot(X, R) / dot(R, R);
end

% calculate the stats of the estimator
stats = [mean(estimations) std(estimations) var(estimations)];
disp(stats);

% display histogram of the estimator
histogram(estimations);