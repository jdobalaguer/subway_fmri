
function scan3_glm_secondcontrasts()
    %% SCAN3_GLM_SECONDCONTRASTS()
    % second level analysis of the GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED>
    

    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask glm_function glm_ordfir glm_lenfir glm_delay glm_marge;
    global n_subject u_subject;
    global u_contrast;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    %% SECOND CONTRASTS
    jobs = {};
    for i_con = 1:length(u_contrast)
        fprintf('glm second level for: contrast "%s"\n',u_contrast{i_con}.name);
        dir_datglm2 = sprintf('%scon_%s/',dire_glm_secondlevel,u_contrast{i_con}.name);
        % design
        job = struct();
        job.spm.stats.factorial_design.dir                      = {dir_datglm2};
        job.spm.stats.factorial_design.des.t1.scans             = cellstr(spm_select('FPlist', dir_datglm2, '^spmT_.*\.img$'));
        if isempty(job.spm.stats.factorial_design.des.t1.scans{1}),
            job.spm.stats.factorial_design.des.t1.scans             = cellstr(spm_select('FPlist', dir_datglm2, '^spmT_.*\.nii$'));
        end
        job.spm.stats.factorial_design.cov                      = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        job.spm.stats.factorial_design.masking.tm.tm_none       = 1;    % threshold masking
        job.spm.stats.factorial_design.masking.im               = 1;    % implicit mask
        job.spm.stats.factorial_design.masking.em               = {file_mask}; % explicit mask
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