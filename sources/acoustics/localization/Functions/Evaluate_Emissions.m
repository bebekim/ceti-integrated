function [Emission_lattice,r_true,z_true]=Evaluate_Emissions(Ranges_GT,TDOA_measured,activeSet,MU,L_chol,stateGrid,R_mesh)

    r_true=zeros(1,length(Ranges_GT));
    z_true=24*ones(1,length(Ranges_GT));
    for pos=1:length(Ranges_GT)
        pos
         r_true(pos)=Ranges_GT(pos);
         new_obs=TDOA_measured(:,pos)/1e3; %result.observations;
        
       %% emission likelihoods  
       accepted_indices=activeSet;
       [Likelihood_sim,~]=fast_Likelihood_estimation(new_obs,MU(:,1,accepted_indices),L_chol(:,:,1,accepted_indices));    
    
        % Initialize full P_MAP grid with NaNs
        P_MAP_full = NaN(size(stateGrid, 1), 1);
    
        % % Assign computed values only at activeSet indices
        P_MAP_full(accepted_indices) = Likelihood_sim;
    
        % Reshape to grid shape for visualization
        P_MAP_grid = reshape(P_MAP_full, size(R_mesh));
    
        % figure; imagesc(ranges,depths,P_MAP_grid); colormap('jet') 
        
        Emission_lattice(:,:,pos)=P_MAP_grid;
    end
   
end





