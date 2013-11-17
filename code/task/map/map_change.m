if end_of_task; return; end

% change station
map.avatar.in_station = resp.station;

% change subline
map.avatar.in_subline = resp.subline;

% time
map.avatar.time = map.avatar.time + map.sublines(resp.subline).time;

% clean
clear to_station;
clear resp;
clear optnb_trials stop_prob;
