
function scan = mvpa_glmdx()
    %% WARNINGS
    %#ok<*NBRAK,*UNRCH,*NASGU>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% INDEX
    ii_back  = logical(data.resp_direction_back_any);
    ii_null  = (~data.resp_bool);
    ii_bool  = ( data.resp_bool);
    ii_away  = (~data.resp_away_any);
    ii_corr  = ( data.resp_correct_all);
    ii_first = ( data.expt_first );
    ii_easy  = ( data.vbxi_subline_start == data.vbxi_subline_goal);
    ii_hard  = ( data.vbxi_subline_start ~= data.vbxi_subline_goal);
    ii_first = ( data.expt_first );
    ii_far   = ( data.optm_dist_subline_goal>1);
    
    ii_regular   = (data.vbxi_regular_in);
    ii_elbow     = (data.vbxi_elbow_in);
    ii_exchange  = (data.vbxi_exchange_in);
    ii_switch    = (data.resp_direction_switch);
    
    ii_tweak = (ii_bool & ~ii_first); % only using bool would give an error of empty onsets..

    %% SCANNER
    scan = parameters();
    
    %% SUBJECT
    scan.subject.r = [6,10];
    
    %% GLM
    scan.glm.contrasts.generic = false;
    scan.glm.contrasts.extra   = struct('name',{                ...
                                        },'regressor',{         ...
                                        },'weight',{            ...
                                        });
    scan.glm.image     = 'normalisation4';
    scan.glm.regressor = struct(                                ...
          'subject', { block.expt_subject                       ... subject
                       data.expt_subject(ii_tweak & ii_switch)   ...
                       data.expt_subject(ii_tweak & ~ii_switch)  ...
                       data.expt_subject(~ii_tweak)  ...
                       block.expt_subject                       ...
        },'session', { block.expt_session                       ... sesion
                       data.expt_session(ii_tweak & ii_switch)   ... 
                       data.expt_session(ii_tweak & ~ii_switch)  ... 
                       data.expt_session(~ii_tweak)              ... 
                       block.expt_session                       ... 
        },'onset',   { block.vbxi_onset_cue                     ... onset
                       data.vbxi_onset(ii_tweak & ii_switch)     ... 
                       data.vbxi_onset(ii_tweak & ~ii_switch)    ... 
                       data.vbxi_onset(~ii_tweak)                ... 
                       block.vbxi_onset_reward                  ... 
        },'discard', { false(size(block.vbxi_onset_cue))        ... discard
                       false(1,sum(ii_tweak & ii_switch))        ...
                       false(1,sum(ii_tweak & ~ii_switch))       ...
                       false(1,sum(~ii_tweak))                   ...
                       isnan(block.vbxi_onset_reward)           ...
        },'name',    { 'Cue','Switch','Stay','Null','Feedback'  ... name
        },'subname', { {},{},{},{},{}                           ... subname
        },'level',   { {},{},{},{},{}                           ... level
        },'duration',{ 0, 0, 0, 0, 0                            ... duration
        });
    scan.glm.redo       = 4;

    % things you shouldnt change
    scan.glm.delay      = 0;
    scan.glm.function   = 'hrf';
    scan.glm.hrf.ord    = [0,0];
    scan.glm.marge      = 0;
    scan.glm.pooling    = false;
    
    %% MVPA
    scan.mvpa.extension  = 'img';                           % extension of GLM files
    scan.mvpa.image      = {'Switch','Stay'};               % subdirectory of GLM files
    scan.mvpa.mask       = 'voxs4/S_003_parietal.img';      % mask to apply
    
    scan.mvpa.mni        = false;                           % revert normalisation from MNI to subject space
    scan.mvpa.name       = 'glmdx';
    scan.mvpa.pooling    = false;                           % merge all session
    scan.mvpa.redo       = 1;
    scan.mvpa.regressor.name = {{'Switch','Stay'}};
    scan.mvpa.verbose    = false;                           % verbose
    
    % specific to DX
    scan.mvpa.summarize = true;                             % print summary
    scan.mvpa.decoder.training.function     = @scan_mvpa_dx_class_sdt_training;
    scan.mvpa.decoder.training.parameters   = {'sdt'};
    scan.mvpa.decoder.evaluate.function     = @scan_mvpa_dx_class_sdt_evaluate;
    scan.mvpa.decoder.evaluate.parameters   = {};
    
    % things you shouldnt change
    scan.mvpa.glm               = '';
    scan.mvpa.regressor.subject = [];
    scan.mvpa.regressor.session = [];
    scan.mvpa.regressor.discard = [];
    scan.mvpa.regressor.level   = [];
    scan.mvpa.runmean           = false;
    
    %% SANITY CHECK
    scan = scan_initialize(scan);
    
    %% COPY SCRIPT
    file_script = mfilename('fullpath');
    if ~isempty(file_script)
        mkdirp(scan.dire.glm.root);
        copyfile(sprintf('%s.m',file_script),sprintf('%smvpa_glmdx.m',scan.dire.mvpa.root));
    end
    
    %% RUN
    scan = scan_mvpa_glmdx(scan);
    
end
