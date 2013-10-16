if ~parameters.debug_subject; return; end

% exp
quiz.exp_sub(end+1)   = participant.id;
quiz.exp_map(end+1)   = map.id;
quiz.exp_block(end+1) = i_block;
quiz.exp_quiz(end+1)  = i_quiz;
quiz.exp_trial(end+1) = i_trial;

% response
quiz.resp_bool(end+1)       = resp.bool;
quiz.resp_keycode(end+1)    = resp.code;
quiz.resp_gs(end+1)         = resp.gs;
quiz.resp_rt(end+1)         = resp.rt;
quiz.resp_option(end+1)     = resp.option;
quiz.resp_nboptions(end+1)  = sum(options_sublines>0);
quiz.resp_optionssublines(:,end+1)  = options_sublines;
quiz.resp_optionsstations(:,end+1)  = options_stations;
quiz.resp_optionsdists(:,end+1)     = options_dists;
quiz.resp_subline(end+1)    = resp.subline;
quiz.resp_station(end+1)    = resp.station;
quiz.resp_steptime(end+1)   = resp.steptime;
quiz.resp_dist(end+1)       = resp.dist;
quiz.resp_cor(end+1)        = resp.cor;

% avatar
quiz.avatar_goalstation(end+1)    = map.avatar.to_station;
quiz.avatar_instation(end+1)      = map.avatar.in_station;
quiz.avatar_insubline(end+1)      = map.avatar.in_subline;
quiz.avatar_inexchange(end+1)     = (length(unique(map.links(map.avatar.in_station,:))) > 3); %0,ford,back
quiz.avatar_toexchange(end+1)     = (length(unique(map.links(map.avatar.to_station,:))) > 3); %0,ford,back

% dists
quiz.dists_steptimes_stations(end+1) = map.dists.steptimes_stations(map.avatar.to_station,map.avatar.in_station);
quiz.dists_steptimes_sublines(end+1) = map.dists.steptimes_sublines(map.avatar.to_station,map.avatar.in_station);
quiz.dists_exchanges_stations(end+1) = map.dists.exchanges_stations(map.avatar.to_station,map.avatar.in_station);
quiz.dists_exchanges_sublines(end+1) = map.dists.exchanges_sublines(map.avatar.to_station,map.avatar.in_station);
quiz.dists_euclidean(end+1)          = map.dists.euclidean(map.avatar.to_station,map.avatar.in_station);

% time
quiz.time_trial(end+1)    = ptb.screen_time_this;
