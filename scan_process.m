function scan_process(session)
    if ~exist('session','var'); session = 'scanner'; end
    
    %% WARNING
    fprintf('\nmake sure you have same participants in data and nii folders!\n\n')

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                        = [fileparts(which('spm.m')),filesep];
    % nii
    dir_niistudy                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_niisubs                    = strcat(dir_niistudy,strvcat(strsplit(ls(dir_niistudy),{'\n','\t'})),filesep);
    dir_niiepis3                   = strcat(dir_niisubs,'epi3',filesep);
    dir_niiruns                    = strcat(strvcat(strsplit(ls([strtrim(dir_niisubs(1,:)),filesep,'epi3']),{'\n','\t'})),filesep);
    % data
    dir_datsubs                    = [pwd(),filesep,'data',filesep,'data',filesep,session,filesep];
    dir_datregs                    = [pwd(),filesep,'data',filesep,'regressors',filesep,session,filesep];
    file_datsubs                   = dir([dir_datsubs,'data_*.mat']); file_datsubs = strcat(dir_datsubs,strvcat(file_datsubs.name));
    file_datregs                   = dir([dir_datregs,'regressors_*_reg.mat']); file_datregs = strcat(dir_datregs,strvcat(file_datregs.name));
    file_datreas                   = dir([dir_datregs,'regressors_*_rea.mat']); file_datreas = strcat(dir_datregs,strvcat(file_datreas.name));
    
    % VARIABLES
    nb_subjects = size(dir_niisubs, 1);
    nb_runs     = size(dir_niiruns, 1);
    u_subject   = 1:nb_subjects;
    u_run       = 1:nb_runs;
    
    % PARAMETERS
    pars_tr      = 2;
    
    %% JOBS
    tic();
    build_regressors();         % build regressors
    glm_first_level();          % GLM first level: build
    glm_first_estimate();       % GLM first level: estimate
    glm_first_contrasts();      % GLM first level: contrasts
    glm_second_level();         % GLM second level
    toc();
    
    %% BUILD REGRESSORS
    function build_regressors()
        % make directory
        if ~exist(dir_datregs,'dir'); mkdirp(dir_datregs); end
        % load regressors
        [timeruns,dataruns] = scan_loadregressors(session);
        j_run = 0;
        for i_sub = 1:nb_subjects
            dir_niiepi3 = strtrim(dir_niiepis3(i_sub,:));
            fprintf('Building regressors for: %s\n',dataruns{j_run+1}.participant.name);
            for i_run = 1:nb_runs
                file_datreg = sprintf('%sregressors_%s_%d_reg.mat',dir_datregs,dataruns{j_run+1}.participant.name,i_run);
                file_datrea = sprintf('%sregressors_%s_%d_rea.mat',dir_datregs,dataruns{j_run+1}.participant.name,i_run);
                % index
                j_run = j_run+1;
                assert(j_run<=length(timeruns),'scan_process: build_regressors: error 1.');
                % dirs & files
                dir_niirun     = strcat(dir_niiepi3,strtrim(dir_niiruns(i_run,:)));
                dir_niiimg     = strcat(dir_niirun,'images',filesep);
                file_niirea    = dir([dir_niiimg,'rp_image*.txt']); file_niirea = strcat(dir_niiimg,strvcat(file_niirea.name));
                % save regressors
                reg = struct();
                u_fields = fieldnames(timeruns{j_run});
                for i_field = 1:length(u_fields)
                    reg.names{i_field}      = u_fields{i_field};
                    reg.onsets{i_field}     = timeruns{j_run}.(u_fields{i_field});
                    reg.durations{i_field}  = 0;
                end
                save(file_datreg,'reg');
                % save realignment
                R = load(file_niirea);
                save(file_datrea,'R');
            end
        end
        % update file_datregs
        file_datregs = dir([dir_datregs,'regressors_*_reg.mat']); file_datregs = strcat(dir_datregs,strvcat(file_datregs.name));
        file_datreas = dir([dir_datregs,'regressors_*_rea.mat']); file_datreas = strcat(dir_datregs,strvcat(file_datreas.name));
    end
    
    %% GLM FIRST LEVEL
    function glm_first_level()
        
        jobs = {};
        j_run = 0;
        for i_sub = u_subject
            dir_niiepi3 = strtrim(dir_niiepis3(i_sub,:));
            
            jobs{i_sub}.spm.stats.fmri_spec.dir = {dir_datregs};
            jobs{i_sub}.spm.stats.fmri_spec.timing.units  = 'secs';
            jobs{i_sub}.spm.stats.fmri_spec.timing.RT      = pars_tr;
            jobs{i_sub}.spm.stats.fmri_spec.timing.fmri_t  = 16;
            jobs{i_sub}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
            % session
            for i_run = u_run
                % index
                j_run = j_run + 1;
                % dirs & files
                dir_niirun = strcat(dir_niiepi3,strtrim(dir_niiruns(i_run,:)));
                dir_niiimg = strcat(dir_niirun,'images',filesep);
                file_niiimg = cellstr(spm_select('FPlist', dir_niiimg,'^swauimages.*\.nii'));
                file_datreg = strtrim(file_datregs(j_run,:));
                file_datrea = strtrim(file_datreas(j_run,:));
                % job
                jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).scans = file_niiimg;
                loadreg = load(file_datreg,'reg');
                for i_reg = 1:length(loadreg.reg.names)
                    jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).cond(i_reg).name     = loadreg.reg.names{i_reg};
                    jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).cond(i_reg).onset    = loadreg.reg.onsets{i_reg};
                    jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).cond(i_reg).duration = loadreg.reg.durations{i_reg};
                    jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).cond(i_reg).tmod     = 0;
                    jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).cond(i_reg).pmod     = struct('name', {}, 'param', {}, 'poly', {});
                end
                jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).multi_reg = {file_datrea};
                jobs{i_sub}.spm.stats.fmri_spec.sess(i_run).hpf = 128;
            end
            save('stats2')
            %% others
            jobs{i_sub}.spm.stats.fmri_spec.fact = struct([]);
            jobs{i_sub}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            jobs{i_sub}.spm.stats.fmri_spec.volt = 1;
            jobs{i_sub}.spm.stats.fmri_spec.global = 'None';
            jobs{i_sub}.spm.stats.fmri_spec.mask = {''};
            jobs{i_sub}.spm.stats.fmri_spec.cvi = 'AR(1)';

        end
%         job_id = cfg_util('initjob', jobs);
%         cfg_util('run', job_id);
%         cfg_util('deljob', job_id);
    end
    
    %% GLM FIRST LEVEL: Estimate
    function glm_first_estimate()
    end
    
    %% GLM FIRST LEVEL: Contrasts
    function glm_first_contrasts()
    end
    
    %% GLM SECOND LEVEL
    function glm_second_level()
    end
    
end

%% extra functions
function mkdirp(path)
    assert(~ispc(),'mkdirp: doesnt work under win');
    if path(1  )~='/'; path = [pwd(),filesep(),path]; end
    if path(end)=='/'; path(end)=[];                  end
    i_filesep = find(path=='/',1,'last');
    rootpath = path;
    rootpath(i_filesep:end) = [];
    if ~exist(rootpath,'dir'); mkdirp(rootpath); end
    mkdir(path);
end