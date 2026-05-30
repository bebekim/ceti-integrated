function accepted_indices=gating_indices(Bx,tau_obs)
    % Vectorized 3 x N comparison
    tmin = squeeze(Bx(:,1,:));  % 3 x N
    tmax = squeeze(Bx(:,2,:));  % 3 x N
    
    N=size(Bx,3);
    % Expand tau_obs to match shape
    tau_mat = tau_obs * ones(1, N);  % 3 x N
    
    % Componentwise condition
    in_bounds = all((tau_mat >= tmin) & (tau_mat <= tmax), 1);  % 1 x N
    
    accepted_indices = find(in_bounds);

end