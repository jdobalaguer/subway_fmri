
function scan = scan3_glm_firstcontrasts(scan)
    %% SCAN3_GLM_FIRSTCONTRASTS()
    % run the contrasts on the first level
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED>
    
    %% FIRST LEVEL: CONTRASTS
    jobs = {};
    for i_sub = scan.subject.u
        fprintf('glm first level contrasts for: subject %02i\n',i_sub);
        dir_datglm1 = sprintf('%ssub_%02i/',scan.dire.glm_firstlevel,i_sub);
        job = struct();
        job.spm.stats.con.spmmat = {[dir_datglm1,'SPM.mat']};
        for i_con = 1:length(scan.glm.contrast)
            job.spm.stats.con.consess{i_con}.tcon.name      = scan.glm.contrast{i_con}.name;
            job.spm.stats.con.consess{i_con}.tcon.convec    = scan.glm.contrast{i_con}.convec;
            job.spm.stats.con.consess{i_con}.tcon.sessrep   = 'replsc';
        end
        job.spm.stats.con.delete = 1;
        jobs{end+1} = job;
    end
    spm_jobman('run',jobs);


end