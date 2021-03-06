
function scan = ppi_roi()
    %% scan = PPI_ROI()

    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NBRAK>
    
    %% SCANNER
    scan = parameters();
    
    %% SET SUBJECTS
    scan.subject.r      = [6,10];
    
    %% PPI SETTINGS
    scan.ppi.seed       = 'ROI/mask/Crblm.img';
    scan.ppi.cond       = {'C','L','I','R'};
    scan.ppi.contrasts.generic = true;
    scan.ppi.contrasts.extra   = struct('name',{},'regressor',{},'weight',{});
    
    %% GLM SETTINGS
    scan.glm.copy       = true(1,6);
    scan.glm.delay      = 0;
    scan.glm.function   = 'hrf';
    scan.glm.hrf.ord    = [0,0];
    scan.glm.image      = 'smooth4';
    scan.glm.marge      = 5;
    scan.glm.name       = 'ppi_CLIR_Crblm';
    scan.glm.pooling    = true;
    scan.glm.redo       = 1;
    scan.glm.contrasts.generic = false;
    scan.glm.contrasts.extra   = struct('name',{},'regressor',{},'weight',{});
    
    %% LOAD DATA
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    
    %% INDEXES
    ii_N      = (~data.resp_bool | data.resp_away_any);
    ii_C      = (~ii_N &  data.vbxi_exchange_in &  data.resp_direction_switch);
    ii_L      = (~ii_N & ~data.vbxi_exchange_in &  data.resp_direction_switch);
    ii_I      = (~ii_N &  data.vbxi_exchange_in & ~data.resp_direction_switch);
    ii_R      = (~ii_N & ~data.vbxi_exchange_in & ~data.resp_direction_switch);
    
    %% REGRESSORS
    
    % regressors
    r_data_Dgoal    = zscore(data.optm_dist_station_goal);

    % struct
    scan.glm.regressor = struct(                        ...
        'subject', {                                    ... subject
                     block.expt_subject ,               ...
                     data.expt_subject(ii_N),           ...
                     data.expt_subject(ii_C),           ...
                     data.expt_subject(ii_L),           ...
                     data.expt_subject(ii_I),           ...
                     data.expt_subject(ii_R),           ...
                     block.expt_subject },              ...
        'session', {                                    ... session
                     block.expt_session ,               ...
                     data.expt_session(ii_N),           ...
                     data.expt_session(ii_C),           ...
                     data.expt_session(ii_L),           ...
                     data.expt_session(ii_I),           ...
                     data.expt_session(ii_R),           ...
                     block.expt_session },              ...
        'onset',   {                                    ... onset
                     block.vbxi_onset_cue ,             ...
                     data.vbxi_onset(ii_N),             ...
                     data.vbxi_onset(ii_C),             ...
                     data.vbxi_onset(ii_L),             ...
                     data.vbxi_onset(ii_I),             ...
                     data.vbxi_onset(ii_R),             ...
                     block.vbxi_onset_reward },         ...
        'discard', {                                    ... discard
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     [],                                ...
                     isnan(block.vbxi_onset_reward) },  ... %(participant 1 didn't get a feedback in the last block)
        'name',    {                                    ... name
                     'Cue' ,                            ...
                     'N' ,                              ...
                     'C' ,                              ...
                     'L' ,                              ...
                     'I' ,                              ...
                     'R' ,                              ...
                     'Feed' },                          ...
        'subname', {                                    ... subname
                     {                                  ...   Cue
                     },                                 ...
                     {                                  ...   N
                     },                                 ...
                     {                                  ...   C
                       'C(Dgoal)',                      ...
                     },                                 ...
                     {                                  ...   L
                       'L(Dgoal)',                      ...
                     },                                 ...
                     {                                  ...   I
                       'I(Dgoal)',                      ...
                     },                                 ...
                     {                                  ...   R
                       'R(Dgoal)',                      ...
                     },                                 ...
                     {                                  ...   Feed
                     } },                               ...
        'level',   {                                    ... level
                     {                                  ...     cues
                     }, {                               ...     N
                     }, {                               ...     C
                        r_data_Dgoal(ii_C),             ...
                     }, {                               ...     L
                        r_data_Dgoal(ii_L),             ...
                     }, {                               ...     I
                        r_data_Dgoal(ii_I),             ...
                     }, {                               ...     R
                        r_data_Dgoal(ii_R),             ...
                     }, {                               ...     feed
                     } },                               ...
        'duration',{                                    ... duration
                     0,                                 ...     cues
                     0,                                 ...     N
                     0,                                 ...     C
                     0,                                 ...     L
                     0,                                 ...     I
                     0,                                 ...     R
                     0,                                 ...     feed
                     });
                                     
    %% SANITY CHECK
    scan = scan_initialize(scan);
    
    %% COPY SCRIPT
    mkdirp(scan.dire.glm.root);
    file_script = mfilename('fullpath');
    if ~isempty(file_script)
        copyfile(sprintf('%s.m',file_script),sprintf('%sppi_run.m',scan.dire.glm.root));
    end
    copyfile(['data/mask/',scan.ppi.seed],scan.dire.glm.root);
    
    %% RUN
    scan = scan_ppi_run(scan);
end
