function scan_process()
    
    %% WARNING
    fprintf('\nmake sure you have same participants in data and nii folders!\n\n')
    do_all = 0;

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                        = [fileparts(which('spm.m')),filesep];
    % nii
    dir_niistudy                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_niisubs                    = dir([dir_niistudy,'sub_*']); dir_niisubs = strcat(dir_niistudy,strvcat(dir_niisubs.name),'/');
    dir_niiepis3                   = strcat(dir_niisubs,'epi3',filesep);
    dir_niiruns                    = dir([strtrim(dir_niiepis3(1,:)),'run*']); dir_niiruns = strcat(strvcat(dir_niiruns.name),'/');
    % data
    dir_datsubs                    = [pwd(),filesep,'data',filesep,'data',filesep,'scanner',filesep];
    dir_process                    = [pwd(),filesep,'data',filesep,'process',filesep,'process',filesep];
    dir_datregs                    = [dir_process,'regressors',filesep];
    dir_datglm1s                   = [dir_process,'firstlevel',filesep];
    dir_datglm2s                   = [dir_process,'secondlevel',filesep];
    file_datsubs                   = dir([dir_datsubs,'data_*.mat']); file_datsubs = strcat(dir_datsubs,strvcat(file_datsubs.name));
    file_datregs                   = dir([dir_datregs,'regressors_*_reg.mat']); file_datregs = strcat(dir_datregs,strvcat(file_datregs.name));
    file_datreas                   = dir([dir_datregs,'regressors_*_rea.mat']); file_datreas = strcat(dir_datregs,strvcat(file_datreas.name));
    
    % VARIABLES
    nb_subjects = size(dir_niisubs, 1);
    nb_runs     = size(dir_niiruns, 1);
    u_subject   = [1,2]; %1:nb_subjects;
    u_run       = 1:nb_runs;
    u_regressor = {};
    u_modulator = {};
    u_contrast  = {};
    eval(fileread([dir_process,'process.m']));
    
    % PARAMETERS
    pars_tr      = 2;
    pars_voxs    = 4;
    
    % FLAGS
    do_all  = true;
    do_regs = do_all || ~exist(dir_datregs ,'file');
    do_frst = do_all || ~exist(dir_datglm1s,'file');
    do_scnd = do_all || true;
    
    %% DELETE
    if do_regs && exist(dir_datregs ,'dir'); rmdir(dir_datregs ,'s'); end
    if do_frst && exist(dir_datglm1s,'dir'); rmdir(dir_datglm1s,'s'); end
    if do_scnd && exist(dir_datglm2s,'dir'); rmdir(dir_datglm2s,'s'); end
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    build_regressors();         % build regressors
    glm_first_level();          % GLM first : level
    glm_first_estimate();       % GLM first : estimate
    glm_first_contrasts();      % GLM first : contrasts
    glm_second_copy();          % GLM second: copy
    glm_second_level();         % GLM second: level
    toc();
    
    %% BUILD REGRESSORS
    function build_regressors()
        if ~do_regs; return; end
        % make directory
        if ~exist(dir_datregs,'dir'); mkdirp(dir_datregs); end
        % load regressors
        [timeruns,dataruns] = scan_loadregressors('scanner',u_subject);
        j_run = 0;
        for i_sub = u_subject
            dir_niiepi3 = strtrim(dir_niiepis3(i_sub,:));
            fprintf('Building regressors for: %s\n',dir_niiepi3);
            for i_run = u_run
                file_datreg = sprintf('%sregressors_sub_%02i_run_%02i_reg.mat',dir_datregs,i_sub,i_run);
                file_datrea = sprintf('%sregressors_sub_%02i_run_%02i_rea.mat',dir_datregs,i_sub,i_run);
                % index
                j_run = j_run+1;
                assert(j_run<=length(timeruns),'scan_process: build_regressors: error 1.');
                % dirs & files
                dir_niirun     = strcat(dir_niiepi3,strtrim(dir_niiruns(i_run,:)));
                dir_niiimg     = strcat(dir_niirun,'images',filesep);
                file_niirea    = dir([dir_niiimg,'rp_image*.txt']);                       file_niirea = strcat(dir_niiimg,strvcat(file_niirea.name));
                file_niiimg    = dir([dir_niiimg,sprintf('sw%duimages*.nii',pars_voxs)]); file_niiimg = strcat(dir_niiimg,strvcat(file_niiimg.name));
                % create regressors
                reg = {};
                for i_reg = 1:length(u_regressor)
                    onset = get_regonset(timeruns{j_run},u_regressor{i_reg});
                    reg{end+1} = struct('name',     {u_regressor{i_reg}.name}, ...
                                        'onset',    {onset}                   , ...
                                        'duration', {0}                       );
                end
                % create modulators
                mod = {};
                for i_mod1 = 1:length(u_modulator)
                    onset = get_modonset(timeruns{j_run},u_modulator{i_mod1});
                    subnames = {};
                    levels   = {};
                    for i_mod2 = 1:length(u_modulator{i_mod1}.value)
                        level = zeros(size(onset));
                        for i_mod3 = 1:length(u_modulator{i_mod1}.value{i_mod2}.value)
                            onset_level = timeruns{j_run}.(u_modulator{i_mod1}.value{i_mod2}.value{i_mod3});
                            ii_level    = ismember(onset,onset_level);
                            v_level     = u_modulator{i_mod1}.value{i_mod2}.level(i_mod3);
                            level(ii_level) = v_level;
                        end
                        subnames{i_mod2} = u_modulator{i_mod1}.value{i_mod2}.name;
                        levels{i_mod2}   = level;
                    end
                    mod{end+1} = struct('name' ,    {u_modulator{i_mod1}.name}, ...
                                        'onset',    {onset}                   , ...
                                        'subname',  {subnames}                 , ...
                                        'level',    {levels}                   , ...
                                        'duration', {0}                       );
                end
                % load realignment
                R = load(file_niirea);
                % save regressors
                save(file_datreg,'reg','mod');
                save(file_datrea,'R');
            end
        end
        % update file_datregs
        file_datregs = dir([dir_datregs,'regressors_*_reg.mat']); file_datregs = strcat(dir_datregs,strvcat(file_datregs.name));
        file_datreas = dir([dir_datregs,'regressors_*_rea.mat']); file_datreas = strcat(dir_datregs,strvcat(file_datreas.name));
    end
    
    %% GLM FIRST LEVEL
    function glm_first_level()
        if ~do_frst; return; end
        if ~exist(dir_datglm1s,'dir'); mkdirp(dir_datglm1s); end
        
        jobs = {};
        j_run = 0;
        for i_sub = u_subject
            dir_niiepi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
            fprintf('GLM first level for: %s\n',dir_datglm1);
            if ~exist(dir_datglm1,'dir'); mkdirp(dir_datglm1); end
            job = struct();
            job.spm.stats.fmri_spec.dir = {dir_datglm1};
            job.spm.stats.fmri_spec.timing.units  = 'secs';
            job.spm.stats.fmri_spec.timing.RT      = pars_tr;
            job.spm.stats.fmri_spec.timing.fmri_t  = 16;
            job.spm.stats.fmri_spec.timing.fmri_t0 = 1;
            % session
            for i_run = u_run
                % index
                j_run = j_run + 1;
                % dirs & files
                dir_niirun = strcat(dir_niiepi3,strtrim(dir_niiruns(i_run,:)));
                dir_niiimg = strcat(dir_niirun,'images',filesep);
                file_niiimg = cellstr(spm_select('FPlist', dir_niiimg,['^',sprintf('sw%duimages',pars_voxs),'.*\.nii']));
                file_datreg = strtrim(file_datregs(j_run,:));
                file_datrea = strtrim(file_datreas(j_run,:));
                loadreg = load(file_datreg,'reg','mod');
                % truncate
                nb_ons = 0;
                for i_reg = 1:length(loadreg.reg)
                    if (nb_ons < max(loadreg.reg{i_reg}.onset)/pars_tr)
                        nb_ons = max(loadreg.reg{i_reg}.onset)/pars_tr;
                    end
                end
                for i_mod = 1:length(loadreg.mod)
                    if (nb_ons < max(loadreg.mod{i_mod}.onset)/pars_tr)
                        nb_ons = max(loadreg.mod{i_mod}.onset)/pars_tr;
                    end
                end
                nb_ons = ceil(nb_ons);
                nb_nii = size(file_niiimg,1);
                nb_min = min(nb_ons,nb_nii);
                % job
                job.spm.stats.fmri_spec.sess(i_run).scans = file_niiimg;
                job.spm.stats.fmri_spec.sess(i_run).hpf = 128;
                job.spm.stats.fmri_spec.sess(i_run).cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
                % regressors
                for i_reg = 1:length(loadreg.reg)
                    tmp_onsets = loadreg.reg{i_reg}.onset;
                    nb_rmons = sum(tmp_onsets/pars_tr > nb_min);
                    if nb_rmons; fprintf('    warning: (%02i,%02i,%02i) delete %02i reg onsets \n',i_sub,i_run,i_reg,nb_rmons); end
                    tmp_onsets(tmp_onsets/pars_tr > nb_min) = [];
                    cond = struct();
                    cond.name     = loadreg.reg{i_reg}.name;
                    cond.onset    = tmp_onsets;
                    cond.duration = loadreg.reg{i_reg}.duration;
                    cond.tmod     = 0;
                    cond.pmod     = struct('name', {}, 'param', {}, 'poly', {});
                    job.spm.stats.fmri_spec.sess(i_run).cond(end+1) = cond;
                end
                % modulators
                for i_mod1 = 1:length(loadreg.mod)
                    tmp_onsets = loadreg.mod{i_mod1}.onset;
                    nb_rmons = sum(tmp_onsets/pars_tr > nb_min);
                    if nb_rmons; fprintf('    warning: (%02i,%02i,%02i) delete %02i mod onsets \n',i_sub,i_run,i_mod,nb_rmons); end
                    tmp_onsets(tmp_onsets/pars_tr > nb_min) = [];
                    cond = struct();
                    cond.name     = loadreg.mod{i_mod1}.name;
                    cond.onset    = tmp_onsets;
                    cond.duration = loadreg.mod{i_mod1}.duration;
                    cond.tmod     = 0;
                    for i_mod2 = 1:length(loadreg.mod{i_mod1}.subname)
                        cond.pmod(i_mod2).name  = loadreg.mod{i_mod1}.subname{i_mod2};
                        cond.pmod(i_mod2).param = loadreg.mod{i_mod1}.level{i_mod2};
                        cond.pmod(i_mod2).poly = 1;
                    end
                    job.spm.stats.fmri_spec.sess(i_run).cond(end+1) = cond;
                end
                % realignment
                job.spm.stats.fmri_spec.sess(i_run).multi_reg = {file_datrea};
            end
            % others
            job.spm.stats.fmri_spec.fact = struct('name',{},'levels',{});
            job.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            job.spm.stats.fmri_spec.volt = 1;
            job.spm.stats.fmri_spec.global = 'None';
            job.spm.stats.fmri_spec.mask = {''};
            job.spm.stats.fmri_spec.cvi = 'AR(1)';
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
    %% GLM FIRST LEVEL: Estimate
    function glm_first_estimate()
        if ~do_frst; return; end
        jobs = {};
        for i_sub = u_subject
            dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
            fprintf('GLM first level estimate for: %s\n',dir_datglm1);
            job = struct();
            job.spm.stats.fmri_est.spmmat = {[dir_datglm1,'SPM.mat']};
            job.spm.stats.fmri_est.method.Classical = 1;
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
    %% GLM FIRST LEVEL: Contrasts
    function glm_first_contrasts()
        if ~do_frst; return; end
        jobs = {};
        for i_sub = u_subject
            fprintf('GLM first level contrasts for: subject %02i\n',i_sub);
            dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
            job = struct();
            job.spm.stats.con.spmmat = {[dir_datglm1,'SPM.mat']};
            for i_con = 1:length(u_contrast)
                job.spm.stats.con.consess{i_con}.tcon.name      = u_contrast{i_con}.name;
                job.spm.stats.con.consess{i_con}.tcon.convec    = u_contrast{i_con}.convec;
                job.spm.stats.con.consess{i_con}.tcon.sessrep   = 'replsc';
            end
            job.spm.stats.con.delete = 1;
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
    %% GLM SECOND LEVEL: Copy files
    function glm_second_copy()
        if ~do_scnd; return; end
        for i_sub = u_subject
            fprintf('GLM second level copy for: subject %02i\n',i_sub);
            for i_con = 1:length(u_contrast)
                dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
                dir_datglm2 = sprintf('%scon_%s/',dir_datglm2s,u_contrast{i_con}.name);
                if ~exist(dir_datglm2,'dir'); mkdirp(dir_datglm2); end
                copyfile(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.hdr',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.img',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.hdr' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.hdr' ,dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.img' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.img' ,dir_datglm2,i_sub,i_con));
            end
        end
    end
    
    %% GLM SECOND LEVEL
    function glm_second_level()
        if ~do_scnd; return; end
        jobs = {};
        for i_con = 1:length(u_contrast)
            fprintf('GLM second level for: contrast "%s"\n',u_contrast{i_con}.name);
            dir_datglm2 = sprintf('%scon_%s/',dir_datglm2s,u_contrast{i_con}.name);
            % design
            job = struct();
            job.spm.stats.factorial_design.dir                      = {dir_datglm2};
            job.spm.stats.factorial_design.des.t1.scans             = cellstr(spm_select('FPlist', dir_datglm2, '^spmT_.*\.img$'));
            job.spm.stats.factorial_design.cov                      = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
            job.spm.stats.factorial_design.masking.tm.tm_none       = 1;    % threshold masking
            job.spm.stats.factorial_design.masking.im               = 1;    % implicit mask
            job.spm.stats.factorial_design.masking.em               = {''}; % explicit mask
            job.spm.stats.factorial_design.globalc.g_omit           = 1;    % dont know what it is
            job.spm.stats.factorial_design.globalm.gmsca.gmsca_no   = 1;    % grand mean scaling
            job.spm.stats.factorial_design.globalm.glonorm          = 1;    % global normalization
            jobs{end+1} = job;
            % estimate
            job = struct();
            job.spm.stats.fmri_est.spmmat           = {[dir_datglm2,'SPM.mat']};
            job.spm.stats.fmri_est.method.Classical = 1;
            jobs{end+1} = job;
            % contrast
            job = struct();
            job.spm.stats.con.spmmat                    = {[dir_datglm2,'SPM.mat']};
            job.spm.stats.con.consess{1}.tcon.name      = u_contrast{i_con}.name;
            job.spm.stats.con.consess{1}.tcon.convec    = 1; % contrast vector, here just 1, (simple T)
            job.spm.stats.con.consess{1}.tcon.sessrep   = 'none';
            job.spm.stats.con.delete = 1;
            jobs{end+1} = job;
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

function y = bin2sign(x)
    l = logical(x);
    y = double(x);
    y( l) = +1;
    y(~l) = -1;
end

function reg_onset = get_regonset(timerun,u_reg)
    reg_onset = [];
    for i_reg = 1:length(u_reg)
        reg_onset = [reg_onset,timerun.(u_reg.value{i_reg})];
    end
    reg_onset = sort(reg_onset);
end

function mod_onset = get_modonset(timerun,u_mod)
    mod_onset = [];
    for i_mod1 = 1:length(u_mod.value)
        for i_mod2 = 1:length(u_mod.value{i_mod1}.value)
            mod_onset = [mod_onset,timerun.(u_mod.value{i_mod1}.value{i_mod2})];
        end
    end
    mod_onset = sort(mod_onset);
end
