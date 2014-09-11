
function scan = scan3_glm_firstestimate(scan)
    %% SCAN3_GLM_FIRSTESTIMATE()
    % run an estimate on the first level
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW>
    
    %% FIRST LEVEL: ESTIMATE
    jobs = {};
    for i_sub = scan.subject.u
        dire_datglm1 = sprintf('%ssub_%02i/',scan.dire.glm_firstlevel,i_sub);
        fprintf('GLM betas estimate for:  %s\n',dire_datglm1);
        job = struct();
        job.spm.stats.fmri_est.spmmat = {[dire_datglm1,'SPM.mat']};
        job.spm.stats.fmri_est.method.Classical = 1;
        jobs{end+1} = job;
    end
    spm_jobman('run',jobs);

end