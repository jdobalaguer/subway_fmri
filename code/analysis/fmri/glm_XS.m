
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
    scan.glm.name       = 'GLMM_fir14-0&8_Cues_Fill_Easy_First_Then(X+S+XS+Z+U+V+B+Y+O+T+A)_Feed';
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
    ii_then  = ii_hard & (~data.expt_first );
    % regressors
    scan.glm.regressor = struct(                        ...
        'subject', {                                    ... subject
                     block.expt_subject ,               ...
                     data.expt_subject(ii_fill),        ...
                     data.expt_subject(ii_easy),        ...
                     data.expt_subject(ii_first),       ...
                     data.expt_subject(ii_then),        ...
                     block.expt_subject },              ...
        'session', {                                    ... session
                     block.expt_session ,               ...
                     data.expt_session(ii_fill),        ...
                     data.expt_session(ii_easy),        ...
                     data.expt_session(ii_first),       ...
                     data.expt_session(ii_then),        ...
                     block.expt_session },              ...
        'onset',   {                                    ... onset
                     block.vbxi_onset_cue ,             ...
                     data.vbxi_onset(ii_fill),          ...
                     data.vbxi_onset(ii_easy),          ...
                     data.vbxi_onset(ii_first),         ...
                     data.vbxi_onset(ii_then),          ...
                     block.vbxi_onset_reward },         ...
        'discard', {                                    ... discard
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
                     'Then' ,                           ...
                     'Feed' },                          ...
        'subname', {                                    ... subname
                     {},                                ...
                     {} ,                               ...
                     {} ,                               ...
                     {} ,                               ...
                     {'Then(X)','Then(S)','Then(XS)','Then(Z)','Then(U)','Then(V)','Then(B)','Then(Y)','Then(O)','Then(T)','Then(A)'}, ...
                     {} },                              ...
        'level',   {                                    ... level
                     {                                  ...     cues
                     }, {                               ...     fill
                     }, {                               ...     easy
                     }, {                               ... first
                     }, {                               ... then
                          ztransf(data.vbxi_exchange_in(ii_then)),                                                  ... X
                          ztransf(data.resp_direction_switch(ii_then)),                                             ... S
                          ztransf(data.vbxi_exchange_in(ii_then)) .* ztransf(data.resp_direction_switch(ii_then)),  ... XS
                          ztransf(           data.optm_dist_station_goal(    ii_then)),                             ... Z
                          ztransf(jb_replace(data.optm_dist_station_subgoal( ii_then),{nan},{0})),                  ... U
                          ztransf(jb_replace(data.optm_dist_station_subelbow(ii_then),{nan},{0})),                  ... V
                          ztransf(           data.optm_dist_station_boundary(ii_then)),                             ... B
                          ztransf(           data.optm_dist_subline_goal(    ii_then)),                             ... Y
                          ztransf(data.optm_change_can(ii_then) & ~data.optm_change_must(ii_then)),                 ... O
                          ztransf(data.resp_reactiontime(ii_then)),                                                 ... T
                          ztransf(data.expt_trial(ii_then)),                                                        ... A
                     }, {                               ...     feed
                     } },                               ...
        'duration',{                                    ... duration
                     0,                                 ...     cues
                     0,                                 ...     fill
                     0,                                 ...     easy
                     0,                                 ...     first
                     0,                                 ...     then
                     0,                                 ...     feed
                     });
                                     
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan_glm_run(scan);
end
