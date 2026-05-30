function [C_inds,S_g_min]=Cluster_MPS(Waveform_Likelihood,MPS_vec,Locs,Amp,Th_C)

%   AUTHOR:         Guy Gubnitsky
%   DATE:           September 2023
%   DESCRIPTION:

%   This function gets a vector of M transients and outputs a vector
%   contains the indices of suspected sperm whale Echolocation clicks 
%   and one scalar representing a detection score. 

%   INPUT:
%   > MPS_vec               - Vector of 1XM with MPS estimations of each identified transient.
%   > Locs                  - Vector of 1XM with time of arrival in seconds for M identified transients
%   > Amp                   - Vector of 1XM containing the amplitudes of M identified transients
%   > Waveform_Likelihood   - Vector of 1XM with spectrogram-based likelihood scores of each identified transient.
%   > Th_C                  - Scalar threshold for the clicks' likelihood

%   OUTPUT:
%   > C_inds                - Vector of 1XK with indices of suspected sperm whale clicks 
%   > S_g_min               - scalar representing the utility score associated with the clustered clicks.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main parameters:

    ICI_Min=0.4; % Minimum allowed ICI 
    ICI_Max=2;   % Maximum allowed ICI
    alpha1=20;   % Normalizing factor to weight the penalty over the cluster’s rank
    alpha2=1;    % Normalizing factor to weight the penalty over the cluster’s amplitude stability
    
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% Clustering initialization:

    Score=100*ones(1,7);
    MPS_input=1e3*MPS_vec;
    Corresponing_clusters={};
    All_clusters=[]; All_U=[];

%% Clustering: phase 1- ICI and consistency contraints    
    for i=3:7
         v = 1:length(Locs);
         AllCombs = nchoosek(v,i);
         AllCombs_bank(i).comb=AllCombs;
         ICI_mat=diff(Locs(AllCombs),1,2);
         ICI_n1=ICI_mat(:,2:end); ICI_n0=ICI_mat(:,1:end-1);
         Consi_max=max(abs(log(ICI_n1./ICI_n0)),[],2);
         ICI_g_max=max(diff(Locs(AllCombs),1,2),[],2);
         ICI_g_min=min(diff(Locs(AllCombs),1,2),[],2);
         S_g=std(MPS_input(AllCombs),1,2);
         J_g=1-JF(Amp(AllCombs));

         G_ind=find(ICI_g_min>ICI_Min & ICI_g_max<ICI_Max & Consi_max<0.22);  

        U=S_g(G_ind)+alpha1*exp(-i)+alpha2*J_g(G_ind);
        Pick_inds=find(U<3); Utility=U(Pick_inds);
        Chosen_clusters=AllCombs(G_ind(Pick_inds),:);
        Chosen_clusters_indexed=mat2inds(Chosen_clusters,length(Locs));

        All_clusters=[All_clusters ; Chosen_clusters_indexed];
        All_U=[All_U ; Utility];
    end

%% Clustering: phase 2- ortogonality contraint    

     c=0;
     v = 1:length(All_U);
     for i=1:floor(length(All_U)/2)
       NOG(i) = nchoosek(length(All_U),i);  %Number of combinations per number of groups
     end
     if length(All_U)>1
        Nc=max(find(NOG<1081575));
     else
        Nc=1;
     end
     for i=1:Nc
         AllCombs = nchoosek(v,i);
         if i==1
            Ortogonal_inds=AllCombs;
         elseif i>1 
            M_criterion=Slice_sum(All_clusters,AllCombs,i);
            Ortogonal_inds=find(M_criterion==1);
         end
         if length(Ortogonal_inds)>1
              U_cands=1/i+sum(All_U(AllCombs(Ortogonal_inds,:)),2);
         elseif ~isempty(Ortogonal_inds)
             U_cands=1/i+sum(All_U(AllCombs(Ortogonal_inds,:)));
         else
             U_cands=[];
         end
         if ~isempty(U_cands)
             c=c+1;
             Score(c)=min(U_cands) ;
             Corresponing_clusters(c)={All_clusters(AllCombs(Ortogonal_inds(find(U_cands==Score(c))),:)',:)};

         else
             c=c+1;
             Score(c)=100;
         end
     end

%% Clustering: phase 3- verification (spectrogram-likelihood contraint)    

    C_inds=[];    
    S_g_min=min(Score);
    if S_g_min<100
        Chosen_bank=cell2mat(Corresponing_clusters(Score==S_g_min));
        for i=1:size(Chosen_bank,1)
            C_inds=[C_inds find(Chosen_bank(i,:)==1)]; 
            C_modified=find(Chosen_bank(i,:)==1);
            Discard_inds=Waveform_Likelihood(C_modified)<Th_C;
            C_modified(Discard_inds)=[]; 
%             C_inds(i)={C_modified};
            S_g_min_cl(i)=std(MPS_input(C_modified))+alpha1*exp(-length(C_modified))+alpha2*(1-JF(Amp(C_modified)));
        end
        C_inds=unique(C_inds);
        S_g_min=1/i+sum(S_g_min_cl);
    end

  
        
end
