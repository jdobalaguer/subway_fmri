function dists = map_dists(map)
    
    % dists struct
    dists = struct();
    dists.steptimes_stations = nan(map.nb_stations,map.nb_stations);
    dists.steptimes_sublines = nan(map.nb_stations,map.nb_stations);
    dists.exchanges_stations = nan(map.nb_stations,map.nb_stations);
    dists.exchanges_sublines = nan(map.nb_stations,map.nb_stations);
    dists.euclidean          = nan(map.nb_stations,map.nb_stations);
    
    % calculate dists
    for i_station = 1:map.nb_stations
        %fprintf('map_dists: block number %d\n',i_block);
        
        % timesteps (minimise time)
        [pt,pl,t,dt,dl] = map_dijkstra_station(map,i_station);
        dists.steptimes_stations(i_station,:) = dt;
        dists.steptimes_sublines(i_station,:) = dl;
        
        % exchanges (minimise changing sublines)
        [pt,pl,t,dt,dl] = map_dijkstra_subline(map,i_station);
        dists.exchanges_stations(i_station,:) = dt;
        dists.exchanges_sublines(i_station,:) = dl;
        
        % euclidean
        t_pos = map.stations(i_station).position;
        for j_station = 1:map.nb_stations
            s_pos = map.stations(j_station).position;
            dists.euclidean(i_station,j_station) = norm(s_pos-t_pos);
        end
    end
end