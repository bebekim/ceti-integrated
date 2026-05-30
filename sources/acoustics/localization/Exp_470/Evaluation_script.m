
ranges=200:1000;
depths=20:40;

% Create grid of all [r, z] pairs
[R_mesh, Z_mesh] = meshgrid(ranges, depths);

% Convert to Nx2 stateGrid: each row is [r z]
stateGrid = [R_mesh(:), Z_mesh(:)];

 Loop_size=round(size(stateGrid,1)/100);

cd('C:\Users\User\Desktop\SW localization\2025_08_12_bouy_test_haifa_bay\Exp_grid_precomputation');

files=dir("Lchol_*.mat");
for L=1:98%length(files)
    L
    load(['mu_' num2str(L) '.mat'])
    load(['Lchol_' num2str(L) '.mat'])
    MU_all(:,1,(L-1)*Loop_size+1:L*Loop_size)=MU(:,1,(L-1)*Loop_size+1:L*Loop_size);
    Lchol_all(:,:,1,(L-1)*Loop_size+1:L*Loop_size)=L_chol(:,:,1,(L-1)*Loop_size+1:L*Loop_size);
   end

MU=MU_all;
L_chol=Lchol_all;


cd('C:\Users\User\Desktop\SW localization\2025_08_12_bouy_test_haifa_bay\Exp_260')
%% System Parameters

load Z_profile.mat
load ssp.mat
ssp=ssp';

cd('C:\Users\User\Desktop\SW localization\Final\server')

% Vertical sound speed mode g(z) - linearly increasing from 0 at 30m to 1 at surface
g_mode = @(z) max(0, 1 - z/30);

stateGrid_sim=stateGrid(1:size(stateGrid,1)-1,:);
activeSet=1:15000;%size(stateGrid,1)-1;


% Measurement uncertainties
sigma_tdoa = 0.0001;    % 0.1 ms TDOA measurement error (s)
sigma_h =  0.5;          % hydrophone depth uncertainty (m)
sigma_h_sensor=0.1;
sigma_c= 1;
plot_flag=1;
normal_flag=1;


         Fixed_MAP=[];
         Restults_Beysian_no_depth_sensor=[];
         N_mse=[];
         X_store_no_depth_sensor=[];

cd('C:\Users\User\Desktop\SW localization\2025_08_12_bouy_test_haifa_bay\Exp_790')
load('ToA_datetime.mat');
load('Ranges_GT.mat');
load('TDOA_GT.mat');
load('TDOA_measured.mat');

cd('C:\Users\User\Desktop\SW localization\Final\server')

        for pos=1:length(Ranges_GT)
            pos
 
             r_true(pos)=Ranges_GT(pos);
             z_true(pos)=24;

             config = setup_vertical_array(r_true(pos),z_true(pos));

           if normal_flag
               Delta_h= randn * sigma_h;
           else
              Delta_h= (rand * 2 - 1) * 4 * sigma_h;
           end

           h1_actual = 20;
           h2_actual = 100;

           c_profile= ssp + sigma_c*randn(size(ssp));
           actual_positions = [0, 0, h1_actual, 0, 0, h2_actual];       
       
           cd('C:\Users\User\Desktop\SW localization\Final\server')
         
        c_func = create_sound_speed_function(z_profile, c_profile, g_mode, 0);
        result=whale_localization_bayesian_refraction(r_true(pos),z_true(pos),sigma_h_sensor,c_func,sigma_tdoa,h1_actual,h2_actual,0);

        new_obs=TDOA_measured(:,pos)/1e3; %result.observations;
       
        result_no_depth_sensor=whale_localization_bayesian_refraction(r_true(pos),z_true(pos),sigma_h,c_func,sigma_tdoa,h1_actual,h2_actual,0);
        new_obs_no_depth_sensor=result_no_depth_sensor.observations;

        cd('C:\Users\User\Desktop\SW localization\advanced\copy\constant ssp\Hadera_Exp\Baysian_general')
        
           BI_results=result_no_depth_sensor.final_estimate;
           Restults_Beysian_no_depth_sensor(pos,:)=BI_results(2:3);
           Cov_tmp_no_depth_sensor=result_no_depth_sensor.covariance;
           Cov_Beysian_no_depth_sensor(pos)={Cov_tmp_no_depth_sensor(2:3,2:3)};
            
%% emission likelihoods

           
           accepted_indices=activeSet; %gating_indices(Bx,new_obs);
           [Likelihood_sim,d2]=fast_Likelihood_estimation(new_obs,MU(:,1,accepted_indices),L_chol(:,:,1,accepted_indices));    

            % Initialize full P_MAP grid with NaNs
            P_MAP_full = NaN(size(stateGrid, 1), 1);

            % % Assign computed values only at activeSet indices
            P_MAP_full(accepted_indices) = Likelihood_sim;

            % Reshape to grid shape for visualization
            P_MAP_grid = reshape(P_MAP_full, size(R_mesh));
        
            % figure; imagesc(ranges,depths,P_MAP_grid); colormap('jet') 
            % figure; imagesc(ranges,depths,P_MAP_grid_depth); colormap('jet') 
            
             Fixed_MAP(:,:,pos)=P_MAP_grid;

            %  %% NMSE computation

            % Compute differences
            Diff       = MU - new_obs;        % 3 x 1 x Q
            
            % Reshape to 2D matrices: dims x Q
            diff_r       = reshape(Diff,       size(Diff,1), []);  % 3 x Q
            
            % Normalize by the squared value of the true observation
            % Avoid division by zero
            new_obs_eps       = new_obs;       new_obs_eps(new_obs_eps==0) = eps;
            
            % Compute NMSE
            nmse_tdoa  = mean((diff_r       ./ new_obs_eps).^2, 1);   % 1 x Q
            
            % Find the best-matching state by minimal NMSE
            [~, idx_tdoa]  = min(nmse_tdoa);
            
            % Assign matched states
            N_mse(pos,:)       = stateGrid(idx_tdoa, :);
        
        end
        
        E = Fixed_MAP(:,:,1:pos);  % Example emission matrix
        P = 3;                   % 5x5 transition window
        B = 1000;                  % Beam width
        
        [path_z, path_r] = viterbi_beamsearch(E, P, B);
        R_viterbi=ranges(path_r);  
        Z_viterbi=depths(path_z);  
         %close;
        
        dt = 1.0;                % Time step
        F = eye(2);              % No motion model (identity)
        H = eye(2);              % Direct observation of position
        Q = 1 * eye(2);          % Process noise

        x_no_depth_sensor = Restults_Beysian_no_depth_sensor(1,:)' ;   % Initial state: [range; depth;]
        P_no_depth_sensor = Cov_Beysian_no_depth_sensor{1};                   % Initial covariance

        N = size(Restults_Beysian_no_depth_sensor,1);
        X_store_no_depth_sensor = zeros(2, N);  
        Cov_store_no_depth_sensor = zeros(2, N); 

        % Store
        X_store_no_depth_sensor(:,1) = x_no_depth_sensor;       
        Cov_store_no_depth_sensor(:,1) = diag(P_no_depth_sensor); 

        for k = 2:N
            % Predict
            P_pred = F * P * F' + Q;

            x_pred_no_depth_sensor = F * x_no_depth_sensor;
            P_pred_no_depth_sensor = F * P_no_depth_sensor * F' + Q;

            % Observation and covariance

            z_no_depth_sensor = Restults_Beysian_no_depth_sensor(k,:)';
            R_no_depth_sensor = Cov_Beysian_no_depth_sensor{k};

            % Innovation
            y_no_depth_sensor = z_no_depth_sensor - H * x_pred_no_depth_sensor;
            S_no_depth_sensor = H * P_pred_no_depth_sensor * H' + R_no_depth_sensor;
            K_no_depth_sensor = P_pred_no_depth_sensor * H' / S_no_depth_sensor;

            % Update
            x_no_depth_sensor = x_pred_no_depth_sensor + K_no_depth_sensor * y_no_depth_sensor;
            P_no_depth_sensor = (eye(2) - K_no_depth_sensor * H) * P_pred_no_depth_sensor;

            % Store

            X_store_no_depth_sensor(:,k) = x_no_depth_sensor;
            Cov_store_no_depth_sensor(:,k) = diag(P_no_depth_sensor);

        end


         if plot_flag
            figure;
            plot(N_mse(:,1),N_mse(:,2),'b*','LineWidth',2); hold on; grid on;
            plot(Restults_Beysian_no_depth_sensor(:,1),Restults_Beysian_no_depth_sensor(:,2),'r*','LineWidth',2);
            plot(X_store_no_depth_sensor(1,:),X_store_no_depth_sensor(2,:),'g*','LineWidth',2);
            plot(R_viterbi,Z_viterbi,'m*','LineWidth',2);  hold on; grid on;
            plot(r_true,z_true,'k*','LineWidth',2); hold on; grid on; set(gca, 'YDir','reverse');
            % plot(R_viterbi,Z_viterbi,'mx--');
            legend('NMSE','LGMI','LGMI+EKF','Viterbi','Ground truth')
            % legend('Viterbi','Ground truth')
            set(gca,'FontSize',12); title('depth sensors absent');
            ylabel('Depth [m]'); xlabel('Range [m]');            
          
         end

        cd('C:\Users\User\Desktop\SW localization\2025_08_12_bouy_test_haifa_bay\Exp_790')

        

  

 