if end_of_task
    clear to_station;
    clear resp;
    return;
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
