
function scan3_glm()
    %% SCAN3_GLM()
    % runs a General Linear Model (GLM)
    % see also scan3_preprocess
    %          scan3_mvpa
    
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% CLEAN
    clearvars -global;
    
    %% LOCAL PARAMETERS
    global name_glm name_image r_subject do_pooling;
    global u_subject;
    
    delete_all      = 0;

    name_glm        = 'GLMM_hrf_Cues(H+Z)_Fill_Easy(X+S+B+R+Z+RZ)_Hard(X+S+B+U+R+Z+RZ)_Feed(H+G+R+GR)';
    name_image      = 'smooth'; ... "image" "normalization" "smooth"
        
    r_subject       = [6,10];
    do_pooling      = 1;
    
    %% GLOBAL PARAMETERS
    global dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast;
    scan_parameters();
    
    %% GLM REGRESSORS
    global glm_regressors;
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    
    % temporary indexes
    ii_back  = logical(data.resp_direction_back_any);
    ii_null  = (~data.resp_bool);
    ii_away  = (~ii_back & ~ii_null & data.resp_away_any);
    ii_fill  = ( ii_back |  ii_null &  ii_away);
    ii_forw  = (~ii_back & ~ii_null & ~ii_away);
    ii_easy  = ii_forw & (data.vbxi_subline_start == data.vbxi_subline_goal);
    ii_hard  = ii_forw & (data.vbxi_subline_start ~= data.vbxi_subline_goal);
    
    % regressors
    glm_regressors = struct('subject', {                                    ... subject
                                         block.expt_subject ,               ...
                                         data.expt_subject(ii_fill),        ...
                                         data.expt_subject(ii_easy),        ...
                                         data.expt_subject(ii_hard),        ...
                                         block.expt_subject },              ...
                            'session', {                                    ... session
                                         block.expt_session ,               ...
                                         data.expt_session(ii_fill),        ...
                                         data.expt_session(ii_easy),        ...
                                         data.expt_session(ii_hard),        ...
                                         block.expt_session },              ...
                            'onset',   {                                    ... onset
                                         block.vbxi_onset_cue ,             ...
                                         data.vbxi_onset(ii_fill),          ...
                                         data.vbxi_onset(ii_easy),          ...
                                         data.vbxi_onset(ii_hard),          ...
                                         block.vbxi_onset_reward },         ...
                            'discard', {                                    ... discard
                                         [],                                ...
                                         [],                                ...
                                         [],                                ...
                                         [],                                ...
                                         isnan(block.vbxi_onset_reward) },  ... %(participant 1 didn't get a feedback in the last block)
                            'name',    {                                    ... name
                                         'Cue' ,                            ...
                                         'Fill' ,                           ...
                                         'Easy' ,                           ...
                                         'Hard' ,                           ...
                                         'Feed' },                          ...
                            'subname', {                                    ... subname
                                         {'Cues(H)','Cues(Z)'}, ...
                                         {} ,                               ...
                                         {'Easy(X)','Easy(S)','Easy(B)',          'Easy(R)','Easy(Z)','Easy(RZ)'} , ...
                                         {'Hard(X)','Hard(S)','Hard(B)','Hard(U)','Hard(R)','Hard(Z)','Hard(RZ)'} , ...
                                         {'Feed(H)','Feed(G)','Feed(R)','Feed(GR)'} }, ...
                            'level',   {                                    ... level
                                         {                                  ...     cues
                                            ztransf(block.optm_dist_subline_journey>1) , ...
                                            ztransf(jb_discretize(block.optm_dist_station_journey,2)), ...
                                         }, {                               ...     fill
                                         }, {                               ...     easy
                                            ztransf(data.vbxi_exchange_in(ii_easy)), ...
                                            ztransf(data.resp_direction_switch(ii_easy)), ...
                                            ztransf(data.optm_dist_station_goal(ii_easy)), ...
                                         }, {                               ...     hard
                                            ztransf(data.vbxi_exchange_in(ii_hard)), ...
                                            ztransf(data.resp_direction_switch(ii_hard)), ...
                                            ztransf(data.optm_dist_station_boundary(ii_hard)), ...
                                            ztransf(data.optm_dist_station_subgoal(ii_hard)), ...
                                            ztransf(data.optm_dist_station_goal(ii_hard)), ...
                                            ztransf(data.vbxi_exchange_in(ii_hard))      .* ztransf(data.resp_direction_switch(ii_hard)), ...
                                            ztransf(data.vbxi_exchange_in(ii_hard))      .* ztransf(data.optm_dist_station_goal(ii_hard)), ...
                                            ztransf(data.resp_direction_switch(ii_hard)) .* ztransf(data.optm_dist_station_goal(ii_hard)), ...
                                            ztransf(data.vbxi_exchange_in(ii_hard))      .* ztransf(data.resp_direction_switch(ii_hard)) .* ztransf(data.optm_dist_station_goal(ii_hard)), ...
                                         }, {                               ...     feed
                                            ztransf(block.resp_goal),       ...
                                            ztransf(block.vbxi_reward),     ...
                                            ztransf(block.resp_goal) .* ztransf(block.vbxi_reward) ...
                                         } },                               ...
                            'duration',{                                    ... duration
                                         0,                                 ...     fill
                                         0,                                 ...     easy
                                         0,                                 ...     hard
                                         0                                  ...     feed
                                         });
    
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
    
    %% COPY CONFIGURATION
    mkdirp(dire_glm);
    copyfile([mfilename('fullpath'),'.m'],[dire_glm,'scan3_glm.m']);                        % copy scan3_glm.m
    copyfile('code/analysis/fmri/scan/scan_parameters.m',[dire_glm,'scan_parameters.m']);   % copy scan_parameters.m
    
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