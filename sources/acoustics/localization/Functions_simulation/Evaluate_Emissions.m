function [P_MAP_grid,P_MAP_grid_depth]=Evaluate_Emissions(normal_flag,r_true,z_true,stateGrid,R_mesh,c_func,Params,Precomputed_grid)


           if normal_flag
               Delta_h= randn * Params.sigma_h;
           else
              Delta_h= (rand * 2 - 1) * 4 * Params.sigma_h;
           end

            h1_actual = Params.h1_nominal + 0.9*Delta_h;
            h2_actual = Params.h2_nominal + 0.8*Delta_h;

           h1_measured=h1_actual + randn * Params.sigma_h_sensor;
           h2_measured=h2_actual + randn * Params.sigma_h_sensor;

           [s1r1_true, s21_true, s2r2_true, ~] = calculate_relative_times_with_cache(r_true, r_true, z_true, h1_actual, h2_actual, c_func);                   
           % % Add measurement noise
           s1r1_obs = s1r1_true + Params.sigma_tdoa * randn();
           s21_obs = s21_true + Params.sigma_tdoa * randn();
           s2r2_obs = s2r2_true + Params.sigma_tdoa * randn();
    
           new_obs = [s1r1_obs; s21_obs; s2r2_obs];
            
        %% emission likelihoods
           new_obs_depth=[new_obs ; h1_measured ; h2_measured];
           
           accepted_indices=gating_indices(Precomputed_grid.Bx,new_obs);

           [Likelihood_sim,~]=fast_Likelihood_estimation(new_obs,Precomputed_grid.MU(:,1,accepted_indices),Precomputed_grid.L_chol(:,:,1,accepted_indices));    
           [Likelihood_sim_depth,~]=fast_Likelihood_estimation_5D(new_obs_depth,Precomputed_grid.Full_MU(:,1,accepted_indices),Precomputed_grid.Full_L_chol(:,:,1,accepted_indices));
  

            % Initialize full P_MAP grid with NaNs
            P_MAP_full = NaN(size(stateGrid, 1), 1);
            P_MAP_full_depth = NaN(size(stateGrid, 1), 1);

            % % Assign computed values only at activeSet indices
            P_MAP_full(accepted_indices) = Likelihood_sim;
            P_MAP_full_depth(accepted_indices) = Likelihood_sim_depth; 

            % Reshape to grid shape for visualization
            P_MAP_grid = reshape(P_MAP_full, size(R_mesh));
            P_MAP_grid_depth = reshape(P_MAP_full_depth, size(R_mesh));
        
            % figure; imagesc(ranges,depths,P_MAP_grid); colormap('jet') 
            % figure; imagesc(ranges,depths,P_MAP_grid_depth); colormap('jet') 
            

end