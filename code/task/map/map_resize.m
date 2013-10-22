if ~exist('map','var'); return; end
if ~parameters.flag_showmap; return; end

% get positions
stations_positions = nan(0,2);
for i_station = 1:map.nb_stations
    stations_positions(end+1,:) = map.stations(i_station).position;
end

% get frames
map_minpos = min(stations_positions);
map_maxpos = max(stations_positions);
map_center = .5 * (map_minpos + map_maxpos);

screen_minpos = ptb.screen_center - .5*parameters.map_size;
screen_maxpos = ptb.screen_center + .5*parameters.map_size;
screen_center = ptb.screen_center;

% get transformation
transf_a  = (screen_maxpos-screen_minpos)./(map_maxpos-map_minpos);
transf_b  = screen_center;
transf_x0 = map_center;

% set screen coordinates
for i_station = 1:map.nb_stations
    transf_x = map.stations(i_station).position;
    transf_y = transf_a.*(transf_x - transf_x0) + transf_b;
    map.stations(i_station).screen = round(transf_y);
end

% clean
clear i_station;
clear stations_positions;
clear map_minpos map_maxpos map_center;
clear screen_minpos screen_maxpos screen_center;
clear transf_a transf_b transf_x transf_x0 transf_y;
