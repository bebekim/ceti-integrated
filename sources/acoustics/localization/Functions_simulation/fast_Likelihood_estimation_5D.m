function [logN, d2] = fast_Likelihood_estimation_5D(y, MU, L)
% Inputs:
%   y   : 5 x 1                 % observation vector
%   MU  : 5 x K x Q             % means for K components, Q states
%   L   : 5 x 5 x K x Q         % Cholesky factors (lower triangular)
%
% Outputs:
%   logN : K x Q                % log-likelihoods per component/state
%   d2   : K x Q                % Mahalanobis distances squared

    K = size(MU, 2);
    Q = size(MU, 3);

    % Broadcast y to match MU size
    diff = MU - y;                    % 5 x K x Q

    % Reshape to 2D: 5 x (K*Q)
    diff_r = reshape(diff, 5, []);    % 5 x (K*Q)
    L_r = reshape(L, 5, 5, []);       % 5 x 5 x (K*Q)

    % Forward substitution for all pages:
    % Solve L * z = diff → z = L \ diff for each (K,Q)
    z = zeros(size(diff_r));         % 5 x (K*Q)
    
    for i = 1:5
        z(i,:) = diff_r(i,:);
        for j = 1:i-1
            z(i,:) = z(i,:) - squeeze(L_r(i,j,:)).' .* z(j,:);
        end
        z(i,:) = z(i,:) ./ squeeze(L_r(i,i,:)).';
    end

    % Mahalanobis distance squared
    d2 = sum(z.^2, 1);               % 1 x (K*Q)
    d2 = reshape(d2, K, Q);          % K x Q

    % Log-determinant of each covariance matrix (via Cholesky)
    logdetC = zeros(1, K*Q);
    for i = 1:5
        logdetC = logdetC + log(abs(squeeze(L_r(i,i,:))).');
    end
    logdetC = 2 * logdetC;           % 1 x (K*Q)
    logdetC = reshape(logdetC, K, Q);

    % Log-likelihood (Gaussian)
    logN = -0.5 * d2 - 0.5 * logdetC - (5/2) * log(2*pi);
end
