
function scan3_glm()
    %% SCAN3_GLM()
    % runs a General Linear Model (GLM)
    % see also scan3_preprocess
    %          scan3_mvpa
    
    %% WARNINGS
    %#ok<*NUSED,*ALIGN>
    
    %% CLEAN
    clearvars -global;
    
    %% LOCAL PARAMETERS
    global name_glm name_image r_subject do_pooling;
    global u_subject;
    
    delete_all      = 1;
    name_glm        = 'GLMM_hrf_T(LLLL)';
    name_image      = 'smooth'; ... "image" "normalization" "smooth"
        
    r_subject       = 2:100; %[6,10];
    do_pooling      = 1;
    
    %% GLOBAL PARAMETERS
    global dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast;
    scan_parameters();
    
    %% GLM REGRESSORS
    global glm_regressors;
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    
    glm_regressors = struct('subject', { data.expt_subject   , block.expt_subject       },  ...
                            'session', { data.expt_session   , block.expt_session       },  ...
                            'onset',   { data.vbxi_onset     , block.vbxi_onset_reward  },  ...
                            'discard', { ~data.resp_bool | data.resp_direction_back ,       ... discard-1
                                         isnan(block.vbxi_onset_reward)                 },  ... discard-2
                            'name',    { 'T'                 , 'F'                      },  ...
                            'subname', { {'TL1','TL2','TL3'} , {'FG'}                   },  ...
                            'level',   {                                                    ... level---1
                                         { data.vbxi_subline_in == 1 ,     ...
                                           data.vbxi_subline_in == 2 ,     ...
                                           data.vbxi_subline_in == 3 } ,   ...
                                         { block.resp_goal           }                  }   ... level---2
                            );
    
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
    toc();

end
