
function scan = scan3_glm_firstdesign(scan)
    %% SCAN3_GLM_FIRSTLEVEL()
    % run a GLM on the first level
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW,*FPARK>
    
    %% FIRST LEVEL
    if ~exist(scan.dire.glm_firstlevel,'dir'); mkdirp(scan.dire.glm_firstlevel); end

    jobs = {};
    for i_subject = 1:scan.subject.n
        subject = scan.subject.u(i_subject);
        dire_nii_epi3 = strtrim(scan.dire.nii_epi3(subject,:));
        dire_dat_glm1 = sprintf('%ssub_%02i/',scan.dire.glm_firstlevel,subject);
        fprintf('GLM design for:          %s\n',dire_dat_glm1);
        dire_nii_runs = dir([dire_nii_epi3,'run*']);
        dire_nii_runs = strcat(strvcat(dire_nii_runs.name),'/');
        nb_runs     = size(dire_nii_runs, 1);
        u_run       = 1:nb_runs;
        if ~exist(dire_dat_glm1,'dir'); mkdirp(dire_dat_glm1); end
        
        %% JOB
        job = struct();
        job.spm.stats.fmri_spec.dir = {dire_dat_glm1};
        job.spm.stats.fmri_spec.timing.units  = 'secs';
        job.spm.stats.fmri_spec.timing.RT      = scan.pars.tr;
        job.spm.stats.fmri_spec.timing.fmri_t  = 16;
        job.spm.stats.fmri_spec.timing.fmri_t0 = 1;
        
        %% SESSIONS (NOT MERGED)
        if ~scan.glm.pooling
            % get files
            for i_run = u_run
                
                % dirs & files
                dire_niirun = strcat(dire_nii_epi3,strtrim(dire_nii_runs(i_run,:)));
                dire_niiimg = strcat(dire_niirun,name_image,filesep);
                assert(logical(exist(dire_niiimg,'dir')),'scan3_glm_firstlevel: error. dire_niiimg doesnt exist');
                file_niiimg = cellstr(spm_select('FPlist', dire_niiimg,'^.*images.*\.nii'));
                
                % session
                job.spm.stats.fmri_spec.sess(i_run).scans = file_niiimg;
                job.spm.stats.fmri_spec.sess(i_run).hpf = 128;
                job.spm.stats.fmri_spec.sess(i_run).cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
                
                % conditions (regressors, modulators & factors)
                file_datcon = sprintf('%scondition_sub_%02i_run_%02i.mat',scan.dire.glm_condition,subject,i_run);
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
                file_datrea = sprintf('%srealign_sub_%02i_run_%02i.mat',scan.dire.glm_condition,subject,i_run);
                job.spm.stats.fmri_spec.sess(i_run).multi_reg = {file_datrea};
            end
            
        else
        %% SESSIONS (MERGED)
            % get files
            file_allimg = [];
            for i_run = u_run
                % dirs & files
                dire_niirun = strcat(dire_nii_epi3,strtrim(dire_nii_runs(i_run,:)));
                dire_niiimg = strcat(dire_niirun,scan.glm.image,filesep);
                assert(logical(exist(dire_niiimg,'dir')),'scan3_glm_firstlevel: error. dire_niiimg doesnt exist');
                file_niiimg = cellstr(spm_select('FPlist', dire_niiimg,'^.*images.*\.nii'));
                file_allimg = [file_allimg ; file_niiimg];
            end
            % job
            job.spm.stats.fmri_spec.sess.scans = file_allimg;
            job.spm.stats.fmri_spec.sess.hpf = 128;
            job.spm.stats.fmri_spec.sess.cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
            % conditions (regressors, modulators & factors)
            file_datcon = sprintf('%smerged_condition_sub_%02i.mat',scan.dire.glm_condition,subject);
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
            file_datrea = sprintf('%smerged_realign_sub_%02i.mat',scan.dire.glm_condition,subject);
            job.spm.stats.fmri_spec.sess.multi_reg = {file_datrea};            
        end
        
        %% OTHERS
        job.spm.stats.fmri_spec.fact = struct('name',{},'levels',{});
        switch(scan.glm.function)
            case 'hrf'
                job.spm.stats.fmri_spec.bases.hrf.derivs = scan.glm.hrf.ord;
            case 'fir'
                job.spm.stats.fmri_spec.bases.fir.length = scan.glm.fir.len;
                job.spm.stats.fmri_spec.bases.fir.order  = scan.glm.fir.ord;
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