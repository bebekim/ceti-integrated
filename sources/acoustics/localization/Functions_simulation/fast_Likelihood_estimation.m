function [logN,d2]=fast_Likelihood_estimation(y,MU,L)
% Inputs:
% y   : 3x1                       % observation
% MU  : 3 x K x Q                 % means per component/state
% L   : 3 x 3 x K x Q             % Cholesky factors (lower), per component/state
%      % where Q = number of grid states, K = #mixture components per state

    % y=new_obs;
    
    K = size(MU, 2);
    Q = size(MU, 3);
    
    % Broadcast y and form per-page differences
    diff = MU - y;                    % 3 x K x Q   (implicit expansion)
    
    % Reshape to pages
    diff_r = reshape(diff, 3, []);    % 3 x (K*Q)
    L_r    = reshape(L, 3, 3, []);    % 3 x 3 x (K*Q)
    
    % Extract lower-triangular entries from all pages (length K*Q each)
    L11 = squeeze(L_r(1,1,:)).';      % 1 x (K*Q)
    L21 = squeeze(L_r(2,1,:)).';
    L22 = squeeze(L_r(2,2,:)).';
    L31 = squeeze(L_r(3,1,:)).';
    L32 = squeeze(L_r(3,2,:)).';
    L33 = squeeze(L_r(3,3,:)).';
    
    % Forward substitution z = L \ (y - mu) for ALL pages (no loops)
    z1 =  diff_r(1,:) ./ L11;
    z2 = (diff_r(2,:) - L21 .* z1) ./ L22;
    z3 = (diff_r(3,:) - L31 .* z1 - L32 .* z2) ./ L33;
    
    % Mahalanobis distance squared d2 = ||z||^2
    d2 = z1.^2 + z2.^2 + z3.^2;       % 1 x (K*Q)
    d2 = reshape(d2, K, Q);           % K x Q
    
    % % Per-state gating metric: min over mixture components
    % d2min = min(d2, [], 1);           % 1 x Q
    
    % (Optional) log|C| per component/state, if you need it for full likelihoods:
    logdetC_pages = 2*(log(L11) + log(L22) + log(L33));   % 1 x (K*Q)
    logdetC = reshape(logdetC_pages, K, Q);               % K x Q
    
    % Log Gaussian (up to constant)
    logN = -0.5*d2 - 0.5*logdetC - (numel(y)/2)*log(2*pi);
end