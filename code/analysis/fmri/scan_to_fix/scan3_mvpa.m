
function scan3_mvpa()
    %% SCAN3_MVPA()
    % runs a multi-voxel pattern analysis (MVPA)
    % see also scan3_preprocess
    %          scan3_glm
    
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*NASGU>
    
    %% LOCAL PARAMETERS
    global name_glm name_mvpa name_mask name_image r_subject do_pooling;
    
    delete_all      = 1;
    
    name_glm        = 'MVPA_hrf_T(LLLL)';
    name_mvpa       = 'decode_sublines';
    name_mask       = ''; %'AA'; %'BA4_TS';
    name_image      = 'normalisation'; ... "image" "normalization" "smooth"
        
    r_subject       = 2:100; %[6,10];
    do_pooling      = 1;
    
    %% SET STRUCT
    scan_parameters();
    
    %% GLM REGRESSORS
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    
    scan.glm.regressor = struct(...
                            'subject', { data.expt_subject   , block.expt_subject       },  ...
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
    scan.mvpa.regressor = struct(...
                            'subject', { data.expt_subject   , block.expt_subject       },  ...
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
    
    %% FLAGS
    do_regressors = scan.glm.delete || ~exist(scan.dire.glm_condition ,'file');
    do_regression = scan.glm.delete || ~exist(scan.dire.glm_firstlevel,'file');
    do_contrasts  = scan.glm.delete || ~exist(scan.dire.glm_secondlevel,'file');
    do_multivoxel = scan.glm.delete || true;
    
    %% ASSERT
    assert(strcmp(scan.glm.function,'hrf'),'scan3_mvpa: error. MVPA only works with the canonical hrf function mode');
    
    %% DELETE
    if do_regressors && exist(scan.dire.glm_condition , 'dir'); rmdir(scan.dire.glm_condition , 's'); end
    if do_regression && exist(scan.dire.glm_firstlevel, 'dir'); rmdir(scan.dire.glm_firstlevel, 's'); end
    if do_multivoxel && exist(scan.dire.mvpa,           'dir'); rmdir(scan.dire.mvpa,           's'); end
    
    %% SPM & PRINCETON
    if ~exist('spm.m',      'file'), spm8_add_paths(); end
    if ~exist('init_subj.m','file'), mvpa_add_paths(); end
    spm_jobman('initcfg');
    
    %% JOBS
    tic();
    if do_regressors,   scan = scan3_glm_buildregressors(scan);    end     % REGRESSORS: build
    if do_regressors,   scan = scan3_glm_checkregressors(scan);    end     % REGRESSORS: check
    if do_regressors,   scan = scan3_glm_mergeregressors(scan);    end     % REGRESSORS: merge
                        scan = scan3_glm_setcontrasts(scan);               % REGRESSORS: set contrasts
                        
    if do_regression,   scan = scan3_glm_firstdesign(scan);        end     % GLM: design
    if do_regression,   scan = scan3_glm_firstestimate(scan);      end     % GLM: estimate
    
    if do_contrasts,    scan = scan3_glm_firstcontrasts(scan);     end     % CONTRASTS:  contrasts first level
    if length(u_subject)<2,          do_contrasts = false;         end
    if do_contrasts,    scan = scan3_glm_secondcopy(scan);         end     % CONTRASTS:  copy first level contrasts
    if do_contrasts,    scan = scan3_glm_secondcontrasts(scan);    end     % CONTRASTS:  contrasts second level
    if do_contrasts,    scan = scan3_glm_copycontrasts(scan);      end     % CONTRASTS:  copy second level contrasts
    
    if do_multivoxel,   scan = scan3_mvpa_initialize(scan);        end     % MVPA: initialize
    if do_multivoxel,   scan = scan3_mvpa_mask(scan);              end     % MVPA: mask
    if do_multivoxel,   scan = scan3_mvpa_image(scan);             end     % MVPA: image
    if do_multivoxel,   scan = scan3_mvpa_regressor(scan);         end     % MVPA: regressor
    if do_multivoxel,   scan = scan3_mvpa_run(scan);               end     % MVPA: run
    if do_multivoxel,   scan = scan3_mvpa_crossvalidation(scan);   end     % MVPA: cross-validation
    if do_multivoxel,   scan = scan3_mvpa_summarize(scan);         end     % MVPA: cross-validation
    toc();
end
