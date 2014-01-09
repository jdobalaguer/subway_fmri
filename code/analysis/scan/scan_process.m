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
    dir_datregs                    = [pwd(),filesep,'data',filesep,'process',filesep,'regressors',filesep];
    dir_datglm1s                    = [pwd(),filesep,'data',filesep,'process',filesep,'firstlevel',filesep];
    dir_datglm2s                    = [pwd(),filesep,'data',filesep,'process',filesep,'secondlevel',filesep];
    file_datsubs                   = dir([dir_datsubs,'data_*.mat']); file_datsubs = strcat(dir_datsubs,strvcat(file_datsubs.name));
    file_datregs                   = dir([dir_datregs,'regressors_*_reg.mat']); file_datregs = strcat(dir_datregs,strvcat(file_datregs.name));
    file_datreas                   = dir([dir_datregs,'regressors_*_rea.mat']); file_datreas = strcat(dir_datregs,strvcat(file_datreas.name));
    
    % VARIABLES
    nb_subjects = size(dir_niisubs, 1);
    nb_runs     = size(dir_niiruns, 1);
    u_subject   = 1:nb_subjects;
    u_run       = 1:nb_runs;
    u_contrast  = {};
    
    % PARAMETERS
    pars_tr      = 2;
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    build_regressors();         % build regressors
%     glm_first_level();          % GLM first level: build
%     glm_first_estimate();       % GLM first level: estimate
%     glm_first_contrasts();      % GLM first level: contrasts
%     glm_second_copy();         % GLM first level: rename
%     glm_second_level();         % GLM second level
    toc();
    
    %% BUILD REGRESSORS
    function build_regressors()
        % make directory
        if ~exist(dir_datregs,'dir'); mkdirp(dir_datregs); end
        % load regressors
        [timeruns,dataruns] = scan_loadregressors(session);
        j_run = 0;
        for i_sub = u_subject
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
                file_niirea    = dir([dir_niiimg,'rp_image*.txt']);   file_niirea = strcat(dir_niiimg,strvcat(file_niirea.name));
                file_niiimg    = dir([dir_niiimg,'swauimages*.nii']); file_niiimg = strcat(dir_niiimg,strvcat(file_niiimg.name));
                % save regressors
                reg = struct();
                u_fields = fieldnames(timeruns{j_run});
                reg.names = {};
                reg.onsets = {};
                reg.durations = {};
                for i_field = 1:length(u_fields)
                    if ~isempty(timeruns{j_run}.(u_fields{i_field}))
                        nb_nii = size(file_niiimg,1);
                        nb_ons = timeruns{j_run}.(u_fields{i_field})/pars_tr;
                        tmp_onset = timeruns{j_run}.(u_fields{i_field});
                        if any(nb_ons>nb_nii)
                            fprintf('    warning. max(%s) = %d onsets for %d scans\n',u_fields{i_field},round(max(nb_ons)),nb_nii);
                            tmp_onset(nb_ons>nb_nii) = [];
                        end
                        reg.names{end+1}      = u_fields{i_field};
                        reg.onsets{end+1}     = timeruns{j_run}.(u_fields{i_field});
                        reg.durations{end+1}  = 0;
                    end
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
        u_contrast = u_fields;
    end
    
    %% GLM FIRST LEVEL
    function glm_first_level()
        if ~exist(dir_datglm1s,'dir'); mkdirp(dir_datglm1s); end
        
        jobs = {};
        j_run = 0;
        for i_sub = u_subject
            dir_niiepi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_datglm1 = sprintf('%ssub_%d/',dir_datglm1s,i_sub);
            if ~exist(dir_datglm1,'dir'); mkdirp(dir_datglm1); end
            jobs{i_sub}.spm.stats.fmri_spec.dir = {dir_datglm1};
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
            % others
            jobs{i_sub}.spm.stats.fmri_spec.fact = struct('name',{},'levels',{});
            jobs{i_sub}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            jobs{i_sub}.spm.stats.fmri_spec.volt = 1;
            jobs{i_sub}.spm.stats.fmri_spec.global = 'None';
            jobs{i_sub}.spm.stats.fmri_spec.mask = {''};
            jobs{i_sub}.spm.stats.fmri_spec.cvi = 'AR(1)';
        end
        spm_jobman('run',jobs);
    end
    
    %% GLM FIRST LEVEL: Estimate
    function glm_first_estimate()
        jobs = {};
        for i_sub = u_subject
            dir_datglm1 = sprintf('%ssub_%d/',dir_datglm1s,i_sub);
            fprintf('GLM first level estimate for: subject %s\n',dir_datglm1);
            jobs{i_sub}.spm.stats.fmri_est.spmmat = {[dir_datglm1,'SPM.mat']};
            jobs{i_sub}.spm.stats.fmri_est.method.Classical = 1;
        end
        spm_jobman('run',jobs);
    end
    
    %% GLM FIRST LEVEL: Contrasts
    function glm_first_contrasts()
        jobs = {};
        for i_sub = u_subject
            fprintf('GLM first level contrasts for: subject %d\n',i_sub);
            dir_datglm1 = sprintf('%ssub_%d/',dir_datglm1s,i_sub);
            jobs{i_sub}.spm.stats.con.spmmat = {[dir_datglm1,'SPM.mat']};
            for i_tcon = 1:length(u_contrast)
                jobs{i_sub}.spm.stats.con.consess{i_tcon}.tcon.name            = u_contrast{i_tcon};
                jobs{i_sub}.spm.stats.con.consess{i_tcon}.tcon.convec(i_tcon)  = 1;      % [0 .. 0 1]
                jobs{i_sub}.spm.stats.con.consess{i_tcon}.tcon.sessrep         = 'replsc';
            end
            jobs{i_sub}.spm.stats.con.delete = 1;
        end
        spm_jobman('run',jobs);
    end
    
    %% GLM SECOND LEVEL: Copy files
    function glm_second_copy()
        for i_sub = u_subject
            fprintf('GLM second level copy for: subject %d\n',i_sub);
            for i_con = 1:length(u_contrast)
                dir_datglm1 = sprintf('%ssub_%d/',dir_datglm1s,i_sub);
                dir_datglm2 = sprintf('%scon_%s/',dir_datglm2s,u_contrast{i_con});
                if ~exist(dir_datglm2,'dir'); mkdirp(dir_datglm2); end
                copyfile(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),sprintf('%sspmT_sub%d_con%d.hdr',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),sprintf('%sspmT_sub%d_con%d.img',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.hdr' ,dir_datglm1,i_con),sprintf('%scon_sub%d_con%d.hdr' ,dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.img' ,dir_datglm1,i_con),sprintf('%scon_sub%d_con%d.img' ,dir_datglm2,i_sub,i_con));
            end
        end
    end
    
    %% GLM SECOND LEVEL
    function glm_second_level()
        jobs = {};
        j_job = 0;
        for i_con = 1:length(u_contrast)
            fprintf('GLM second level for: contrast "%s"\n',u_contrast{i_con});
            dir_datglm2 = sprintf('%scon_%s/',dir_datglm2s,u_contrast{i_con});
            % design
            j_job = j_job+1;
            jobs{j_job}.spm.stats.factorial_design.dir                      = {dir_datglm2};
            jobs{j_job}.spm.stats.factorial_design.des.t1.scans             = cellstr(spm_select('FPlist', dir_datglm2, '^spmT_.*\.img$'));
            jobs{j_job}.spm.stats.factorial_design.cov                      = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
            jobs{j_job}.spm.stats.factorial_design.masking.tm.tm_none       = 1;    % threshold masking
            jobs{j_job}.spm.stats.factorial_design.masking.im               = 1;    % implicit mask
            jobs{j_job}.spm.stats.factorial_design.masking.em               = {''}; % explicit mask
            jobs{j_job}.spm.stats.factorial_design.globalc.g_omit           = 1;    % dont know what it is
            jobs{j_job}.spm.stats.factorial_design.globalm.gmsca.gmsca_no   = 1;    % grand mean scaling
            jobs{j_job}.spm.stats.factorial_design.globalm.glonorm          = 1;    % global normalization
            % estimate
            j_job = j_job+1;
            jobs{j_job}.spm.stats.fmri_est.spmmat           = {[dir_datglm2,'SPM.mat']};
            jobs{j_job}.spm.stats.fmri_est.method.Classical = 1;
            % contrast
            j_job = j_job+1;
            jobs{j_job}.spm.stats.con.spmmat                    = {[dir_datglm2,'SPM.mat']};
            jobs{j_job}.spm.stats.con.consess{1}.tcon.name      = u_contrast{i_con};
            jobs{j_job}.spm.stats.con.consess{1}.tcon.convec    = 1; % contrast vector, here just 1, (simple T)
            jobs{j_job}.spm.stats.con.consess{1}.tcon.sessrep   = 'none';
            jobs{j_job}.spm.stats.con.delete = 1;
        end
        spm_jobman('run',jobs);
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