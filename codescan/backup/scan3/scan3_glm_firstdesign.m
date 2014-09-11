
function scan3_glm_firstdesign()
    %% SCAN3_GLM_FIRSTLEVEL()
    % run a GLM on the first level
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW,*FPARK>
    
    %% GLOBAL PARAMETERS
    global name_glm name_mask name_image r_subject do_pooling;
    global n_subject u_subject;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    global glm_function glm_ordfir glm_lenfir glm_ordhrf glm_delay glm_marge;
    
    %% FIRST LEVEL
    if ~exist(dire_glm_firstlevel,'dir'); mkdirp(dire_glm_firstlevel); end

    jobs = {};
    for i_subject = 1:n_subject
        subject = u_subject(i_subject);
        dire_niiepi3 = strtrim(dire_nii_epi3(subject,:));
        dire_datglm1 = sprintf('%ssub_%02i/',dire_glm_firstlevel,subject);
        fprintf('GLM design for:          %s\n',dire_datglm1);
        dire_niiruns = dir([dire_niiepi3,'run*']); dire_niiruns = strcat(strvcat(dire_niiruns.name),'/');
        nb_runs     = size(dire_niiruns, 1);
        u_run       = 1:nb_runs;
        if ~exist(dire_datglm1,'dir'); mkdirp(dire_datglm1); end
        
        %% JOB
        job = struct();
        job.spm.stats.fmri_spec.dir = {dire_datglm1};
        job.spm.stats.fmri_spec.timing.units  = 'secs';
        job.spm.stats.fmri_spec.timing.RT      = pars_tr;
        job.spm.stats.fmri_spec.timing.fmri_t  = 16;
        job.spm.stats.fmri_spec.timing.fmri_t0 = 1;
        
        %% SESSIONS (NOT MERGED)
        if ~do_pooling
            % get files
            for i_run = u_run
                
                % dirs & files
                dire_niirun = strcat(dire_niiepi3,strtrim(dire_niiruns(i_run,:)));
                dire_niiimg = strcat(dire_niirun,name_image,filesep);
                assert(logical(exist(dire_niiimg,'dir')),'scan3_glm_firstlevel: error. dire_niiimg doesnt exist');
                file_niiimg = cellstr(spm_select('FPlist', dire_niiimg,'^.*images.*\.nii'));
                
                % session
                job.spm.stats.fmri_spec.sess(i_run).scans = file_niiimg;
                job.spm.stats.fmri_spec.sess(i_run).hpf = 128;
                job.spm.stats.fmri_spec.sess(i_run).cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
                
                % conditions (regressors, modulators & factors)
                file_datcon = sprintf('%scondition_sub_%02i_run_%02i.mat',dire_glm_condition,subject,i_run);
                loadcond = load(file_datcon,'cond');
                for i_cond1 = 1:length(loadcond.cond)
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
                file_datrea = sprintf('%srealign_sub_%02i_run_%02i.mat',dire_glm_condition,subject,i_run);
                job.spm.stats.fmri_spec.sess(i_run).multi_reg = {file_datrea};
            end
            
        else
        %% SESSIONS (MERGED)
            % get files
            file_allimg = [];
            for i_run = u_run
                % dirs & files
                dire_niirun = strcat(dire_niiepi3,strtrim(dire_niiruns(i_run,:)));
                dire_niiimg = strcat(dire_niirun,name_image,filesep);
                assert(logical(exist(dire_niiimg,'dir')),'scan3_glm_firstlevel: error. dire_niiimg doesnt exist');
                file_niiimg = cellstr(spm_select('FPlist', dire_niiimg,'^.*images.*\.nii'));
                file_allimg = [file_allimg ; file_niiimg];
            end
            % job
            job.spm.stats.fmri_spec.sess.scans = file_allimg;
            job.spm.stats.fmri_spec.sess.hpf = 128;
            job.spm.stats.fmri_spec.sess.cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
            % conditions (regressors, modulators & factors)
            file_datcon = sprintf('%smerged_condition_sub_%02i.mat',dire_glm_condition,subject);
            loadcond = load(file_datcon,'cond');
            for i_cond1 = 1:length(loadcond.cond)
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
                job.spm.stats.fmri_spec.sess.cond(end+1) = cond;
            end
            % realignment
            file_datrea = sprintf('%smerged_realign_sub_%02i.mat',dire_glm_condition,subject);
            job.spm.stats.fmri_spec.sess.multi_reg = {file_datrea};            
        end
        
        %% OTHERS
        job.spm.stats.fmri_spec.fact = struct('name',{},'levels',{});
        switch(glm_function)
            case 'hrf'
                job.spm.stats.fmri_spec.bases.hrf.derivs = glm_ordhrf;
            case 'fir'
                job.spm.stats.fmri_spec.bases.fir.length = glm_lenfir;
                job.spm.stats.fmri_spec.bases.fir.order  = glm_ordfir;
        end
        job.spm.stats.fmri_spec.volt = 1;
        job.spm.stats.fmri_spec.global = 'None';
        job.spm.stats.fmri_spec.mask = {''};
        job.spm.stats.fmri_spec.cvi = 'AR(1)';
        
        %% ADD JOB
        jobs{end+1} = job;
    end
    spm_jobman('run',jobs);
    
end