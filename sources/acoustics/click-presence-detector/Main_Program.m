%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%% Unsupervised detector for sperm whale clikcs%%%
                     %% Main script%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc;

CF=pwd; % Current folder
PF=[CF '\Functions'] ; % Program folder

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load spectogram joint pdf template:

cd(PF)
WL=load('Waveform_likelihood_rep');
WI=load('Waveform_input_rep');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters settings:

[DF,files,NOI,SNR_thresh,Sig_T,MPS_window,T_sec,Plot_flag]=DB_prompt(CF);
   
F_low = 2e3;        % BPF: lower pass-band frequency bound
F_high = 24e3;      % BPF: higher pass-band frequency bound
FsAnalyze = 48e3;   % Min frequency for decimation purposes

%% Run detector

for file_ind=1:length(files)
        cd(DF)
        filename=files(file_ind).name;
        [y,Fs] = audioread(filename);                 % load recordings
        Y=y(:,1);                                     % Choose one chanel from the WRU
        cd(PF)
        if Fs > FsAnalyze
            S_factor=floor(Fs/FsAnalyze);             % Define factor for resampling towards 48khz  
        else
            S_factor=1;
        end
        File_duration=(1/Fs)*(length(Y)-1);           % Calculate duration of the loaded recording
        Y_decimated = decimate(Y,S_factor);           % Resample recording 
        F_ds=Fs/S_factor;                             % Sample frequency of the decimated recording (48khz by default)       
        T=F_ds*T_sec;                                 % Set duration for the analysis buffer [in samples]
        if isempty(NOI)
            NOI=ceil(File_duration/T_sec);            % Calculate the number of iteration within the analyzed recording
        end
        
        for Buffer_ind=1:NOI   % Run detector on each buffer

            if S_factor>1
              Y_filtered=bandpass(Y_decimated(int32((Buffer_ind-1)*T+1):int32((Buffer_ind-1)*T+T)),[F_low, F_high],F_ds);     % Aply band pass filter and extract buffer 
            else
              Y_filtered = highpass(Y_decimated(int32((Buffer_ind-1)*T+1):int32((Buffer_ind-1)*T+T)),F_low,F_ds);
            end
            clc
            fprintf(['\nProcessing: ' num2str(round(100*(Buffer_ind/(NOI*length(files))),2)) '%%']);
            
            [ey,~]=energyop(Y_filtered,0);          % Apply TKEO (ey is the output signal with enhanced SNR)
            ey_norm=ey/max(ey);                     % Normalize the enhaced signal ey          
            ty=[0:1/F_ds:(1/F_ds)*(length(Y_filtered)-1)]; 
            te=[0:1/F_ds:(1/F_ds)*(length(ey_norm)-1)];   
            [pks,locs] =findpeaks(ey_norm,F_ds,'MinPeakDistance',25e-3); % Detect transients

            [Locs,Pks,Amp,SNRs]=Transient_selection(Y_filtered,ey_norm,locs,pks,F_ds,SNR_thresh); % Eliminate transients bellow a pre-defined threshold
             
           if length(Locs)>2
               MPS_max=MPS_window*1e-3;
               El_inds=MPS_max+2e-3;
               Pks(Locs<El_inds | Locs>(T_sec-El_inds))=[];
               Locs(Locs<El_inds | Locs>(T_sec-El_inds))=[];
               [MPS_vec,MPS_2_vev]=MPS_extract(MPS_max,F_ds,Y_filtered,Locs);
               ToAs=Locs;
               ToAs_2=MPS_2_vev;
               Waveform_Likelihood=[];
               for wf=1:length(ToAs)
                 Ind_min=val_return(ty,ToAs(wf));
                 [fm,Duration]=waveform_features_extraction(Y_filtered,F_ds,Ind_min,ToAs_2(wf),MPS_max);
                 WF(wf,:)=[Duration 1e-3*fm];
                 Waveform_Likelihood(wf)=Cal_stability_likelihood(WF(wf,:),'Waveform',wf,wf,WL,WI);
               end

               [Ck,S_g_min]=Cluster_MPS(Waveform_Likelihood,MPS_vec,Locs,Amp,0); % cluster transiets

               if S_g_min<Sig_T 
                   Class='SW';
               else
                   Class='Noise';
               end
    
               if Plot_flag
                   figure;set(gcf, 'Position', get(0,'Screensize'));
                   subplot(2,1,1); plot(ty,Y_filtered);
                   xlabel('t [sec]'); ylabel('Amplitude'); title('Signal after BPF');
                   set(gca,'FontSize', 11); 
                   subplot(2,1,2); plot(te,ey_norm); hold on; plot(Locs(Ck),Pks(Ck),'x','Linewidth',2)
                   xlabel('t [sec]'); ylabel('TKEO'); title(['Detected class:' Class]);
                   legend('',['Detected cluster (' ['U_T= ' num2str(round(S_g_min,2))] ')']); set(gca,'FontSize', 12);
               end
          end
        end 
end


