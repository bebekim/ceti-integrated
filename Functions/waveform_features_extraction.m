function [fm,Duration]=waveform_features_extraction(s,Fs,Ind_min,p_2,MPS_max) 

    frame=8e-3;
    W_size=int32(Fs*frame);
    Analysis_w=s(Ind_min-W_size:Ind_min+W_size);
    t_w=[0:1/Fs: (1/Fs)*(length(Analysis_w)-1)]';
    fois    = linspace(2e3,24e3,100);
    srord   = [1, 3];
    Pf=aslt(Analysis_w, Fs, fois, 3, srord, 0); 
    Pfn=Pf/max(max(Pf));
    
%     figure; imagesc(t_w*1e3, 1e-3*fois, Pf);
%     set(gca, 'ydir', 'normal'); xlabel('time [ms]'); ylabel('frequency [kHz]');
%     set(gca,'FontSize', 12);
    [pi,ti]=find(Pfn==1); 
    fm=fois(pi);
    Power=log(Pf);
    BW=Power(pi,ti)-3;
%     figure; plot(1e3*t_w,Power(pi,:),'Linewidth',2); hold on; plot(1e3*t_w,ones(1,length(t_w))*BW,'Linewidth',2);
%     xlabel('time [ms]'); ylabel('Power [dB]'); 
%     xlim([4.7 5.3]);
%     set(gca,'FontSize', 12);
    [x0,y0] = intersections(1e3*t_w,Power(pi,:),1e3*t_w,ones(1,length(t_w))*BW,1);
    t_low=x0(x0<1e3*t_w(ti));
    t_high=x0(x0>1e3*t_w(ti));
    if ~isempty(t_low) & ~isempty(t_high)
        D_vec=[t_low(end) t_high(1)];
    %     hold on; plot(D_vec,ones(1,2)*BW,'k*','Linewidth',2); 
       Duration=diff(D_vec);
    else
        Duration=2;
    end
    
    if fm>23e3
        Analysis_w2=s(Ind_min-int32(Fs*MPS_max):Ind_min+int32(Fs*MPS_max));
        t_w2=[0:1/Fs: (1/Fs)*(length(Analysis_w2)-1)]';
        frame2=1.5e-3;
        W_size2=int32(Fs*frame2);
        Ind_min2=int32(p_2*Fs);
        if Ind_min2>W_size2 & Ind_min2+W_size2<Analysis_w2(end)
            Analysis_2=Analysis_w2(Ind_min2-W_size2:Ind_min2+W_size2);
        elseif Ind_min2>W_size2 & Ind_min2+W_size2>Analysis_w2(end)
            Analysis_2=Analysis_w2(Ind_min2-W_size2:end);
        else
            Analysis_2=Analysis_w2(2*Ind_min2-W_size2:Ind_min2+W_size2);                    
        end
        t_2=[0:1/Fs: (1/Fs)*(length(Analysis_2)-1)]';
        Pf=aslt(Analysis_2, Fs, fois, 3, srord, 0); Pfn=Pf/max(max(Pf));
%         figure; imagesc(t_2*1e3, 1e-3*fois, Pf);
%         set(gca, 'ydir', 'normal'); xlabel('time [ms]'); ylabel('frequency [kHz]');
%         set(gca,'FontSize', 12);
        [pi,ti]=find(Pfn==1);        
        fm=fois(pi); 
        Power=log(Pf);
        BW=Power(pi,ti)-3;
%         figure; plot(1e3*t_2,Power(pi,:),'Linewidth',2); hold on; plot(1e3*t_2,ones(1,length(t_2))*BW,'Linewidth',2);
%         xlabel('time [ms]'); ylabel('Power [dB]'); 
%         set(gca,'FontSize', 12);
        [x0,~] = intersections(1e3*t_2,Power(pi,:),1e3*t_2,ones(1,length(t_2))*BW,1);
        t_low=x0(x0<1e3*t_2(ti));
        t_high=x0(x0>1e3*t_2(ti));
        if ~isempty(t_low) & ~isempty(t_high)
            D_vec=[t_low(end) t_high(1)];
            Duration=diff(D_vec);
        else
            Duration=2;
        end
    end

%     Binary=Pfn>0.35;
%     Binary(end,1:end)=zeros(1,size(Binary,2));
%     Binary(1,1:end)=zeros(1,size(Binary,2));
%     Binary(1:end,1)=zeros(1,size(Binary,1));
%     Binary(1:end,end)=zeros(1,size(Binary,1));
% 
%     m=iblobs(Binary);
%     Sorted_area=sort(m.area);
%     pick=find(m.area==Sorted_area(end-1));
%     D=1e3*(m(pick).umax-m(pick).umin)/Fs;
%     Duration=D(1);
end