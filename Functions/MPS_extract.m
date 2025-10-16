function [MPS_vec,MPS_2_vev]=MPS_extract(MPS_max,Fs,Y_zoom,Locs)

            W=MPS_max*Fs;
            for j=1:length(Locs)
                Y_bank=Y_zoom(int32(Locs(j)*Fs-W):int32(Locs(j)*Fs+W));
                [MPS_vec(j),MPS_2_vev(j)]=MPS_estimate(Y_bank,Fs);
            end
            
end



