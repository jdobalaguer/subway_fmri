
function scan3_mvpa()
    %% SCAN3_MVPA()
    % runs a multi-voxel pattern analysis (MVPA)
    % see also scan3_preprocess
    %          scan3_glm
    
    %% WARNINGS
    %#ok<*NUSED,*ALIGN>
    
    %% CLEAN
    clearvars -global;
    
    %% LOCAL PARAMETERS
    global name_glm name_mvpa name_mask name_image r_subject do_pooling;
    
    delete_all      = 0;
    
    name_glm        = 'MVPA_hrf_T(AA)';
    name_mvpa       = 'decode_actions';
    name_mask       = 'BA4_TS';
    name_image      = 'smooth'; ... "image" "normalization" "smooth"
        
    r_subject       = 2:100; %[6,10];
    do_pooling      = 1;
    
    %% GLOBAL PARAMETERS
    global dire_glm_condition dire_glm_firstlevel dire_mvpa;
    scan_parameters();
    
    %% FLAGS
    do_regressors = delete_all || ~exist(dire_glm_condition ,'file');
    do_regression = delete_all || ~exist(dire_glm_firstlevel,'file');
    do_multivoxel = delete_all || true;
    
    %% DELETE
    if do_regressors && exist(dire_glm_condition , 'dir'); rmdir(dire_glm_condition , 's'); end
    if do_regression && exist(dire_glm_firstlevel, 'dir'); rmdir(dire_glm_firstlevel, 's'); end
    if do_multivoxel && exist(dire_mvpa,           'dir'); rmdir(dire_mvpa,           's'); end
    
    %% SPM & PRINCETON
    if ~exist('spm.m',      'file'), spm8_add_paths(); end
    if ~exist('init_subj.m','file'), mvpa_add_paths(); end
    spm_jobman('initcfg');
    
    %% JOBS
    tic();
    if do_regressors,   scan3_glm_buildregressors();    end     % REGRESSORS: build
    if do_regressors,   scan3_glm_checkregressors();    end     % REGRESSORS: check
    if do_regressors,   scan3_glm_mergeregressors();    end     % REGRESSORS: merge
    if do_regression,   scan3_glm_firstdesign();        end     % GLM: design
    if do_regression,   scan3_glm_firstestimate();      end     % GLM: estimate
    
    if do_multivoxel,   scan3_mvpa_initialize();        end     % MVPA: initialize
    if do_multivoxel,   scan3_mvpa_mask();              end     % MVPA: mask
    if do_multivoxel,   scan3_mvpa_image();             end     % MVPA: image
    if do_multivoxel,   scan3_mvpa_regressor();         end     % MVPA: regressor
    if do_multivoxel,   scan3_mvpa_run();               end     % MVPA: run
    if do_multivoxel,   scan3_mvpa_crossvalidation();   end     % MVPA: cross-validation
    if do_multivoxel,   scan3_mvpa_summarize();   end     % MVPA: cross-validation
    toc();
end
