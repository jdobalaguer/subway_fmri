
function scan3_mvpa()
    %% SCAN3_MVPA()
    % runs a multi-voxel pattern analysis (MVPA)
    % see also scan3_preprocess
    %          scan3_glm
    
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*NASGU>
    
    %% CLEAN
    clearvars -global;
    
    %% LOCAL PARAMETERS
    global name_glm name_mvpa name_mask name_image r_subject do_pooling;
    
    delete_all      = 1;
    
    name_glm        = 'MVPA_hrf_T(LLLL)';
    name_mvpa       = 'decode_sublines';
    name_mask       = ''; %'AA'; %'BA4_TS';
    name_image      = 'normalisation'; ... "image" "normalization" "smooth"
        
    r_subject       = 2:100; %[6,10];
    do_pooling      = 1;
    
    %% GLOBAL PARAMETERS
    global dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_mvpa;
    scan_parameters();
    
    %% GLM REGRESSORS
    global glm_regressors;
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    
    glm_regressors = struct('subject', { data.expt_subject   , block.expt_subject       },  ...
                            'session', { data.expt_session   , block.expt_session       },  ...
                            'onset',   { data.vbxi_onset     , block.vbxi_onset_reward  },  ...
                            'discard', { ~data.resp_bool | data.resp_direction_back ,       ...
                                         isnan(block.vbxi_onset_reward)                 },  ...
                            'name',    { 'T'                 , 'F'                      },  ...
                            'subname', { {'TL1','TL2','TL3'} , {'FG'}                   },  ...
                            'level',   { { data.vbxi_subline_in == 1 ,     ...
                                           data.vbxi_subline_in == 2 ,     ...
                                           data.vbxi_subline_in == 3 } ,   ...
                                        {  block.resp_goal           }                  }   ...
                            );
    
    %% MVPA REGRESSORS
    
    
    %% FLAGS
    do_regressors = delete_all || ~exist(dire_glm_condition ,'file');
    do_regression = delete_all || ~exist(dire_glm_firstlevel,'file');
    do_contrasts  = delete_all || ~exist(dire_glm_secondlevel,'file');
    do_multivoxel = delete_all || true;
    
    %% ASSERT
    global glm_function;
    assert(strcmp(glm_function,'hrf'),'scan3_mvpa: error. MVPA only works with the canonical hrf function mode');
    
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
                        scan3_glm_setcontrasts();               % REGRESSORS: set contrasts
                        
    if do_regression,   scan3_glm_firstdesign();        end     % GLM: design
    if do_regression,   scan3_glm_firstestimate();      end     % GLM: estimate
    
    if do_contrasts,    scan3_glm_firstcontrasts();     end     % CONTRASTS:  contrasts first level
    if length(u_subject)<2, do_contrasts = false;       end
    if do_contrasts,    scan3_glm_secondcopy();         end     % CONTRASTS:  copy first level contrasts
    if do_contrasts,    scan3_glm_secondcontrasts();    end     % CONTRASTS:  contrasts second level
    if do_contrasts,    scan3_glm_copycontrasts();      end     % CONTRASTS:  copy second level contrasts
    
    if do_multivoxel,   scan3_mvpa_initialize();        end     % MVPA: initialize
    if do_multivoxel,   scan3_mvpa_mask();              end     % MVPA: mask
    if do_multivoxel,   scan3_mvpa_image();             end     % MVPA: image
    if do_multivoxel,   scan3_mvpa_regressor();         end     % MVPA: regressor
    if do_multivoxel,   scan3_mvpa_run();               end     % MVPA: run
    if do_multivoxel,   scan3_mvpa_crossvalidation();   end     % MVPA: cross-validation
    if do_multivoxel,   scan3_mvpa_summarize();         end     % MVPA: cross-validation
    toc();
end
