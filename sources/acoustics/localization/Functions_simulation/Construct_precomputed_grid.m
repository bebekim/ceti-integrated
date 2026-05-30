function [R_mesh, Z_mesh, stateGrid, Precomputed_grid, activeSet]=Construct_precomputed_grid(Main_Folder,ranges, depths)

    % Create grid of all [r, z] pairs
    [R_mesh, Z_mesh] = meshgrid(ranges, depths);
    
    % Convert to Nx2 stateGrid: each row is [r z]
    stateGrid = [R_mesh(:), Z_mesh(:)];
    
    Loop_size=round(size(stateGrid,1)/100);
    
    % Import precomputed parameters
    cd([Main_Folder '\Sim_grid_precomputation'])
    files=dir("Lchol_*.mat");
    for L=1:length(files)
        L
        load(['Bx_' num2str(L) '.mat'])
        load(['mu_' num2str(L) '.mat'])
        load(['Lchol_' num2str(L) '.mat'])
        load(['Full_mu_' num2str(L) '.mat'])
        load(['Full_Lchol_' num2str(L) '.mat'])
        Bx_all(:,:,(L-1)*Loop_size+1:L*Loop_size)=Bx(:,:,(L-1)*Loop_size+1:L*Loop_size);
        MU_all(:,1,(L-1)*Loop_size+1:L*Loop_size)=MU(:,1,(L-1)*Loop_size+1:L*Loop_size);
        Lchol_all(:,:,1,(L-1)*Loop_size+1:L*Loop_size)=L_chol(:,:,1,(L-1)*Loop_size+1:L*Loop_size);
        Full_MU_all(:,1,(L-1)*Loop_size+1:L*Loop_size)=Full_MU(:,1,(L-1)*Loop_size+1:L*Loop_size);
        Full_Lchol_all(:,:,1,(L-1)*Loop_size+1:L*Loop_size)=Full_L_chol(:,:,1,(L-1)*Loop_size+1:L*Loop_size);
    end
    
    Precomputed_grid.Bx=Bx_all;
    Precomputed_grid.MU=MU_all;
    Precomputed_grid.L_chol=Lchol_all;    
    Precomputed_grid.Full_MU=Full_MU_all;
    Precomputed_grid.Full_L_chol=Full_Lchol_all;
    activeSet=1:size(stateGrid,1)-1;

end