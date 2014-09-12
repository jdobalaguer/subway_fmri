
function scan3_mask()
    %% SCAN3_MASK()
    % create a mask using a general linear model (GLM).
    % this mask can be later applied to do multi-voxel pattern analysis (MVPA).
    % see also scan3_preprocess
    %          scan3_glm
    %          scan3_mvpa
    
    %% WARNINGS
    %#ok<*NUSED,*ALIGN>
    
    %% CLEAN
    clearvars -global;
    
    %% LOCAL PARAMETERS
    global name_glm name_mask name_image r_subject do_pooling;
    
    delete_all      = 1;
    name_glm        = 'hrf_T(X+S+XS)_C_F(G)';
    name_mask       = '';
    name_image      = 'smooth'; ... "image" "normalization" "smooth"
    r_subject       = [6,10];
    do_pooling      = 0;
    
    %% GLOBAL PARAMETERS
    global dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast;
    scan_parameters();
    
    %% FLAGS
    do_regressors = delete_all || ~exist(dire_glm_condition ,'file');
    do_regression = delete_all || ~exist(dire_glm_firstlevel,'file');
    do_contrasts  = delete_all || true;
    
    %% DELETE
    if do_regressors && exist(dire_glm_condition , 'dir'); rmdir(dire_glm_condition , 's'); end
    if do_regression && exist(dire_glm_firstlevel, 'dir'); rmdir(dire_glm_firstlevel, 's'); end
    if do_contrasts  && exist(dire_glm_secondlevel,'dir'); rmdir(dire_glm_secondlevel,'s'); end
    if do_contrasts  && exist(dire_glm_contrast,   'dir'); rmdir(dire_glm_contrast,   's'); end
    
    %% SPM
    if ~exist('spm.m','file'), spm8_add_paths(); end
    spm_jobman('initcfg');
    
    %% JOBS
    tic();
    if do_regressors,   scan3_glm_buildregressors();    end     % build regressors
    if do_regressors,   scan3_glm_checkregressors();    end     % check regressors
    if do_regressors,   scan3_glm_mergeregressors();    end     % merge regressors
                        scan3_glm_setcontrasts();               % set contrasts
    if do_regression,   scan3_glm_firstdesign();        end     % first  : design
    if do_regression,   scan3_glm_firstestimate();      end     % first  : estimate
    if do_contrasts,    scan3_glm_firstcontrasts();     end     % first  : contrast
    toc();

end
