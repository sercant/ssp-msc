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
X = [x0 x1].';
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
sig_sq = 0.3;

MC = 100000;
i = 1;
disp('Monte-Carlo simulations:');
for rho = -1:1:1
    C = [1 rho; rho 1] .* sig_sq;

    estimated_A = zeros(MC, 1);
    for mc = 1:MC
        % where Z is the correlated noise reference:
        % https://en.wikipedia.org/wiki/Cholesky_decomposition
        Z = chol(C)' * randn(2, 1);

        X = A * [1 1]' + Z;
        estimated_A(mc, 1) = dot(X, [1/2 1/2]);
    end
    
    [n, x] = hist(estimated_A, 256);
    subplot(1, 3, i);
    plot(x, n / (sum(n) * (x(2) - x(1))), 'r-', x, normpdf(x, A, sqrt(sig_sq * (1 + rho) / 2)));
    title(strcat('rho = ', num2str(rho)));
    legend('Simulated', 'Theoretical');
    
    log = strcat('---- rho =', num2str(rho));
    log = strcat(log, ' ----');
    disp(log);
    disp(strcat('theoretical variance: ', num2str(sig_sq * (1 + rho) / 2)));
    disp(strcat('simulated variance: ', num2str(var(estimated_A))));
    disp('------------');
    
    i = i + 1;
end