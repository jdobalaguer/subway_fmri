
function scan = mvpa_uni(scan)
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    if ~exist('scan','var'), scan = parameters(); end
    
    %% SET SUBJECTS
    if ~isfield(scan,'subject'), scan.subject = struct(); end
    if isfield(scan.subject,'u'), scan.subject = rmfield(scan.subject,'u'); end
    if isfield(scan.subject,'r'), scan.subject = rmfield(scan.subject,'r'); end
    scan.subject.r = [6,10];
%     scan.subject.u = 1;
    
    %% INDEX
    ii_back  = logical(data.resp_direction_back_any);
    ii_null  = (~data.resp_bool);
    ii_away  = (~ii_back & ~ii_null & data.resp_away_any);
    ii_fill  = ( ii_back |  ii_null |  ii_away);
    ii_forw  = (~ii_back & ~ii_null & ~ii_away);
    ii_corr  = logical(data.resp_correct_all);
    ii_first = ( data.expt_first );
    ii_easy  = ( data.vbxi_subline_start == data.vbxi_subline_goal);
    ii_hard  = ( data.vbxi_subline_start ~= data.vbxi_subline_goal);
    ii_first = ( data.expt_first );
    ii_far       = (data.optm_dist_subline_goal>1);
    ii_regular   = (data.vbxi_regular_in);
    
%     ii = (~data.expt_first & data.resp_bool);
%     ii = (ii_easy & ii_regular);
%     ii = ii_hard;
%     ii = ~ii_null & ii_back;
%     ii = ~ii_null & ~ii_back;
%     ii =  ii_null & ~ii_back;
%     ii = ii_corr;
    ii = ii_corr & ii_hard;
    ii = ii_corr & ii_easy;
%     ii = ii_corr;
%     ii = (ii_hard & (~isnan(data.optm_dist_station_subgoal) | data.resp_subline_change) & ii_corr);

    
%     optm_dist_station_goal = nan(size(data.optm_dist_station_goal));
%     [u_subject,n_subject] = numbers(data.expt_subject);
%     for i_subect = 1:n_subject
%         ii_subject = logical(data.expt_subject == u_subject(i_subect));
%         optm_dist_station_goal(ii_subject) = jb_discretize(data.optm_dist_station_goal(ii_subject),2);
% %         optm_dist_station_goal(ii_subject) = jb_discretize(data.optm_dist_station_goal(ii_subject) ./ data.optm_dist_station_journey(ii_subject),2);
%     end

    optm_dist_station_goal = data.optm_dist_station_goal;
    optm_dist_station_goal(optm_dist_station_goal>5) = 5;
    
    optm_dist_station_subgoal = data.optm_dist_station_subgoal;
    optm_dist_station_subgoal(isnan(optm_dist_station_subgoal)) = 0;
    optm_dist_station_subgoal(optm_dist_station_subgoal > 10) = 10;
    
    expt_trial = data.expt_trial;
    expt_trial(expt_trial>10) = 10;
    
    
    %% MVPA SETTINGS
    scan.mvpa.extension  = 'img';            % GLM files
    scan.mvpa.glm        = 'smooth4';
    scan.mvpa.image      = 'Trial';
    
    % DISTANCE TO GOAL
%     scan.mvpa.mask       = 'voxs4_old/Z_mpfc.img';
%     scan.mvpa.mask       = 'voxs4/R(Z)_003_temporal_pole_left.img';
%     scan.mvpa.mask       = 'voxs4/R(Z)_004_acc_right.img';
%     scan.mvpa.mask       = 'voxs4_old/CZ_ifg.img';
    scan.mvpa.mask       = 'xjview4/hippocampus_left.img';
    
    % DISTANCE TO SUBGOAL
%     scan.mvpa.mask       = 'voxs4/CvsLIR_004_OFC.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_003_precuneus.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_003_cerebellum.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_004_PSL.img';
%     scan.mvpa.mask       = 'voxs4/CvsLIR_002_FS.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_sma.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_racc.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_fusiform.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_amygdala.img';
%     scan.mvpa.mask       = 'voxs4_old/XS_dlpfc.img';
    
    scan.mvpa.mni        = false;
    scan.mvpa.name       = 'pilot';
    scan.mvpa.pooling    = true;
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
%                           'expt_trial',                         ...
                          'optm_dist_station_goal',             ...
%                           'optm_dist_station_subgoal';          ...
                       }  ...
        },'level',   { {                                        ... level
%                            expt_trial,                          ...
                           optm_dist_station_goal,              ...
%                            optm_dist_station_subgoal,           ...
                        } ...
        });
    scan.mvpa.runmean    = false;

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_uni(scan);
end
