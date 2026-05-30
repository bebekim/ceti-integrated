function [R_mesh, Z_mesh, stateGrid, MU, L_chol, activeSet]=Construct_precomputed_grid(Main_Folder,ranges, depths)

    % Create grid of all [r, z] pairs
    [R_mesh, Z_mesh] = meshgrid(ranges, depths);
    
    % Convert to Nx2 stateGrid: each row is [r z]
    stateGrid = [R_mesh(:), Z_mesh(:)];
    
    Loop_size=round(size(stateGrid,1)/100);
    
    % Import precomputed parameters
    cd([Main_Folder '\Exp_grid_precomputation']);
    files=dir("Lchol_*.mat");
    for L=1:length(files)-1
        load(['mu_' num2str(L) '.mat'])
        load(['Lchol_' num2str(L) '.mat'])
        MU_all(:,1,(L-1)*Loop_size+1:L*Loop_size)=MU(:,1,(L-1)*Loop_size+1:L*Loop_size);
        Lchol_all(:,:,1,(L-1)*Loop_size+1:L*Loop_size)=L_chol(:,:,1,(L-1)*Loop_size+1:L*Loop_size);
    end
    MU=MU_all;
    L_chol=Lchol_all;
    activeSet=1:size(stateGrid,1)-1e3;

end