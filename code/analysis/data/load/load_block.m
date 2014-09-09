
function block = load_block(path)
    if ~exist('path','var'); path = 'scanner'; end
    data = load_data_rnm(path);
    maps = load_maps(path);
    time = load_time(path);
    block = struct();
    
    %% warnings
    %#ok<*MATCH3>
    
    %% experiment
    
    % index
    expt = unique([data.expt_subject',data.expt_session',data.expt_block'],'rows');
    block.('expt_subject')  = expt(:,1)';
    block.('expt_session')  = expt(:,2)';
    block.('expt_block')    = expt(:,3)';
    
    % trigger
    block.('expt_trigger')  = jb_applyvector(@(subject,session,block) unique(data.expt_trigger(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    %% independent variables
    
    % time
    block.('vbxi_getsecs_cue')      = jb_applyvector(@(subject)(time(subject).getsecs(strmatch('block',time(subject).screens,'exact'))),block.expt_subject);
    block.('vbxi_onset_cue')        = (block.vbxi_getsecs_cue - block.expt_trigger);
    block.('vbxi_scans_cue')        = (block.vbxi_onset_cue ./ 2);
    block.('vbxi_getsecs_reward')   = jb_applyvector(@(subject) [(time(subject).getsecs(strmatch('rew',time(subject).screens,'exact'))),repmat(nan,sum(block.expt_subject==subject)-length((time(subject).getsecs(strmatch('rew',time(subject).screens,'exact')))))],block.expt_subject);
    block.('vbxi_onset_reward')     = (block.vbxi_getsecs_reward - block.expt_trigger);
    block.('vbxi_scans_reward')     = (block.vbxi_onset_reward ./ 2);
    
    % trial
    block.('vbxi_reward')           = jb_applyvector(@(subject,session,block) unique(data.vbxi_reward(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('vbxi_stop')             = jb_applyvector(@(subject,session,block) unique(data.vbxi_stop(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    % station
    block.('vbxi_station_start')    = jb_applyvector(@(subject,session,block) unique(data.vbxi_station_start(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('vbxi_station_goal')     = jb_applyvector(@(subject,session,block) unique(data.vbxi_station_goal(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    % subline
    block.('vbxi_subline_start')    = jb_applyvector(@(subject,session,block) unique(data.vbxi_subline_start(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('vbxi_subline_goal')     = jb_applyvector(@(subject,session,block) unique(data.vbxi_subline_goal(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    %% optimal behaviour
    
    % distance
    block.('optm_dist_station_journey') = jb_applyvector(@(subject,session,block) unique(data.optm_dist_station_journey(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('optm_dist_subline_journey') = jb_applyvector(@(subject,session,block) unique(data.optm_dist_subline_journey(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('optm_dist_euclide_journey') = jb_applyvector(@(subject,session,block) unique(data.optm_dist_euclide_journey(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    %% response
    
    % trial
    block.('resp_bool_all') = jb_applyvector(@(subject,session,block) all(data.resp_bool(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('resp_correct_all') = jb_applyvector(@(subject,session,block) all(data.resp_correct(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('resp_stop') = jb_applyvector(@(subject,session,block) ~any(data.resp_station_to(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)==data.vbxi_station_goal(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('resp_goal') = (~block.resp_stop);
    
    % station
    block.('resp_station_same_any') = jb_applyvector(@(subject,session,block) any(data.resp_station_same(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    % exchange
    block.('resp_exchange_in_any') = jb_applyvector(@(subject,session,block) any(data.vbxi_exchange_in(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    % elbow
    block.('resp_elbow_in_any') = jb_applyvector(@(subject,session,block) any(data.vbxi_elbow_in(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    % subline
    block.('resp_subline_change_any') = jb_applyvector(@(subject,session,block) any(data.resp_subline_change(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    % distance
    block.('resp_dist_station_journey') = jb_applyvector(@(subject,session,block) unique(data.resp_dist_station_journey(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('resp_dist_subline_journey') = jb_applyvector(@(subject,session,block) unique(data.resp_dist_subline_journey(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    % direction
    block.('resp_direction_back_any') = jb_applyvector(@(subject,session,block) any(data.resp_direction_back(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    block.('resp_direction_switch_any') = jb_applyvector(@(subject,session,block) any(data.resp_direction_switch(data.expt_subject==subject & data.expt_session==session & data.expt_block==block)),...
        block.expt_subject,block.expt_session,block.expt_block);
    
    %% independant variables (dependent on optimal behaviour)
    
    % easy / hard
    block.('vbxi_easy') = (block.optm_dist_subline_journey == 1);
    block.('vbxi_hard') = (block.optm_dist_subline_journey >  1);
    
    %% optimal behaviour (dependent on response)
    
    % distance
    block.('optm_dist_station_left') = jb_applyvector(@(subject,session,block) maps(subject).dists.steptimes_stations(data.resp_station_to(find(data.expt_subject==subject & data.expt_session==session & data.expt_block==block,1,'last')),data.vbxi_station_goal(find(data.expt_subject==subject & data.expt_session==session & data.expt_block==block,1,'last'))), ...
        block.expt_subject,block.expt_session,block.expt_block);
    
    block.('optm_dist_subline_left') = jb_applyvector(@(subject,session,block) maps(subject).dists.exchanges_sublines(data.resp_station_to(find(data.expt_subject==subject & data.expt_session==session & data.expt_block==block,1,'last')),data.vbxi_station_goal(find(data.expt_subject==subject & data.expt_session==session & data.expt_block==block,1,'last'))), ...
        block.expt_subject,block.expt_session,block.expt_block);
    
    block.('optm_dist_euclide_left') = jb_applyvector(@(subject,session,block) maps(subject).dists.euclidean(         data.resp_station_to(find(data.expt_subject==subject & data.expt_session==session & data.expt_block==block,1,'last')),data.vbxi_station_goal(find(data.expt_subject==subject & data.expt_session==session & data.expt_block==block,1,'last'))), ...
        block.expt_subject,block.expt_session,block.expt_block);
    
    %% sort
    block = struct_sort(block);
    
end
