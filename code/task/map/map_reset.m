

%% set values, reset map
% start, goal station
[tmp_startstation,tmp_goalstation] = tools_setstations(map.dists.exchanges_sublines,parameters,participant,ptb,i_block,j_trial,0);
map.avatar.start_station = tmp_startstation;
map.avatar.to_station    = tmp_goalstation;

% start subline
tmp_sublines = unique(map.links(map.avatar.start_station,:));
tmp_sublines(~tmp_sublines) = [];
map.avatar.start_subline = tmp_sublines(randi(length(tmp_sublines)));

% in station, subline
map.avatar.in_station = map.avatar.start_station;
map.avatar.in_subline = map.avatar.start_subline;

% time
map.avatar.time = 0;

% reward
if parameters.flag_showreward
    if rand > parameters.reward_prop
        map.avatar.reward = parameters.reward_high;
    else
        map.avatar.reward = parameters.reward_low;
    end
else
    map.avatar.reward = nan;
end

%% clean
clear tmp_startstations tmp_goalstations tmp_sublines;
