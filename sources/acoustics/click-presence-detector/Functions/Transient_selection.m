function [Locs,Pks,Amp,SNRs]=Transient_selection(Y_filtered,ey_norm,locs,pks,F_ds,SNR_thresh)

%% Parameters settings
        locs_samples=locs*F_ds;
        SNR_window=F_ds*25e-3;
        crop=F_ds*8e-3;
        NOT=30;

%% Discard transients bellow a pre-defined SNR

        Locs=[]; Pks=[]; c=0;
        for i=1:length(locs)
            if locs_samples(i)>SNR_window && (locs_samples(i)+SNR_window)<length(ey_norm)
                tmp=Y_filtered(int32(locs_samples(i)-0.1*SNR_window):int32(locs_samples(i)+SNR_window));
                tmp_crop=Y_filtered(int32(locs_samples(i)-crop):int32(locs_samples(i)+crop));                            
                SNR(i)=10*log(max(abs(tmp))/median(abs(tmp))); 
                if SNR(i)>SNR_thresh
                    c=c+1;
                    Locs(c)=locs(i);
                    Pks(c)=pks(i);
                    Amp(c)=max(abs(tmp_crop));
                    SNRs(c)=SNR(i);
                end
            end
        end

%% Pick most the NOT (30 by default) most intense transients

       if length(Pks)>NOT
           [Pks2,I] = maxk(Pks,NOT);
           Locs2=Locs(I);
           Amp2=Amp(I);
           SNRs2=SNRs(I);
           Pks=Pks2;
           Locs=Locs2;
           Amp=Amp2;
           SNRs=SNRs2;
       end
       
%% Sort detections by time of arrival
       
       [Locs,LI]=sort(Locs);
       Pks=Pks(LI);
       Amp=Amp(LI);

end