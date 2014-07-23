function scan4_glm()
    
    %% WARNING
    fprintf('\nmake sure you have same participants in data and nii folders!\n\n')

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                        = [fileparts(which('spm.m')),filesep];
    % nii
    dir_niistudy                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_niisubs                    = dir([dir_niistudy,'sub_*']); dir_niisubs = strcat(dir_niistudy,strvcat(dir_niisubs.name),'/');
    dir_niiepis4                   = strcat(dir_niisubs,'epi4',filesep);
    dir_niiruns                    = dir([strtrim(dir_niiepis4(1,:)),'run*']); dir_niiruns = strcat(strvcat(dir_niiruns.name),'/');
    % data
    dir_datsubs                    = [pwd(),filesep,'data',filesep,'data',filesep,'scanner',filesep];
    dir_glm                        = [pwd(),filesep,'data',filesep,'glm4',filesep,'glm',filesep];
    dir_datcons                    = [dir_glm,'conditions',filesep];
    dir_datglm1s                   = [dir_glm,'firstlevel',filesep];
    dir_datglm2s                   = [dir_glm,'secondlevel',filesep];
    file_datsubs                   = dir([dir_datsubs,'data_*.mat']); file_datsubs = strcat(dir_datsubs,strvcat(file_datsubs.name));
    file_datcons                   = dir([dir_datcons,'condition_*.mat']); file_datcons = strcat(dir_datcons,strvcat(file_datcons.name));
    file_datreas                   = dir([dir_datcons,'realign_*.mat']); file_datreas = strcat(dir_datcons,strvcat(file_datreas.name));
    
    % VARIABLES
    nb_subjects = size(dir_niisubs, 1);
    nb_runs     = size(dir_niiruns, 1);
    n_subject   = [6,10];
    u_subject   = set_subjects();
    u_run       = 1:nb_runs;
    u_regressor = {};
    u_modulator = {};
    u_factor    = {};
    u_contrast  = {};
    eval(fileread([dir_glm,'glm.m']));
    
    % PARAMETERS
    pars_tr      = 2;
    pars_voxs    = 4;
    
    % FLAGS
    do_all  = false;
    do_regs = do_all || ~exist(dir_datcons ,'file');
    do_frst = do_all || ~exist(dir_datglm1s,'file');
    do_scnd = do_all || true;
    
    %% DELETE
    if do_regs && exist(dir_datcons ,'dir'); rmdir(dir_datcons ,'s'); end
    if do_frst && exist(dir_datglm1s,'dir'); rmdir(dir_datglm1s,'s'); end
    if do_scnd && exist(dir_datglm2s,'dir'); rmdir(dir_datglm2s,'s'); end
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    build_regressors();         % build regressors
    glm_first_level();          % first  : level
    glm_first_estimate();       % first  : estimate
    glm_second_contrasts();     % second : contrasts
    glm_second_copy();          % second : copy
    glm_second_level();         % second : level
    toc();
    
    %% SET PARTICIPANTS
    function u_subject = set_subjects()
        u_subject = 1:nb_subjects;
        u_subject(n_subject) = [];
    end
    
    %% BUILD REGRESSORS
    function build_regressors()
        if ~do_regs; return; end
        % make directory
        if ~exist(dir_datcons,'dir'); tools_mkdirp(dir_datcons); end
        % load regressors
        [timeregs,dataregs] = scan4_glm_loadregressors('scanner');
        [timefacs,datafacs] = scan4_glm_loadfactors('scanner');
        for i_sub = u_subject
            dir_niiepi4 = strtrim(dir_niiepis4(i_sub,:));
            fprintf('Building regressors for: %s\n',dir_niiepi4);
            for i_run = u_run
                file_datcon = sprintf('%scondition_sub_%02i_run_%02i.mat',dir_datcons,i_sub,i_run);
                file_datrea = sprintf('%srealign_sub_%02i_run_%02i.mat',  dir_datcons,i_sub,i_run);
                % index
                j_run = (i_sub-1)*nb_runs + i_run;
                assert(j_run<=length(timeregs),'scan4_glm: build_regressors: error 1.');
                % dirs & files
                dir_niiimg     = dir_niiepi4;
                file_niirea    = dir([dir_niiimg,sprintf('rp_image*RUN%d.txt',             i_run)]); file_niirea = strcat(dir_niiimg,strvcat(file_niirea.name));
                file_niiimg    = dir([dir_niiimg,sprintf('sw%duimages*RUN%d.nii',pars_voxs,i_run)]); file_niiimg = strcat(dir_niiimg,strvcat(file_niiimg.name));
                % create conditions
                % regressor
                cond = {};
                for i_reg = 1:length(u_regressor)
                    onset = get_regonset(timeregs{j_run},u_regressor{i_reg});
                    cond{end+1} = struct('name',     {u_regressor{i_reg}.name}, ...
                                         'onset',    {onset}                  , ...
                                         'subname',  {[]}                     , ...
                                         'level',    {[]}                     , ...
                                         'duration', {0}                      );
                end
                % modulator
                for i_mod1 = 1:length(u_modulator)
                    onset = get_modonset(timeregs{j_run},u_modulator{i_mod1});
                    subnames = {};
                    levels   = {};
                    for i_mod2 = 1:length(u_modulator{i_mod1}.value)
                        level = zeros(size(onset));
                        for i_mod3 = 1:length(u_modulator{i_mod1}.value{i_mod2}.value)
                            onset_level = timeregs{j_run}.(u_modulator{i_mod1}.value{i_mod2}.value{i_mod3});
                            ii_level    = ismember(onset,onset_level);
                            v_level     = u_modulator{i_mod1}.value{i_mod2}.level(i_mod3);
                            level(ii_level) = v_level;
                        end
                        subnames{i_mod2} = u_modulator{i_mod1}.value{i_mod2}.name;
                        levels{i_mod2}   = level;
                    end
                    cond{end+1} = struct('name' ,    {u_modulator{i_mod1}.name}, ...
                                         'onset',    {onset}                   , ...
                                         'subname',  {subnames}                , ...
                                         'level',    {levels}                  , ...
                                         'duration', {0}                       );
                end
                % factor
                for i_fac1 = 1:length(u_factor)
                    onset = timefacs{j_run};
                    subnames = {};
                    levels   = {};
                    for i_fac2 = 1:length(u_factor{i_fac1}.value)
                        subnames{i_fac2} = u_factor{i_fac1}.value{i_fac2}.name;
                        levels{i_fac2}   = datafacs{j_run}.(u_factor{i_fac1}.value{i_fac2}.value);
                    end
                    cond{end+1} = struct('name' ,    {u_factor{i_fac1}.name}, ...
                                         'onset',    {onset}                , ...
                                         'subname',  {subnames}             , ...
                                         'level',    {levels}               , ...
                                         'duration', {0}                    );
                end
                % merge conditions
                cond = merge_cond(cond);
                % load realignment
                R = load(file_niirea);
                % save regressors
                save(file_datcon,'cond');
                save(file_datrea,'R');
            end
        end
        % update file_datregs
        file_datcons = dir([dir_datcons,'condition_*.mat']); file_datcons = strcat(dir_datcons,strvcat(file_datcons.name));
        file_datreas = dir([dir_datcons,'realign_*.mat']);   file_datreas = strcat(dir_datcons,strvcat(file_datreas.name));
    end
    
    %% FIRST LEVEL
    function glm_first_level()
        if ~do_frst; return; end
        if ~exist(dir_datglm1s,'dir'); tools_mkdirp(dir_datglm1s); end
        
        jobs = {};
        j_run = 0;
        for i_sub = u_subject
            dir_niiepi4 = strtrim(dir_niiepis4(i_sub,:));
            dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
            fprintf('GLM first level for: %s\n',dir_datglm1);
            if ~exist(dir_datglm1,'dir'); tools_mkdirp(dir_datglm1); end
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
                dir_niiimg = strcat(dir_niiepi4);
                file_niiimg = spm_select('FPlist', dir_niiimg,sprintf('sw%drimage.*RUN%d.nii',pars_voxs,i_run));
                file_datcon = strtrim(file_datcons(j_run,:));
                file_datrea = strtrim(file_datreas(j_run,:));
                loadcond = load(file_datcon,'cond');
                % truncate
                nb_ons = 0;
                for i_cond = 1:length(loadcond.cond)
                    if (nb_ons < max(loadcond.cond{i_cond}.onset)/pars_tr)
                        nb_ons = max(loadcond.cond{i_cond}.onset)/pars_tr;
                    end
                end
                nb_ons = ceil(nb_ons);
                nb_nii = spm_vol_nifti(file_niiimg); nb_nii = size(nb_nii.private.dat,4);
                nb_min = min(nb_ons,nb_nii);
                % job
                job.spm.stats.fmri_spec.sess(i_run).scans = cellstr(strcat(repmat([file_niiimg,','],nb_nii,1), char(num2leg(1:nb_nii))));
                job.spm.stats.fmri_spec.sess(i_run).hpf = 128;
                job.spm.stats.fmri_spec.sess(i_run).cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
                % conditions (regressors, modulators & factors)
                for i_cond1 = 1:length(loadcond.cond)
                    % remove onsets out of boundary
                    nb_rmons = sum(loadcond.cond{i_cond1}.onset/pars_tr > nb_min);
                    if nb_rmons; fprintf('    warning: (%02i,%02i,%02i) delete %02i onsets %s \n',i_sub,i_run,i_cond1,nb_rmons,loadcond.cond{i_cond1}.name); end
                    loadcond.cond{i_cond1}.onset(loadcond.cond{i_cond1}.onset/pars_tr > nb_min) = [];
                    % save condition
                    cond = struct();
                    cond.name     = loadcond.cond{i_cond1}.name;
                    cond.onset    = loadcond.cond{i_cond1}.onset;
                    cond.duration = loadcond.cond{i_cond1}.duration;
                    cond.tmod     = 0;
                    cond.pmod     = struct('name', {}, 'param', {}, 'poly', {});
                    for i_cond2 = 1:length(loadcond.cond{i_cond1}.subname)
                        cond.pmod(i_cond2).name  = loadcond.cond{i_cond1}.subname{i_cond2};
                        cond.pmod(i_cond2).param = loadcond.cond{i_cond1}.level{i_cond2};
                        cond.pmod(i_cond2).poly = 1;
                    end
                    job.spm.stats.fmri_spec.sess(i_run).cond(end+1) = cond;
                end
                % realignment
                job.spm.stats.fmri_spec.sess(i_run).multi_reg = {file_datrea};
                % print
                fprintf('%d %.1f \n', nb_nii, max(job.spm.stats.fmri_spec.sess(1).cond(4).onset)./2);
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
    
    %% FIRST LEVEL: Estimate
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
    
    %% SECOND LEVEL: Contrasts
    function glm_second_contrasts()
        if ~do_scnd; return; end
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
    
    %% SECOND LEVEL: Copy files
    function glm_second_copy()
        if ~do_scnd; return; end
        for i_sub = u_subject
            fprintf('GLM second level copy for: subject %02i\n',i_sub);
            for i_con = 1:length(u_contrast)
                dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
                dir_datglm2 = sprintf('%scon_%s/',dir_datglm2s,u_contrast{i_con}.name);
                if ~exist(dir_datglm2,'dir'); tools_mkdirp(dir_datglm2); end
                copyfile(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.hdr',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.img',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.hdr' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.hdr' ,dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.img' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.img' ,dir_datglm2,i_sub,i_con));
            end
        end
    end
    
    %% SECOND LEVEL
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

% numbers to legend (cell of string)
function leg = num2leg(num)
    assert(isvector(num),'num2leg: error. not a vector');
    leg = cell(1,length(num));
    for i = 1:length(num)
        leg{i} = num2str(num(i));
    end
    
end

% convert binary to signed
function y = bin2sign(x)
    l = logical(x);
    y = double(x);
    y( l) = +1;
    y(~l) = -1;
end

% get onset of regressors
function reg_onset = get_regonset(timerun,u_reg)
    reg_onset = [];
    for i_reg = 1:length(u_reg)
        reg_onset = [reg_onset,timerun.(u_reg.value{i_reg})];
    end
    reg_onset = sort(reg_onset);
end

% get onset of modulators
function mod_onset = get_modonset(timerun,u_mod)
    mod_onsets = {};
    for i_mod1 = 1:length(u_mod.value)
        mod_onset = [];
        for i_mod2 = 1:length(u_mod.value{i_mod1}.value)
            mod_onset = [mod_onset,timerun.(u_mod.value{i_mod1}.value{i_mod2})];
        end
        mod_onsets{i_mod1} = sort(mod_onset);
    end
    for i_mod = 2:length(mod_onsets)
        assert(length(mod_onsets{i_mod-1})==length(mod_onsets{i_mod}) ,'scan4_glm: get_modonset: error. different onsets');
        assert(all(  (mod_onsets{i_mod-1})==      (mod_onsets{i_mod})),'scan4_glm: get_modonset: error. different onsets');
    end
end

% merge conditions
function cond = merge_cond(cond)
    l_cond = length(cond);
    i_cond1 = 0;
    i_cond2 = 0;
    while i_cond1 < l_cond
        i_cond1 = i_cond1 + 1;
        i_cond2 = i_cond1;
        while i_cond2 < l_cond
            i_cond2 = i_cond2 + 1;
            if strcmp(cond{i_cond1}.name,cond{i_cond2}.name)
                assert(length(cond{i_cond1}.onset)==length(cond{i_cond1}.onset) ,'scan4_glm: merge_cond: error. different onsets');
                assert(all(  (cond{i_cond1}.onset)==      (cond{i_cond1}.onset)),'scan4_glm: merge_cond: error. different onsets');
                cond{i_cond1}.subname = {cond{i_cond1}.subname{:} cond{i_cond2}.subname{:}};
                cond{i_cond1}.level   = {cond{i_cond1}.level{:}   cond{i_cond2}.level{:}  };
                cond(i_cond2) = [];
            end
        end
    end
end
