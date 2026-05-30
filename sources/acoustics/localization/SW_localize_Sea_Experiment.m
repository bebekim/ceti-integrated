%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define folders
Main_Folder=pwd;
Program_Folder=[Main_Folder '\Functions'];

%% Pick Transmission trial
Sea_Experiments={'Exp_260','Exp_470','Exp_790'};
Choose_Trial=1; % 1-Tx1 | 2-Tx2 | 3-Tx3

%% Import measurements
cd([Main_Folder '\' Sea_Experiments{Choose_Trial}]);
load('ToA_datetime.mat'); % Rx arrival time measurements
load('Ranges_GT.mat');   % Range measurements from GPS data
load('TDOA_measured.mat'); %TDOA measurements


%% Set Parameters
ranges=200:1000;  %set ranges within the grid (in [m])
depths=20:40;     %set depths within the grid (in [m])
plot_flag=1;      
P = 3;           % PxP transition window
B = 1000;        % Beam width

%% Construct grid
cd(Program_Folder);
[R_mesh, Z_mesh, stateGrid, MU, L_chol, activeSet]=Construct_precomputed_grid(Main_Folder,ranges, depths);


%% Run dynamic-programing based localization:
cd(Program_Folder);
[Emission_lattice,r_true,z_true]=Evaluate_Emissions(Ranges_GT,TDOA_measured,activeSet,MU,L_chol,stateGrid,R_mesh);
[path_z, path_r] = viterbi_beamsearch(Emission_lattice, P, B);
R_estimated=ranges(path_r);  
Z_estimated=depths(path_z);  

%% Visualize results

 if plot_flag
    figure;
    plot(R_estimated,Z_estimated,'m*','LineWidth',2);  hold on; grid on;
    plot(r_true,z_true,'k*','LineWidth',2); hold on; grid on; set(gca, 'YDir','reverse');
     legend('Proposed','Ground truth')
    set(gca,'FontSize',12); 
    ylabel('Depth [m]'); xlabel('Range [m]');            
 end
