% ����������������������������������������������������������������������
%          STATISTICAL SIGNAL PROCESSING (Matlab Exercise #2)
%                     (Least Square estimation)
%
% ����������������������������������������������������������������������

% ***NOTE***: use the button "Run Section" to visualize the diagram of the
% recorded positions of 'a' with respect to 'B'.



% (X,Y) Measurements of the position of the celestial body 'a' for each
% month:
X = [69.9610   69.4111   68.1078   68.4906   66.5073   65.0106   63.3201   60.0063   57.8493   54.9152   53.1017   49.5782];
Y = [20.7559   22.6554   24.3398   24.9237   27.6180   29.2726   29.8596   31.5923   32.9917   35.2425   36.1634   36.1643];

% Orbital period of 'a':
T = 12*6;

% Plot the diagram:
scatter(X, Y, '.', 'LineWidth',1);
hold on;
h = ellipse(5, 5, 0, 0,0, 'r');
set(h, 'LineWidth', 2,  'LineStyle','-');
hold off;
axis equal;
xlabel X;
ylabel Y;
text(5,-5, 'B', 'Color', 'Red', 'FontWeight', 'Bold', 'FontSize', 16);
text(X(1)-2,Y(1)-1, 'a', 'Color', 'Blue', 'FontWeight', 'Bold', 'FontSize', 16);


%% 
% ************************************************************************
% ************************************************************************
% ************************************************************************
% 
%  ... complete this part by writing a piece of code that estimates the
%  four parameters of the ellipse using LS-estimation ...
%
%  NOTE: The estimated parameters R1,R2,C1,C2 must be stored in a 4-element
%  vector variable named P.
%  

% check if the data is logically sized
if size(X) ~= size(Y)
    disp('Sizes of X and Y does not met');
end

K = length(X);

% form the observation matrix and combine X and Y in to a single matrix
H = zeros(K * 2, 4);
XY = zeros(K * 2, 1);
for k = 1:K
    H(k, 1) = cos(2 * pi / 72 * k);
    H(k, 3) = 1;
    H(k + K, 2) = sin(2 * pi / 72 * k);
    H(k + K, 4) = 1;
    
    XY(k, 1) = X(k);
    XY(k + K, 1) = Y(k);
end

% LS estimation
P = (H' * H) \ H' * XY;
% had to transpose to make it vector insted of row matrix
P = P';

% ************************************************************************
% ************************************************************************
% ************************************************************************


h = ellipse(P(1), P(2), 0, P(3), P(4), 'b');
set(h, 'LineStyle','--');

