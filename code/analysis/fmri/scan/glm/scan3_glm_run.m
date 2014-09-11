function scan3_glm_run(scan)
    %% SCAN3_GLM()
    % runs a General Linear Model (GLM)
    % see also scan3_preprocess
    %          scan3_mvpa

    %% WARNINGS
    %#ok<*NASGU>
    
    %% FUNCTION
    
    % set struct
    scan = scan_parameters(scan);
    
    % flags
    do_regressors = scan.glm.delete || ~exist(scan.dire.glm_condition ,'file');
    do_regression = scan.glm.delete || ~exist(scan.dire.glm_firstlevel,'file');
    do_contrasts  = scan.glm.delete || true;
    
    % delete
    if do_regressors && exist(scan.dire.glm_condition , 'dir'); rmdir(scan.dire.glm_condition , 's'); end
    if do_regression && exist(scan.dire.glm_firstlevel, 'dir'); rmdir(scan.dire.glm_firstlevel, 's'); end
    if do_contrasts  && exist(scan.dire.glm_secondlevel,'dir'); rmdir(scan.dire.glm_secondlevel,'s'); end
    if do_contrasts  && exist(scan.dire.glm_contrast,   'dir'); rmdir(scan.dire.glm_contrast,   's'); end
    
    % SPM
    if ~exist('spm.m','file'), spm8_add_paths(); end
    spm_jobman('initcfg');
    
    % copy configuration
    mkdirp(scan.dire.glm);
    save_scan();
    
    % jobs
    if do_regressors,   scan = scan3_glm_buildregressors(scan); save_scan(); end     % REGRESSORS: build
    if do_regressors,   scan = scan3_glm_checkregressors(scan); save_scan(); end     % REGRESSORS: check
    if do_regressors,   scan = scan3_glm_mergeregressors(scan); save_scan(); end     % REGRESSORS: merge
                        scan = scan3_glm_setcontrasts(scan);    save_scan();         % REGRESSORS: set contrasts
    if do_regression,   scan = scan3_glm_firstdesign(scan);     save_scan(); end     % GLM:        design
    if do_regression,   scan = scan3_glm_firstestimate(scan);   save_scan(); end     % GLM:        estimate
    if do_contrasts,    scan = scan3_glm_firstcontrasts(scan);  save_scan(); end     % CONTRASTS:  contrasts first level
    if length(scan.subject.u)<2,     do_contrasts = false;      save_scan(); end
    if do_contrasts,    scan = scan3_glm_secondcopy(scan);      save_scan(); end     % CONTRASTS:  copy first level contrasts
    if do_contrasts,    scan = scan3_glm_secondcontrasts(scan); save_scan(); end     % CONTRASTS:  contrasts second level
    if do_contrasts,    scan = scan3_glm_copycontrasts(scan);   save_scan(); end     % CONTRASTS:  copy second level contrasts

    %% AUXILIAR
    function save_scan(), save([scan.dire.glm,'scan.mat'],'scan'); end
end
