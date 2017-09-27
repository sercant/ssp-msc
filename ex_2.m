% Work in progress

% x[0] = A + w[0]
% x[1] = A + w[1]
% C = sigma_squared * [1 rho; rho 1]
% BLUE says that by the Gauss-Markov Theorem:
% x = H * thetha + w where w has known mean and know "C" covariance matrix,
% then BLUE is:
% thetha_hat = inv(transpose(H) * inv(C) * H) * transpose(H) * inv(C) * x
% since in this case our noise is known to be gaussian, thetha_hat will be
% the MVUE as well.
clearvars; clc; close all; format long;

% create symbols for the unkown variables
syms sigma_squared rho x0 x1;

% initialize the problem
X = [x0 x1]';
H = [1 1]';
C = sigma_squared * [1 rho; rho 1];

% find variance according to var(A_hat) = inv(H' * inv(C) * H)
A_hat_variance = simplify(inv((H' * inv(C) * H)));
disp('Variance of the estimator is:');
disp(A_hat_variance);

% find the estimator A_hat = var(A_hat) * inv(C) * X
A_hat = A_hat_variance * H' * inv(C) * X;
A_hat = simplify(A_hat);
disp('Estimator is:');
disp(A_hat);

% initialize the problem
A = 3;
rho = 0.5;
sig_sq = 0.3;


% form the corelation
C = [1 rho; rho 1] * sig_sq;

[P, D] = eig(C);
K = P * sqrt(D);

MC = 100;

simulated_X = zeros(MC, 2);
estimated_X = zeros(MC, 1);
for mc = 1:MC
    W = randn(2, 1);
    % where Z is the correlated noise
    Z = K * W;
    
    X = A * [1 1]' + Z;
    simulated_X(mc, :) = X;
    
    estimated_X(mc, 1) = dot(X, [1/2 1/2]);
end

plot(simulated_X);
hold on;
plot(estimated_X);
legend('x0','x1','estimator');
% [p, n] = hist(estimated_X, 256);
% plot(norm(estimated_X));
disp(sig_sq * (1 + rho) / 2);
disp(var(estimated_X));