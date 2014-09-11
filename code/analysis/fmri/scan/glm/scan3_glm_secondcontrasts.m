
function scan = scan3_glm_secondcontrasts(scan)
    %% SCAN3_GLM_SECONDCONTRASTS()
    % second level analysis of the GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW>
    
    %% SECOND CONTRASTS
    jobs = {};
    for i_con = 1:length(scan.glm.contrast)
        fprintf('glm second level for: contrast "%s"\n',scan.glm.contrast{i_con}.name);
        dir_datglm2 = sprintf('%scon_%s/',scan.dire.glm_secondlevel,scan.glm.contrast{i_con}.name);
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
        job.spm.stats.con.consess{1}.tcon.name      = scan.glm.contrast{i_con}.name;
        job.spm.stats.con.consess{1}.tcon.convec    = 1; % contrast vector, here just 1, (simple T)
        job.spm.stats.con.consess{1}.tcon.sessrep   = 'none';
        job.spm.stats.con.delete = 1;
        jobs{end+1} = job;
    end
    spm_jobman('run',jobs);
    
end