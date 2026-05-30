%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define folders
Main_Folder=pwd;
Program_Folder=[Main_Folder '\Functions_simulation'];

%% Import SSP, ICI and trajectory simulations
cd([Main_Folder '\Simulation_logs']);
load('z_profile.mat'); 
load('ssp.mat');   
load ICI_simulation;
load range_interp
load depth_interp

%% Set Parameters
ranges=200:2000;                %set ranges within the grid (in [m])
depths=200:1000;                %set depths within the grid (in [m])
Params.P = 3;                   % PxP transition window
Params.B = 1000;                % Beam width
Params.h1_nominal = 20 ;        % Hydrophone 1 -nominal depth (in [m])
Params.h2_nominal = 100 ;       % Hydrophone 2 -nominal depth (in [m])
Params.sigma_tdoa = 0.0001;     % 0.1 ms TDOA measurement error (s)
Params.sigma_h =  0.5;          % hydrophone depth uncertainty (m)
Params.sigma_h_sensor=0.1;      % depth sensor error (m)
Params.sigma_c= 1;              % SSP uncertainty (m)
plot_flag=1;                    % set to visualize localization results
normal_flag=1;                  % wave motion distribution type (1-normal | 0-uniform)
r_bias=500;                     % Control initial range of the whale (where initial range=724-r_bias [m])
z_bias=480;                     % Control initial depth of the whale (where initial range=804-r_bias [m])
Number_of_click_trains=0;       % Set the number of click trains (set 0 for a full dive)

%% Construct grid
cd(Program_Folder);
[R_mesh, Z_mesh, stateGrid, Precomputed_grid, activeSet]=Construct_precomputed_grid(Main_Folder,ranges, depths);



%% Run localization process
%Initialization
R_true_all=[];
Z_true_all=[];
R_estimated_all=[];
Z_estimated_all=[];
R_estimated_all_depth=[];
Z_estimated_all_depth=[];
count_movement=0;

% Divide clicks into groups of click trains
Train_indices=find(diff(Clicks_arrival_time)>2.5);
Train_indices=[1 Train_indices];
if Number_of_click_trains==0
    Number_of_click_trains=length(Train_indices);
end

% Run algorithm per click train
cd(Program_Folder)
for rep=1:Number_of_click_trains
    rep
    Emission_lattice=[]; Emission_lattice_depth=[];
    for pos=1:Train_indices(rep+1)-Train_indices(rep)          
        count_movement=count_movement+1;
        r_true(pos)=range_interp(Clicks_arrival_time(count_movement))-r_bias;
        z_true(pos)=-depth_interp(Clicks_arrival_time(count_movement))-z_bias;
        c_profile= ssp + Params.sigma_c*randn(size(ssp));
        c_func = @(z) interp1(z_profile, c_profile, z, 'pchip', 'extrap');
        [Emission_grid,Emission_grid_depth]=Evaluate_Emissions(normal_flag,r_true(pos),z_true(pos),stateGrid,R_mesh,c_func,Params,Precomputed_grid);
        Emission_lattice(:,:,pos)=Emission_grid;
        Emission_lattice_depth(:,:,pos)=Emission_grid_depth;             
    end

    [path_z, path_r] = viterbi_beamsearch(Emission_lattice, Params.P, Params.B);
    [path_z_depth, path_r_depth] = viterbi_beamsearch(Emission_lattice_depth, Params.P, Params.B);
    R_estimated=ranges(path_r);  R_estimated_depth=ranges(path_r_depth);
    Z_estimated=depths(path_z);  Z_estimated_depth=depths(path_z_depth);

   
    R_true_all=[R_true_all r_true];
    Z_true_all=[Z_true_all z_true];
    R_estimated_all=[R_estimated_all R_estimated];
    Z_estimated_all=[Z_estimated_all Z_estimated];
    R_estimated_all_depth=[R_estimated_all_depth R_estimated_depth];
    Z_estimated_all_depth=[Z_estimated_all_depth Z_estimated_depth];

    r_true=[];
    z_true= [];
end


%% Visualize localization results
if plot_flag
     figure;
     subplot(1,2,1); 
     plot(R_estimated_all_depth,Z_estimated_all_depth,'m*','LineWidth',2);  hold on; grid on;
     plot(R_true_all,Z_true_all,'k*','LineWidth',2); hold on; grid on; set(gca, 'YDir','reverse');
     legend('Proposed','Ground truth')
     set(gca,'FontSize',12); 
     ylabel('Depth [m]'); xlabel('Range [m]'); title('With depth sensors'); 
     subplot(1,2,2); 
     plot(R_estimated_all,Z_estimated_all,'m*','LineWidth',2);  hold on; grid on;
     plot(R_true_all,Z_true_all,'k*','LineWidth',2); hold on; grid on; set(gca, 'YDir','reverse');
     legend('Proposed','Ground truth')
     set(gca,'FontSize',12); 
     ylabel('Depth [m]'); xlabel('Range [m]'); title('No depth sensors');          
end
