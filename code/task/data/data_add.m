if ~parameters.debug_subject; return; end

% exp
data.exp_sub(end+1)     = participant.id;
data.exp_map(end+1)     = map.id;
data.exp_session(end+1) = parameters.session;
data.exp_mode(end+1)    = parameters.mode;
data.exp_block(end+1)   = i_block;
data.exp_trial(end+1)   = i_trial;
data.exp_jtrial(end+1)  = j_trial;
data.exp_starttrial(end+1) = (i_trial==1);
data.exp_stoptrial(end+1) = end_of_block;

% flag
data.flag_audio(end+1)         = parameters.flag_audio;
data.flag_arrowsizes(end+1)    = parameters.flag_arrowsizes;
data.flag_arrowthicks(end+1)   = parameters.flag_arrowthicks;
data.flag_blackandwhite(end+1) = parameters.flag_blackandwhite;
data.flag_disabledchanges(end+1) = parameters.flag_disabledchanges;
data.flag_forward(end+1)       = parameters.flag_forward;
data.flag_mail(end+1)          = parameters.flag_mail;
data.flag_optionscross(end+1)  = parameters.flag_optionscross;
data.flag_quiz(end+1)          = parameters.flag_quiz;
data.flag_randomize(end+1)     = parameters.flag_randomize;
data.flag_showreward(end+1)    = parameters.flag_showreward;
data.flag_showsublines(end+1)  = parameters.flag_showsublines;
data.flag_stopprob(end+1)      = parameters.flag_stopprob;
data.flag_timechange(end+1)    = parameters.flag_timechange;
data.flag_timelimit(end+1)     = parameters.flag_timelimit;

% response
data.resp_bool(end+1)       = resp.bool;
data.resp_keycode(end+1)    = resp.code;
data.resp_gs(end+1)         = resp.gs;
data.resp_rt(end+1)         = resp.rt;
data.resp_option(end+1)     = resp.option;
data.resp_nboptions(end+1)  = sum(options_sublines>0);
data.resp_optionssublines(:,end+1)  = options_sublines;
data.resp_optionsstations(:,end+1)  = options_stations;
data.resp_optionsdists(:,end+1)     = options_dists;
data.resp_subline(end+1)    = resp.subline;
data.resp_station(end+1)    = resp.station;
data.resp_steptime(end+1)   = resp.steptime;
data.resp_dist(end+1)       = resp.dist;
data.resp_cor(end+1)        = resp.cor;
data.resp_maptime(end+1)    = resp.maptime;

% avatar
data.avatar_startstation(end+1)   = map.avatar.start_station;
data.avatar_startsubline(end+1)   = map.avatar.start_subline;
data.avatar_goalstation(end+1)    = map.avatar.to_station;
data.avatar_instation(end+1)      = map.avatar.in_station;
data.avatar_insubline(end+1)      = map.avatar.in_subline;
data.avatar_inexchange(end+1)     = (length(unique(map.links(map.avatar.in_station,:))) > 3); %0,ford,back
data.avatar_toexchange(end+1)     = (length(unique(map.links(map.avatar.to_station,:))) > 3); %0,ford,back
data.avatar_time(end+1)           = map.avatar.time;
data.avatar_reward(end+1)         = map.avatar.reward;
data.avatar_stopprob(end+1)       = stop_prob;

% dists
data.dists_steptimes_stations(end+1) = map.dists.steptimes_stations(map.avatar.to_station,map.avatar.in_station);
data.dists_steptimes_sublines(end+1) = map.dists.steptimes_sublines(map.avatar.to_station,map.avatar.in_station);
data.dists_exchanges_stations(end+1) = map.dists.exchanges_stations(map.avatar.to_station,map.avatar.in_station);
data.dists_exchanges_sublines(end+1) = map.dists.exchanges_sublines(map.avatar.to_station,map.avatar.in_station);
data.dists_euclidean(end+1)          = map.dists.euclidean(map.avatar.to_station,map.avatar.in_station);

% time
data.time_trial(end+1)    = ptb.screen_time_this;
