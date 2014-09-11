
function scan_clean(varargin)
    %% WARNINGS
    %#ok<*DEFNU>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_dcm                   = [pwd(),filesep,'data',filesep,'dcm',filesep];
    dir_nii                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_nii,'sub_*']); dir_subs = strcat(dir_nii,strvcat(dir_subs.name),'/');
    dir_gres                    = strcat(dir_subs,'gre',filesep);
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    dir_epis4                   = strcat(dir_subs,'epi4',filesep);
    
    % PARAMETERS
    pars_voxs    = 4;
    
    % VARIABLES
    nb_subjects = size(dir_subs, 1); 
    u_subject   = 1:nb_subjects;
    
    %% JOBS
    for i_argin = 1:nargin
        switch varargin{i_argin}
            case 'dcm'
                clean_dcm();
            case 'nii4'
                clean_epi4();
            case 'gre'
                clean_gre();
            case 'str'
                clean_str();
            case 'strall'
                clean_strall();
            case 'nii3img'
                clean_epi3_img();
            case 'nii3spc'
                clean_epi3_spc();
            case 'nii3stc'
                clean_epi3_stc();
            case 'nii3rea'
                clean_epi3_rea();
            case 'nii3reall'
                clean_epi3_reall()
            case 'nii3nor'
                 clean_epi3_nor();
            case 'nii3smt'
                clean_epi3_smt();
            otherwise
                error('scan_zip: argument "%s" not valid.',varargin{i_argin});
        end
    end

    %% CLEAN FILES
    % dicom (dcm)
    function clean_dcm()
        fprintf('scan_clean: dcm \n');
        if exist(dir_dcm,'dir')>0
            rmdir(dir_dcm,'s');
        end
    end
    
    % fieldmap (gre)
    function clean_gre()
        fprintf('scan_clean: gre \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % clean dir
            dir_gre = strtrim(dir_gres(i_sub,:));
            if exist(dir_gre,'dir')>0, rmdir(dir_gre,'s'); end
            % clean zip
            zip_gre = [dir_gre(1:end-1),'.zip'];
            if exist(zip_gre,'file')>0, delete(zip_gre); end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end

    % structural (str)
    function clean_str()
        fprintf('scan_clean: str all \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % dir
            dir_str = strtrim(dir_strs(i_sub,:));
            if exist(dir_str,'dir')>0, rmdir(dir_str,'s'); end
            % clean files
            delete([dir_str,'*cimages*']);
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end
    function clean_strall()
        fprintf('scan_clean: str \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % clean dir
            dir_str = strtrim(dir_strs(i_sub,:));
            if exist(dir_str,'dir')>0, rmdir(dir_str,'s'); end
            % clean zip
            zip_str = [dir_str(1:end-1),'.zip'];
            if exist(zip_str,'file')>0, delete(zip_str); end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end
    
    % image (epi4)
    function clean_epi4()
        fprintf('scan_clean: epi4 \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % dir
            dir_str = strtrim(dir_epis4(i_sub,:));
            if exist(dir_str,'dir')>0, rmdir(dir_str,'s'); end
            % clean
            file_str = [dir_str(1:end-1),'.zip'];
            if exist(file_str,'file')>0, delete(file_str); end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end

    % image (nii3img)
    function clean_epi3_img()
        fprintf('scan_clean: epi3img \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % dirs
            dir_epi3    = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            % runs
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                zip_img = strcat(dir_run,'images.zip');
                % clean
                if exist(zip_img,'file')>0, delete(zip_img); end
                if exist(dir_img,'dir')>0,  rmdir( dir_img,'s'); end
            end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end
    
    % spikes correction (nii3spc)
    function clean_epi3_spc()
        fprintf('scan_clean: epi3spc \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % dirs
            dir_epi3    = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            % runs
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_spc = strcat(dir_run,'spikes',filesep);
                zip_spc = strcat(dir_run,'spikes.zip');
                % clean
                if exist(zip_spc,'file')>0, delete(zip_spc); end
                if exist(dir_spc,'dir')>0,  rmdir( dir_spc,'s'); end
            end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end
    
    % slice timing (nii3stc)
    function clean_epi3_stc()
        fprintf('scan_clean: epi3stc \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % dirs
            dir_epi3    = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            % runs
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_stc = strcat(dir_run,'slicetime',filesep);
                zip_stc = strcat(dir_run,'slicetime.zip');
                % clean
                if exist(zip_stc,'file')>0, delete(zip_stc); end
                if exist(dir_stc,'dir')>0,  rmdir( dir_stc,'s'); end
            end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
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
    
    % realignment (rea)
    function clean_epi3_reall()
        fprintf('scan_clean: epi3reall \n');
        prefix = 'u';
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_rea = strcat(dir_run,'realignment',filesep);
                zip_rea = strcat(dir_run,'realignment.zip');
                % clean
                if exist(zip_rea,'file')>0, delete(zip_rea); end
                if exist(dir_rea,'dir')>0,  rmdir( dir_rea,'s'); end
            end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end
    
    % normalisation (epi)
    function clean_epi3_nor()
        fprintf('scan_clean: epi3nor \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % dirs
            dir_epi3    = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            % runs
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_nor = strcat(dir_run,'normalisation',filesep);
                zip_nor = strcat(dir_run,'normalisation.zip');
                % clean
                if exist(zip_nor,'file')>0, delete(zip_nor); end
                if exist(dir_nor,'dir')>0,  rmdir( dir_nor,'s'); end
            end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end
    
    % smooth (epi)
    function clean_epi3_smt()
        fprintf('scan_clean: epi3smt \n');
        jb_parallel_progress(nb_subjects);
        for i_sub = u_subject
            % dirs
            dir_epi3    = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            % runs
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_smt = strcat(dir_run,'smooth',filesep);
                zip_smt = strcat(dir_run,'smooth.zip');
                % clean
                if exist(zip_smt,'file')>0, delete(zip_smt); end
                if exist(dir_smt,'dir')>0,  rmdir( dir_smt,'s'); end
            end
            % progress
            jb_parallel_progress();
        end
        jb_parallel_progress(0);
    end
    
end
