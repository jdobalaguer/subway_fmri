
function scan = mvpa_uni(scan)
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU>
    
    %% SCANNER
    if ~exist('scan','var'), scan = parameters(); end
    
    %% SET SUBJECTS
    if ~isfield(scan,'subject'), scan.subject = struct(); end
    if isfield(scan.subject,'u'), scan.subject = rmfield(scan.subject,'u'); end
    if isfield(scan.subject,'r'), scan.subject = rmfield(scan.subject,'r'); end
    scan.subject.r = [6,10];
%     scan.subject.u = 1;
    
    %% LOAD
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    maps = load_maps(      'scanner');
    
    %% BLOCK EXTEND
%     block.expt_trial_max       = jb_applyvector(@(subject,session,block) max(data.expt_trial(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),block.expt_subject,block.expt_session,block.expt_block);
%     block.resp_exchange_in_sum = jb_applyvector(@(subject,session,block) sum(data.vbxi_exchange_in(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.resp_bool)),block.expt_subject,block.expt_session,block.expt_block);
%     block.resp_away_any        = jb_applyvector(@(subject,session,block) any(data.resp_away(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.resp_bool)),block.expt_subject,block.expt_session,block.expt_block);
    
    %% DATA EXTEND
    
    % goal reached
    function g = block_resp_goal(s,r,b), g = unique(block.resp_goal(block.expt_subject==s & block.expt_session==r & block.expt_block==b)); end
    data.resp_goal = jb_applyvector(@block_resp_goal,data.expt_subject,data.expt_session,data.expt_block);
    
    % easy
    data.vbxi_easy = (data.vbxi_subline_goal == data.vbxi_subline_start);
    
    % maximum trial per journey
    data.expt_trial_max = jb_applyvector(@(subject,session,block) max(data.expt_trial(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),data.expt_subject,data.expt_session,data.expt_block);
    
    % previous subgoal distance (number of trials)
    function subgoal = previous_subgoal_find(subject,session,block,trial), subgoal = data.vbxi_station_in(find(data.resp_subline_change & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial < trial, 1, 'last')); if isempty(subgoal), subgoal = nan; end; end
    vbxi_previous_subgoal_find = jb_applyvector(@previous_subgoal_find,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    function subgoal = previous_subgoal_time(subject,session,block,trial), subgoal = data.expt_trial(find(data.resp_subline_change & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial < trial, 1, 'last')); if isempty(subgoal), subgoal = nan; end; end
    vbxi_previous_subgoal_time = jb_applyvector(@previous_subgoal_time,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    function dist = previous_subgoal_dist(subject), ii_subject = (data.expt_subject == subject); dist = data.expt_trial(ii_subject) - vbxi_previous_subgoal_time(ii_subject); end
    vbxi_previous_subgoal_dist = jb_applyvector(@previous_subgoal_dist,data.expt_subject);

    % next subgoal distance (optimal path)
    function subgoal = next_subgoal_find(         subject,session,block,trial), subgoal = data.vbxi_station_in(find(data.resp_subline_change & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial > trial, 1, 'first')); if isempty(subgoal), subgoal = nan; end; end
    vbxi_next_subgoal_find = jb_applyvector(@next_subgoal_find,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    function dist = next_subgoal_optm(subject), ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(vbxi_next_subgoal_find); ii_dist = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.steptimes_stations(vbxi_next_subgoal_find(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    vbxi_next_subgoal_dist = jb_applyvector(@next_subgoal_optm,data.expt_subject);
    
    % previous exchange distance (number of trials)
    function exchange = previous_exchange_find(subject,session,block,trial), exchange = data.expt_trial(find(data.vbxi_exchange_in & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial < trial, 1, 'last')); if isempty(exchange), exchange = nan; end; end
    vbxi_previous_exchange_time = jb_applyvector(@previous_exchange_find,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    function dist = previous_exchange_time(subject), ii_subject = (data.expt_subject == subject); dist = data.expt_trial(ii_subject) - vbxi_previous_exchange_time(ii_subject); end
    vbxi_previous_exchange_dist = jb_applyvector(@previous_exchange_time,data.expt_subject);
    
    % next exchange distance (optimal path)
    function exchange = next_exchange_find(         subject,session,block,trial),exchange = data.vbxi_station_in(find(data.vbxi_exchange_in & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial > trial, 1, 'first')); if isempty(exchange), exchange = nan; end; end
    vbxi_next_exchange_find = jb_applyvector(@next_exchange_find,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    function dist = next_exchange_optm(subject), ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(vbxi_next_exchange_find); ii_dist = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.steptimes_stations(vbxi_next_exchange_find(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    vbxi_next_exchange_dist = jb_applyvector(@next_exchange_optm,data.expt_subject);
    
    % number of changes
    block.resp_subline_change_sum = jb_applyvector(@(subject,session,block) sum(data.resp_subline_change(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),block.expt_subject,block.expt_session,block.expt_block);
    data.resp_subline_change_sum  = jb_applyvector(@(subject,session,block) sum(data.resp_subline_change(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),data.expt_subject,data.expt_session,data.expt_block);
    
    % length of subjourney
    function dist = subjourney_dist(subject), ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(vbxi_next_subgoal_find) & ~isnan(vbxi_previous_subgoal_find); ii_dist = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.steptimes_stations(vbxi_next_subgoal_find(ii_subject & ii_notanan),vbxi_previous_subgoal_find(ii_subject & ii_notanan))); end
    data.optm_subjourney_dist = jb_applyvector(@subjourney_dist,data.expt_subject);
    
    %% INDEX
    ii_bool  = logical( data.resp_bool);
    ii_ball  = logical( data.resp_bool_all);
    ii_null  = logical(~data.resp_bool);
    ii_away  = logical( data.resp_away_any);
    ii_forw  = logical(~data.resp_away_any);
    ii_corr  = logical( data.resp_correct_all);
    ii_bail  = logical(~data.resp_goal);
    ii_goal  = logical( data.resp_goal);
    ii_easy  = logical( data.vbxi_easy);
    ii_hard  = logical(~data.vbxi_easy);
    ii_rewa  = logical( data.vbxi_reward > 1);
    ii_short = (data.optm_dist_station_journey<8);
    
    ii = ii_bool;
    ii = ii_corr;
%     ii = ii_forw & ii_hard;
%     ii = ii_corr & ii_hard;
%     ii = ii_bool & ii_hard & ii_goal;
%     ii = ii_forw & ii_hard & ii_goal;
%     ii = ii_corr & ii_hard & ii_goal;
    
    %% REGRESSORS
    
    % GLM regressors
    r_data_Tgoal    = (data.expt_trial);
    r_data_Dgoal    = (data.optm_dist_station_goal);
    
    r_data_Tchange  = (vbxi_previous_subgoal_dist);
    r_data_Tchange(isnan(r_data_Tchange)) = nan;
    r_data_Dchange  = (vbxi_next_subgoal_dist);
    r_data_Dchange(isnan(r_data_Dchange)) = nan;
    
    r_data_Texchange  = (vbxi_previous_exchange_dist);
    r_data_Texchange(isnan(r_data_Texchange)) = nan;
    r_data_Dexchange  = (vbxi_next_exchange_dist);
    r_data_Dexchange(isnan(r_data_Dexchange)) = nan;
    
    % number of trials from start
    expt_trial    = r_data_Tgoal;
    expt_trial_rH = expt_trial; expt_trial_rH(~ii_rewa) = nan;
    expt_trial_rL = expt_trial; expt_trial_rL( ii_rewa) = nan;
    
    % optimal distance to goal (in # stations)
    optm_dist_station_goal    = r_data_Dgoal;
    optm_dist_station_goal_rH = r_data_Dgoal; optm_dist_station_goal_rH(~ii_rewa) = nan;
    optm_dist_station_goal_rL = r_data_Dgoal; optm_dist_station_goal_rL( ii_rewa) = nan;
    
    % relative optimal distance to goal
    n = 8;
    optm_dist_relstation_goal = nan(size(data.expt_subject));
    optm_dist_relstation_goal(ii) = data.optm_dist_station_goal(ii) ./ data.optm_dist_station_journey(ii);
    [optm_dist_relstation_goal(ii),q] = jb_discretize(optm_dist_relstation_goal(ii),n);
    q = q(2:end)-0.5*diff(q);
    q = jb_precision(q,3);
    optm_dist_relstation_goal(ii) = jb_replace(optm_dist_relstation_goal(ii),num2cell(1:n),num2cell(q));
    
    optm_dist_relstation_goal_rH = nan(size(data.expt_subject));
    optm_dist_relstation_goal_rH(ii & ii_rewa) = data.optm_dist_station_goal(ii & ii_rewa) ./ data.optm_dist_station_journey(ii & ii_rewa);
    [optm_dist_relstation_goal_rH(ii & ii_rewa),q] = jb_discretize(optm_dist_relstation_goal_rH(ii & ii_rewa),n);
    q = q(2:end)-0.5*diff(q);
    q = jb_precision(q,3);
    optm_dist_relstation_goal_rH(ii & ii_rewa) = jb_replace(optm_dist_relstation_goal_rH(ii & ii_rewa),num2cell(1:n),num2cell(q));
    
    optm_dist_relstation_goal_rL = nan(size(data.expt_subject));
    optm_dist_relstation_goal_rL(ii & ~ii_rewa) = data.optm_dist_station_goal(ii & ~ii_rewa) ./ data.optm_dist_station_journey(ii & ~ii_rewa);
    [optm_dist_relstation_goal_rL(ii & ~ii_rewa),q] = jb_discretize(optm_dist_relstation_goal_rL(ii & ~ii_rewa),n);
    q = q(2:end)-0.5*diff(q);
    q = jb_precision(q,3);
    optm_dist_relstation_goal_rL(ii & ~ii_rewa) = jb_replace(optm_dist_relstation_goal_rL(ii & ~ii_rewa),num2cell(1:n),num2cell(q));
    
    % optimal distance of journey
    optm_dist_station_journey = data.optm_dist_station_journey;
    
    % optimal distance to change (in # stations)
    optm_dist_station_subgoal = r_data_Tchange;
    
    % optimal distance from change (in # stations)
    optm_time_station_subgoal = r_data_Dchange;
    
    % optimal distance of subjourney
    optm_subjourney_dist = data.optm_subjourney_dist;
    optm_subjourney_dist(isnan(optm_subjourney_dist)) = nan;
    
    % optimal distance to exchange (in # stations)
    optm_dist_station_exchange = r_data_Texchange;
    
    % optimal distance from exchange (in # stations)
    optm_time_station_exchange = r_data_Dexchange;
    
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
    
    % DISTANCE TO SUBGOAL
%     scan.mvpa.mask       = 'voxs4/CvsLIR_004_OFC.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_003_precuneus.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_003_cerebellum.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_004_PSL.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_002_FS.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_sma.img';
%     scan.mvpa.mask       = 'voxs4/Dchange_sma.img';
%     scan.mvpa.mask       = 'voxs4/TDchange_dacc.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_racc.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_fusiform.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_amygdala.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_dlpfc.img';

    % CRAZY
%     scan.mvpa.mask       = 'crazy/mask_parietal.img';
%     scan.mvpa.mask       = 'crazy/mask_frontopolar.img';
%     scan.mvpa.mask       = 'crazy/mask_sma.img';
%     scan.mvpa.mask       = 'crazy/mask_sma_ex.img';

    % CONTROLLED
%     scan.mvpa.mask       = 'controlled/Dchange(mcc).img';
%     scan.mvpa.mask       = 'controlled/Dchange(sma).img';
%     scan.mvpa.mask       = 'controlled/TDgoal(vmpfc).img';
    
    % JANUARY
%     scan.mvpa.mask       = 'january/IPL.img';
%     scan.mvpa.mask       = 'january/PMC.img';
%     scan.mvpa.mask       = 'january/PMC_controlled.img';

    % LINEAR
%     scan.mvpa.mask       = 'linear/vmpfc.img';
%     scan.mvpa.mask       = 'linear/acc.img';
%     scan.mvpa.mask       = 'linear/acc2.img';
%     scan.mvpa.mask       = 'linear/pmc.img';
%     scan.mvpa.mask       = 'linear/ips.img';
%     scan.mvpa.mask       = 'linear/hippocampus.img';
%     scan.mvpa.mask       = 'linear/sma.img';
    scan.mvpa.mask       = 'linear/change.img';

    
    scan.mvpa.mni        = false;
    scan.mvpa.name       = 'pilot';
    scan.mvpa.pooling    = true;
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
%                           'R_G_rH', ... optimal distance to goal (relative to overall length of optimal journey)', ...
%                           'D_G_rH', ... optimal distance to goal (in # stations)', ...
%                           'T_0_rH', ... number of trials from start', ...
%                           'R_G_rL', ... optimal distance to goal (relative to overall length of optimal journey)', ...
%                           'D_G_rL', ... optimal distance to goal (in # stations)', ...
%                           'T_0_rL', ... number of trials from start', ...
                          'R_G', ... optimal distance to goal (relative to overall length of optimal journey)', ...
                          'D_G', ... optimal distance to goal (in # stations)', ...
                          'T_0', ... number of trials from start', ...
                          'D_C', ... optimal distance to change (in # stations)', ...
                          'T_C', ... optimal distance from change (in # stations)', ...
%                           'D_X', ... optimal distance to exchange (in # stations)', ...
%                           'T_X', ... optimal distance from exchange (in # stations)', ...
%                           'L_G', ...  overall length of optimal journey', ...
%                           'L_C', ... overall length of optimal subjourney', ...
                       }  ...
        },'level',   { {                                        ... level
%                            optm_dist_relstation_goal_rH,        ...
%                            optm_dist_station_goal_rH,           ...
%                            expt_trial_rH,                       ...
%                            optm_dist_relstation_goal_rL,           ...
%                            optm_dist_station_goal_rL,              ...
%                            expt_trial_rL,                          ...
                           optm_dist_relstation_goal,           ...
                           optm_dist_station_goal,              ...
                           expt_trial,                          ...
                           optm_dist_station_subgoal,           ...
                           optm_time_station_subgoal,           ...
%                            optm_dist_station_exchange,          ...
%                            optm_time_station_exchange,          ...
%                            optm_dist_station_journey            ...
%                            optm_subjourney_dist,                ...
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
