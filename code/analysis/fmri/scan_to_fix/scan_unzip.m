
function scan_unzip(varargin)
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
    
    %% JOBS
    for i_argin = 1:nargin
        switch varargin{i_argin}
            case 'dcm'
                unzip_dcm();
            case 'nii4'
                unzip_ep4();
            case 'nii3str'
                unzip_epi3_str();
            case 'nii3img'
                unzip_epi3_img();
            case 'nii3rea'
                unzip_epi3_rea();
            case 'nii3nor'
                unzip_epi3_nor();
            case 'nii3smt'
                unzip_epi3_smt();
        end
    end

    %% ZIP dcm
    function unzip_dcm()
        nb_subjects = size(dir_dcmsubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_sub = dir_dcmsubs(i_sub,:);
            zip_sub = [dir_sub(1:end-1),'.zip'];
            unzip(zip_sub,dir_sub);
            delete(zip_sub);
        end
    end
    
    %% ZIP epi4
    function unzip_epi4()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi4 = strtrim(dir_niiepis4(i_sub,:));
            zip_epi4 = [dir_epi4(1:end-1),'.zip'];
            unzip(zip_epi4,dir_epi4);
            delete(zip_epi4);
        end
    end

    %% ZIP epi3image
    function unzip_epi3_img()
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
                unzip(zip_img,dir_img);
                delete(zip_img);
            end
        end
    end

    %% ZIP epi3normalisation
    function unzip_epi3_nor()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            jb_parallel_progress();
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_nor = strcat(dir_run,'normalisation',filesep);
                zip_nor = strcat(dir_run,'normalisation.zip');
                if exist(zip_nor,'file') && ~exist(dir_nor,'dir')
                    unzip(zip_nor,dir_nor);
                    delete(zip_nor);
                end
            end
        end
        jb_parallel_progress(0);
    end
end
