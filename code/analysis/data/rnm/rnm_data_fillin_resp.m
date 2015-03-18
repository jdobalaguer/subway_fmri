
% response
function data = rnm_data_fillin_resp(data,maps)
    
    %% bool
    data.resp_bool_all = jb_applyvector( ...
        @(subject,session,block) all(data.resp_bool(data.expt_subject == subject & data.expt_session == session & data.expt_block == block)),   ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                                 ... categories
        
    data.resp_correct_all = jb_applyvector( ...
        @(subject,session,block) all(data.resp_correct(data.expt_subject == subject & data.expt_session == session & data.expt_block == block)),... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                                 ... categories
        
    %% station
    data.resp_station_isgoal = (data.resp_station_to == data.vbxi_station_goal);
    
    % subgoal
    function subgoal = find_subgoal(subject,session,block,trial), subgoal = data.vbxi_station_in(find(data.resp_subline_change & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial > trial, 1, 'first')); if isempty(subgoal), subgoal = nan; end; end
    data.resp_station_subgoal = jb_applyvector(@find_subgoal,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    
    % subelbow
    function subelbow = find_subelbow(subject,session,block,trial), subelbow = data.vbxi_station_in(find(data.vbxi_elbow_in & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial > trial, 1, 'first')); if isempty(subelbow), subelbow = nan; end; end
    data.resp_station_subelbow = jb_applyvector(@find_subelbow,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    
    % boundary
    function boundary = find_boundary(subject,session,block,trial), boundary = data.vbxi_station_in(find((data.resp_subline_change|data.vbxi_elbow_in) & data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial > trial, 1, 'first')); if isempty(boundary), boundary = data.vbxi_station_goal(data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial == trial); end; end
    data.resp_station_boundary = jb_applyvector(@find_boundary,data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);
    
    %% distance
    % station
    data.resp_dist_station_end = jb_applyvector( ...
        @(subject,session,block,trial) sum(data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial >= trial),  ... function
        data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);                                                                                ... categories
    data.resp_dist_station_journey = jb_applyvector( ...
        @(subject,session,block,trial) sum(data.expt_subject == subject & data.expt_session == session & data.expt_block == block), ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                     ... categories
    
    % subline
    data.resp_dist_subline_start = jb_applyvector( ...
        @(subject,session,block,trial) length(unique(data.vbxi_subline_in(data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial <= trial)))-1,   ... function
        data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);                                                                                                                    ... categories
    data.resp_dist_subline_end = jb_applyvector( ...
        @(subject,session,block,trial) length(unique(data.vbxi_subline_in(data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial >= trial)))-1,   ... function
        data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);                                                                                                                    ... categories
    data.resp_dist_subline_journey = jb_applyvector( ...
        @(subject,session,block,trial) length(unique(data.vbxi_subline_in(data.expt_subject == subject & data.expt_session == session & data.expt_block == block)))-1,  ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                                                         ... categories
        
    % goaldist
    data.resp_goaldist_station_to = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).dists.steptimes_stations(data.resp_station_to(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial),data.vbxi_station_goal(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial))),   ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    data.resp_goaldist_station_diff = data.resp_goaldist_station_to - data.optm_dist_station_goal;
    
    %% correct
    data.resp_correct = (data.resp_goaldist_station_diff < 0);
    
    %% position
    data.resp_xposition_to = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.resp_station_to(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(1)),   ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    data.resp_yposition_to = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.resp_station_to(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(2)),   ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    
    %% away
    data.resp_away     = (data.resp_goaldist_station_diff > 0);
    function away = func_away_any(subject,session,block)
        away = any(data.resp_away(data.expt_subject == subject & data.expt_session == session & data.expt_block == block));
    end
    data.resp_away_any = jb_applyvector(@func_away_any, data.expt_subject, data.expt_session, data.expt_block);
    
    %% goal
    data.resp_goal = (data.resp_goaldist_station_to == 0);
    function goal = find_goal(subject,session,block), goal = any(data.resp_goal(data.expt_subject == subject & data.expt_session == session & data.expt_block == block)); end
    data.resp_goal_any = jb_applyvector(@find_goal,data.expt_subject, data.expt_session, data.expt_block);
    
end