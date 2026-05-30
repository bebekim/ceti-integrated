function [DF,files,NOI,SNR_thresh,Sig_T,MPS_window,T_sec,Plot_flag]=DB_prompt(PF)

    answer_Recording_Type = questdlg('Choose data folder', ...
    'Data folder', ...
    'Themo','Autec','Dominica','Other');
    % Handle response
    switch answer_Recording_Type
    case 'Themo'           
        DF=[PF '\Data\THEMO'];
    case 'Autec'
        DF=[PF '\Data\AUTEC'];
    case 'Dominica'
        DF=[PF '\Data\Dominica'];
    end

    cd(DF);
    prompt = {'Recording name:','Recording format:'};
    dlgtitle = 'Input'; 
    dims = [1 35];
    switch answer_Recording_Type
        case 'Themo'           
            definput = {'*Noise_rec*','flac'};
        case 'Autec'
            definput = {'*10M*','wav'};
        case 'Dominica'
            definput = {'*SW_rec*','wav'};
    end
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    files=dir([cell2mat(answer(1)) '.' cell2mat(answer(2))]);
    cd(PF)


    prompt = {'How many buffers to process? (leave empty if you wish processing the entire recording)'};
    dlgtitle = 'Input'; 
    dims = [1 35];
    definput = {''};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if ~isempty(intersect(answer{1},'*'))
        NOI=[];
    else
        NOI=str2num(answer{1});
    end

    prompt = {'Set a threshold over min SNR [dB]: '};
    dlgtitle = 'Input'; 
    dims = [1 35];
    definput = {'23'};
    answer_scr = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer_scr{1})
        SNR_thresh=23;
    else
        SNR_thresh=str2num(answer_scr{1});
    end


    prompt = {'Set a time buffer length [sec]: '};
    dlgtitle = 'Input'; 
    dims = [1 35];
    definput = {'10'};
    answer_scr = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer_scr{1})
        T_sec=10;
    else
        T_sec=str2num(answer_scr{1});
    end
    
    prompt = {'Set window for MPS estimation [ms]: '};
    dlgtitle = 'Input'; 
    dims = [1 35];
    definput = {'40'};
    answer_scr = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer_scr{1})
        MPS_window=40;
    else
        MPS_window=str2num(answer_scr{1});
    end
    
    prompt = {'Set a detection threshold U_T [ms]: '};
    dlgtitle = 'Input'; 
    dims = [1 35];
    switch answer_Recording_Type
        case 'Themo'           
            definput = {'1.42'};
        case 'Autec'
            definput = {'2.1'};
        case 'Dominica'
            definput = {'1.42'};
    end
    answer_scr = inputdlg(prompt,dlgtitle,dims,definput);

    if isempty(answer_scr{1})
        Sig_T=1.42;
    else
        Sig_T=str2num(answer_scr{1});
    end
    
    answer_plot = questdlg('Visualize results?:','Plot activation','Yes','No','Other');
    % Handle response
    switch answer_plot
        case 'Yes'
            Plot_flag = 1;
        case 'No'
            Plot_flag = 0;
    end

end