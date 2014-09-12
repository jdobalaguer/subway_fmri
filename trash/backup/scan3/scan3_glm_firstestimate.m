
function scan3_glm_firstestimate()
    %% SCAN3_GLM_FIRSTESTIMATE()
    % run an estimate on the first level
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW>
    
    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask glm_function glm_ordfir glm_lenfir glm_delay glm_marge;
    global n_subject u_subject;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    %% FIRST LEVEL: ESTIMATE
    jobs = {};
    for i_sub = u_subject
        dire_datglm1 = sprintf('%ssub_%02i/',dire_glm_firstlevel,i_sub);
        fprintf('GLM betas estimate for:  %s\n',dire_datglm1);
        job = struct();
        job.spm.stats.fmri_est.spmmat = {[dire_datglm1,'SPM.mat']};
        job.spm.stats.fmri_est.method.Classical = 1;
        jobs{end+1} = job;
    end
    spm_jobman('run',jobs);

end