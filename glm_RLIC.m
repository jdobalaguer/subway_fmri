
function scan = glm()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan.pars.nslices = 32;
    scan.pars.tr      = 2;
    scan.pars.ordsl   = scan.pars.nslices:-1:+1;
    scan.pars.refsl   = scan.pars.ordsl(1);
    scan.pars.reft0   = (find(scan.pars.ordsl==scan.pars.refsl)-1) * (scan.pars.tr/scan.pars.nslices);
    scan.pars.voxs    = 4;
    
    %% SET SUBJECTS
    scan.subject.r      = [6,10];
    
    %% GLM SETTINGS
    scan.glm.copy       = true(1,6);
    scan.glm.delay      = 0;
    scan.glm.fir.ord    = 8;
    scan.glm.fir.len    = 14;
    scan.glm.function   = 'fir';
    scan.glm.image      = 'smooth';
    scan.glm.marge      = 5;
    scan.glm.name       = 'GLMM_fir14-0&8_Cues_Fill_Easy_First(Z)_R(Z)_L(Z)_I(Z)_C(Z)_Feed';
    scan.glm.pooling    = 1;
    scan.glm.redo       = 1;
    
    scan.glm.plot.contrast  = '';
    scan.glm.plot.mask      = '';
    scan.glm.plot.extension = 'img';
    scan.glm.plot.directory = '';

    %% GLM REGRESSORS
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    % temporary indexes
    ii_back  = logical(data.resp_direction_back_any);
    ii_null  = (~data.resp_bool);
    ii_away  = (~ii_back & ~ii_null & data.resp_away_any);
    ii_fill  = ( ii_back |  ii_null |  ii_away);
    ii_forw  = (~ii_back & ~ii_null & ~ii_away);
    ii_easy  = ii_forw & (data.vbxi_subline_start == data.vbxi_subline_goal);
    ii_hard  = ii_forw & (data.vbxi_subline_start ~= data.vbxi_subline_goal);
    ii_first = ii_hard & ( data.expt_first );
    ii_r     = ii_hard & (~data.expt_first & ~data.vbxi_exchange_in & ~data.resp_direction_switch);
    ii_l     = ii_hard & (~data.expt_first & ~data.vbxi_exchange_in &  data.resp_direction_switch);
    ii_i     = ii_hard & (~data.expt_first &  data.vbxi_exchange_in & ~data.resp_direction_switch);
    ii_c     = ii_hard & (~data.expt_first &  data.vbxi_exchange_in &  data.resp_direction_switch);
    % regressors
    scan.glm.regressor = struct(                        ...
        'subject', {                                    ... subject
                     block.expt_subject ,               ...
                     data.expt_subject(ii_fill),        ...
                     data.expt_subject(ii_easy),        ...
                     data.expt_subject(ii_first),       ...
                     data.expt_subject(ii_r),           ...
                     data.expt_subject(ii_l),           ...
                     data.expt_subject(ii_i),           ...
                     data.expt_subject(ii_c),           ...
                     block.expt_subject },              ...
        'session', {                                    ... session
                     block.expt_session ,               ...
                     data.expt_session(ii_fill),        ...
                     data.expt_session(ii_easy),        ...
                     data.expt_session(ii_first),       ...
                     data.expt_session(ii_r),           ...
                     data.expt_session(ii_l),           ...
                     data.expt_session(ii_i),           ...
                     data.expt_session(ii_c),           ...
                     block.expt_session },              ...
        'onset',   {                                    ... onset
                     block.vbxi_onset_cue ,             ...
                     data.vbxi_onset(ii_fill),          ...
                     data.vbxi_onset(ii_easy),          ...
                     data.vbxi_onset(ii_first),         ...
                     data.vbxi_onset(ii_r),             ...
                     data.vbxi_onset(ii_l),             ...
                     data.vbxi_onset(ii_i),             ...
                     data.vbxi_onset(ii_c),             ...
                     block.vbxi_onset_reward },         ...
        'discard', {                                    ... discard
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     isnan(block.vbxi_onset_reward) },  ... %(participant 1 didn't get a feedback in the last block)
        'name',    {                                    ... name
                     'Cue' ,                            ...
                     'Fill' ,                           ...
                     'Easy' ,                           ...
                     'First' ,                          ...
                     'R' ,                              ...
                     'L' ,                              ...
                     'I' ,                              ...
                     'C' ,                              ...
                     'Feed' },                          ...
        'subname', {                                    ... subname
                     {},                                ...
                     {} ,                               ...
                     {} ,                               ...
                     {'First(Z)'} ,                     ...
                     {'R(Z)'} ,                         ...
                     {'L(Z)'} ,                         ...
                     {'I(Z)'} ,                         ...
                     {'C(Z)'} ,                         ...
                     {} },                              ...
        'level',   {                                    ... level
                     {                                  ...     cues
                     }, {                               ...     fill
                     }, {                               ...     easy
                     }, { ztransf(1./data.optm_dist_station_goal(ii_first)) ... first
                     }, { ztransf(1./data.optm_dist_station_goal(ii_r)) ... regular  (r)
                     }, { ztransf(1./data.optm_dist_station_goal(ii_l)) ... elbow    (l)
                     }, { ztransf(1./data.optm_dist_station_goal(ii_i)) ... exchange (i)
                     }, { ztransf(1./data.optm_dist_station_goal(ii_c)) ... exchange (c)
                     }, {                               ...     feed
                     } },                               ...
        'duration',{                                    ... duration
                     0,                                 ...     cues
                     0,                                 ...     fill
                     0,                                 ...     easy
                     0,                                 ...     first
                     0,                                 ...     regular  (r)
                     0,                                 ...     elbow    (l)
                     0,                                 ...     exchange (i)
                     0,                                 ...     exchange (c)
                     0,                                 ...     feed
                     });
                                     
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan_glm_run(scan);
end