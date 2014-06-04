
function scan_clean()
    %% WARNINGS
    %#ok<*DEFNU>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_dcm                   = [pwd(),filesep,'data',filesep,'dcm',filesep];
    dir_nii                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_nii,'sub_*']); dir_subs = strcat(dir_nii,strvcat(dir_subs.name),'/');
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    dir_epis4                   = strcat(dir_subs,'epi4',filesep);
    
    % PARAMETERS
    pars_voxs    = 4;
    
    % VARIABLES
    nb_subjects = size(dir_subs, 1); 
    u_subject   = 1:nb_subjects;
    
    %% JOBS
    clean_dcm();                                % clean dicom
    %clean_str();                                % clean structural
    %clean_epi4();                               % clean epi4
    %clean_epi3_img();                           % clean epi3 image
    clean_epi3_rea();                           % clean epi3 realignment
    clean_epi3_nor();                           % clean epi3 normalisation
    %clean_epi3_smt();                           % clean epi3 smooth

    %% CLEAN FILES
    % dicom
    function clean_dcm()
        if exist(dir_dcm,'dir')>0
            rmdir(dir_dcm,'s');
        end
    end
    
    % structural
    function clean_str()
        for i_sub = u_subject
            dir_str = strtrim(dir_strs(i_sub,:));
            rmdir(dir_str,'s');
        end
    end
    
    % image (epi4)
    function clean_epi4()
        for i_sub = u_subject
            dir_epi4 = strtrim(dir_epis4(i_sub,:));
            rmdir(dir_epi4,'s');
        end
    end
    
    % image (epi)
    function clean_epi3_img()
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                rmdir(dir_img,'s');
            end
        end
    end
    
    % realignment (rea)
    function clean_epi3_rea()
        prefix = 'u';
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_rea = strcat(dir_run,'realignment',filesep);
                delete([dir_rea,'/',prefix,'*.nii']);
            end
        end
    end
    
    % normalisation (epi)
    function clean_epi3_nor()
        prefix = sprintf('w%du',pars_voxs);
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_nor = strcat(dir_run,'normalisation',filesep);
                delete([dir_nor,'/',prefix,'*.nii']);
            end
        end
    end
    
    % smooth (epi)
    function clean_epi3_smt()
        prefix = sprintf('sw%du',pars_voxs);
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_smt = strcat(dir_run,'smooth',filesep);
                delete([dir_smt,'/',prefix,'*.nii']);
            end
        end
    end
    
end
