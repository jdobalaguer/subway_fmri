
function scan = mvpa_uni_feed(scan)
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU>
    
    %% SCANNER
    if ~exist('scan','var'), scan = parameters(); end
    
    %% SET SUBJECTS
    if ~isfield(scan,'subject'), scan.subject = struct(); end
    if isfield(scan.subject,'u'), scan.subject = rmfield(scan.subject,'u'); end
    if isfield(scan.subject,'r'), scan.subject = rmfield(scan.subject,'r'); end
    scan.subject.r = [6,10];
    
    %% LOAD
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    maps = load_maps(      'scanner');
    
    %% BLOCK EXTEND
    block.expt_trial_max       = jb_applyvector(@(subject,session,block) max(data.expt_trial(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),block.expt_subject,block.expt_session,block.expt_block);
    block.resp_exchange_in_sum = jb_applyvector(@(subject,session,block) sum(data.vbxi_exchange_in(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.resp_bool)),block.expt_subject,block.expt_session,block.expt_block);
    block.resp_away_any        = jb_applyvector(@(subject,session,block) any(data.resp_away(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.resp_bool)),block.expt_subject,block.expt_session,block.expt_block);
    
    %% INDEX
    ii_ball  = logical( block.resp_bool_all);
    ii_away  = logical( block.resp_away_any);
    ii_forw  = logical(~block.resp_away_any);
    ii_corr  = logical( block.resp_correct_all);
    ii_bail  = logical(~block.resp_goal);
    ii_goal  = logical( block.resp_goal);
    ii_easy  = logical( block.vbxi_easy);
    ii_hard  = logical(~block.vbxi_easy);
    ii_rewa  = logical( block.vbxi_reward > 1);
    
    ii = ii_ball;
    ii = ii_corr;
    
    %% REGRESSORS
    
    % GLM regressors
    r_data_Tgoal    = (data.expt_trial);
    r_data_Dgoal    = (data.optm_dist_station_goal);

    
    %% MVPA SETTINGS
    scan.mvpa.extension  = 'img';            % GLM files
    scan.mvpa.glm        = 'smooth4';
    scan.mvpa.image      = 'Trial';
    
    % DISTANCE TO GOAL
%     scan.mvpa.mask       = 'voxs4_old/Z_mpfc.img';
%     scan.mvpa.mask       = 'voxs4/R(Z)_003_temporal_pole_left.img';
%     scan.mvpa.mask       = 'voxs4/R(Z)_004_acc_right.img';
%     scan.mvpa.mask       = 'voxs4_old/CZ_ifg.img';
%     scan.mvpa.mask       = 'xjview4/hippocampus_left.img';
%     scan.mvpa.mask       = 'voxs4/TDgoal_vmpfc.img';
%     scan.mvpa.mask       = 'voxs4/Dgoal_mspfc.img';
%     scan.mvpa.mask       = 'voxs4/TDgoal_precuneus.img';
    
    % CRAZY
%     scan.mvpa.mask       = 'crazy/mask_parietal.img';
%     scan.mvpa.mask       = 'crazy/mask_frontopolar.img';
%     scan.mvpa.mask       = 'crazy/mask_sma.img';
%     scan.mvpa.mask       = 'crazy/mask_sma_ex.img';

    % CONTROLLED
%     scan.mvpa.mask       = 'controlled/Dchange(mcc).img';
%     scan.mvpa.mask       = 'controlled/Dchange(sma).img';
    scan.mvpa.mask       = 'controlled/TDgoal(vmpfc).img';
    

    
    scan.mvpa.mni        = false;
    scan.mvpa.name       = 'pilot';
    scan.mvpa.pooling    = true;
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
                          'R_G_rH', ... optimal distance to goal (relative to overall length of optimal journey)', ...
                          'D_G_rH', ... optimal distance to goal (in # stations)', ...
                          'T_0_rH', ... number of trials from start', ...
                          'R_G_rL', ... optimal distance to goal (relative to overall length of optimal journey)', ...
                          'D_G_rL', ... optimal distance to goal (in # stations)', ...
                          'T_0_rL', ... number of trials from start', ...
                       }  ...
        },'level',   { {                                        ... level
                           optm_dist_relstation_goal_rH,        ...
                           optm_dist_station_goal_rH,           ...
                           expt_trial_rH,                       ...
                           optm_dist_relstation_goal_rL,           ...
                           optm_dist_station_goal_rL,              ...
                           expt_trial_rL,                          ...
                        } ...
        });
    scan.mvpa.runmean    = false;
    scan.mvpa.verbose    = false;
    
    % specific to UNI
    scan.mvpa.plot.dimension = 'horizontal';

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_uni(scan);
end
