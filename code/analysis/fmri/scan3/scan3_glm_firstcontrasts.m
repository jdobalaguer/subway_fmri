
function scan3_glm_firstcontrasts()
    %% SCAN3_GLM_FIRSTCONTRASTS()
    % run the contrasts on the first level
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED>
    
    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask glm_function glm_ordfir glm_lenfir glm_delay glm_marge;
    global n_subject u_subject;
    global u_contrast
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    %% FIRST LEVEL: CONTRASTS
    jobs = {};
    for i_sub = u_subject
        fprintf('glm first level contrasts for: subject %02i\n',i_sub);
        dir_datglm1 = sprintf('%ssub_%02i/',dire_glm_firstlevel,i_sub);
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