
% not response
if ~resp.bool
    % ~forward
    if ~parameters.flag_forward
        % clean
        clear to_station;
        clear resp;
        clear optnb_trials stop_prob;
        return;
    end
    
    % forward
    to_station = find(map.avatar.in_subline==map.links(map.avatar.in_station,:));
    if isempty(to_station)
        % clean
        clear to_station;
        clear resp;
        clear optnb_trials stop_prob;
        return;
    end
    resp.station = to_station;
    resp.subline = map.avatar.in_subline;
end

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
