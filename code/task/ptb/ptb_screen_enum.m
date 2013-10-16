
% select possible stations
i_next = i_trial - 1 + randperm(length(tmp_stations) - i_trial + 1);
tmp_laststations = tmp_stations(1:i_trial-1);
tmp_nextstations = tmp_stations(i_next);
tmp_lastnames = tmp_names(1:i_trial-1);
tmp_nextnames = tmp_names(i_next);

% resp struct (used in ptb_screen_trial)
resp = struct();

%% draw
% remove station name
parameters.screen_instation.stationstr = '                    ';
% draw
ptb_screen_trial;

%% response
ptb_resp_enum;
% escape
if end_of_task; return; end

%% feedback
% feedback
parameters.screen_instation.stationstr = [map.stations(map.avatar.in_station).name,' Station'];
% draw
ptb_screen_trial;
% click
ptb_resp_click;
