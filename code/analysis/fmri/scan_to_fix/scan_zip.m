
function scan_zip(varargin)
    %% WARNINGS
    %#ok<*DEFNU>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_dcm                   = [pwd(),filesep,'data',filesep,'dcm',filesep];
    dir_dcmsubs               = dir([dir_dcm,'sub_*']); dir_dcmsubs = strcat(dir_dcm,strvcat(dir_dcmsubs.name),'/');
    dir_nii                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_niisubs               = dir([dir_nii,'sub_*']); dir_niisubs = strcat(dir_nii,strvcat(dir_niisubs.name),'/');
    dir_strs                  = strcat(dir_niisubs,'str',filesep);
    dir_niiepis3              = strcat(dir_niisubs,'epi3',filesep);
    dir_niiepis4              = strcat(dir_niisubs,'epi4',filesep);
    
    %% DEFAULTS
    u_arg = varargin;
    n_arg = nargin();
    flag_delete = 1;
    
    if isnumeric(u_arg{1})
        flag_delete = u_arg{1};
        u_arg(1) = [];
        n_arg    = n_arg - 1;
    end
    
    %% JOBS
    for i_arg = 1:n_arg
        switch u_arg{i_arg}
            case 'dcm'
                zip_dcm();
            case 'nii4'
                zip_epi4();
            case 'nii3str'
                zip_epi3_str();
            case 'nii3img'
                zip_epi3_img();
            case 'nii3spc'
                zip_epi3_spc();
            case 'nii3stc'
                zip_epi3_stc();
            case 'nii3rea'
                zip_epi3_rea();
            case 'nii3nor'
                zip_epi3_nor();
            case 'nii3smt'
                zip_epi3_smt();
            otherwise
                error('scan_zip: argument "%s" not valid.',u_arg{i_arg});
        end
    end

    %% ZIP dcm
    function zip_dcm()
        nb_subjects = size(dir_dcmsubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_sub = dir_dcmsubs(i_sub,:);
            zip_sub = [dir_sub(1:end-1),'.zip'];
            zip(zip_sub,dir_sub);
            rmdir(dir_sub,'s');
        end
    end

    %% ZIP epi4
    function zip_epi4()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi4 = strtrim(dir_niiepis4(i_sub,:));
            zip_epi4 = [dir_epi4(1:end-1),'.zip'];
            if exist(dir_epi4,'dir') && ~exist(zip_epi4,'file'), zip(zip_epi4,dir_epi4); end
            if flag_delete && exist(dir_epi4,'dir'), rmdir(dir_epi4,'s'); end
        end
    end

    %% ZIP epi3image
    function zip_epi3_img()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                zip_img = strcat(dir_run,'images.zip');
                if exist(dir_img,'dir') && ~exist(zip_img,'file'), zip(zip_img,dir_img); end
                if flag_delete && exist(dir_img,'dir'), rmdir(dir_img,'s'); end
            end
        end
    end

    %% ZIP epi3spikes
    function zip_epi3_spc()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_spc = strcat(dir_run,'spikes',filesep);
                zip_spc = strcat(dir_run,'spikes.zip');
                if exist(dir_spc,'dir') && ~exist(zip_spc,'file'), zip(zip_spc,dir_spc); end
                if flag_delete && exist(dir_spc,'dir'), rmdir(dir_spc,'s'); end
            end
        end
    end

    %% ZIP epi3slicetime
    function zip_epi3_stc()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_stc = strcat(dir_run,'slicetime',filesep);
                zip_stc = strcat(dir_run,'slicetime.zip');
                if exist(dir_stc,'dir') && ~exist(zip_stc,'file'), zip(zip_stc,dir_stc); end
                if flag_delete && exist(dir_stc,'dir'), rmdir(dir_stc,'s'); end
            end
        end
    end

    %% ZIP epi3realignment
    function zip_epi3_rea()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_rea = strcat(dir_run,'realignment',filesep);
                zip_rea = strcat(dir_run,'realignment.zip');
                if exist(dir_rea,'dir') && ~exist(zip_rea,'file'), zip(zip_rea,dir_rea); end
                if flag_delete && exist(dir_rea,'dir'), rmdir(dir_rea,'s'); end
            end
        end
    end

    %% ZIP epi3normalisation
    function zip_epi3_nor()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_nor = strcat(dir_run,'normalisation',filesep);
                zip_nor = strcat(dir_run,'normalisation.zip');
                if exist(dir_nor,'dir') && ~exist(zip_nor,'file'), zip(zip_nor,dir_nor); end
                if flag_delete && exist(dir_nor,'dir'), rmdir(dir_nor,'s'); end
            end
        end
    end

    %% ZIP epi3smoothing
    function zip_epi3_smt()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_smt = strcat(dir_run,'smooth',filesep);
                zip_smt = strcat(dir_run,'smooth.zip');
                if exist(dir_smt,'dir') && ~exist(zip_smt,'file'), zip(zip_smt,dir_smt); end
                if flag_delete && exist(dir_smt,'dir'), rmdir(dir_smt,'s'); end
            end
        end
    end

end
