function blockdata = results_blockdata(map,data)
    
    %% initialise
    % number of blocks
    nb_blocks = max(data.exp_block);
    
    % struct
    blockdata = struct();
    % id
    blockdata.exp_sub(1:nb_blocks) = nan;
    blockdata.exp_map(1:nb_blocks) = unique(data.exp_map);
    blockdata.exp_block            = 1:nb_blocks;
    % performance: absolute values
    blockdata.abs_human_stations = nan(1,nb_blocks);
    blockdata.abs_human_times    = nan(1,nb_blocks);
    blockdata.abs_human_sublines = nan(1,nb_blocks);
    blockdata.abs_time_stations  = nan(1,nb_blocks);
    blockdata.abs_time_sublines  = nan(1,nb_blocks);
    blockdata.abs_exch_stations  = nan(1,nb_blocks);
    blockdata.abs_exch_sublines  = nan(1,nb_blocks);
    
    % distances
    steptimes_stations = nan(nb_blocks,map.nb_stations);
    steptimes_sublines = nan(nb_blocks,map.nb_stations);
    exchanges_stations = nan(nb_blocks,map.nb_stations);
    exchanges_sublines = nan(nb_blocks,map.nb_stations);
    euclidean          = nan(nb_blocks,map.nb_stations);
    
    for i_block = 1:nb_blocks
        ii_block = (data.exp_block == i_block);
        fi_block = find(ii_block);
        
        start_station = unique(data.avatar_startstation(ii_block));
        goal_station  = unique(data.avatar_goalstation(ii_block));
        if length(start_station)~=1 || length(goal_station)~=1
            error('multiple or no start/goal stations');
        end
        
        %% classics
        blockdata.avatar_startstation(i_block) = start_station;
        blockdata.avatar_goalstation(i_block) = goal_station;
        if any(isnan(data.avatar_reward(ii_block)));    blockdata.avatar_reward(i_block) = nan;
        else                                            blockdata.avatar_reward(i_block) = unique(data.avatar_reward(ii_block));
        end
        if isnan(data.resp_dist(fi_block(end)));        blockdata.avatar_achieved(i_block) = 0;
        else                                            blockdata.avatar_achieved(i_block) = ~data.resp_dist(fi_block(end));
        end
        
        %% dijkstra distance maps
        % distances: timesteps (minimise time)
        [pt,pl,t,dt,dl] = map_dijkstra_station(map,goal_station);
        steptimes_stations(i_block,:) = dt;
        steptimes_sublines(i_block,:) = dl;
        % distances: exchanges (minimise changing sublines)
        [pt,pl,t,dt,dl] = map_dijkstra_subline(map,goal_station);
        exchanges_stations(i_block,:) = dt;
        exchanges_sublines(i_block,:) = dl;
        % distances: euclidean
        t_pos = map.stations(goal_station).position;
        for i_station = 1:map.nb_stations
            s_pos = map.stations(i_station).position;
            euclidean(i_block,i_station) = norm(s_pos-t_pos);
        end
        
        %% distances
        % human stations
        blockdata.human_stations(i_block) = sum(ii_block);
        % human times
        blockdata.human_times(i_block)    = sum(data.resp_steptime(ii_block));
        % human sublines
        blockdata.human_sublines(i_block) = 1 + sum( (data.resp_subline(fi_block(2:end)) - data.resp_subline(fi_block(1:end-1))) ~= 0);
        % time stations
        blockdata.time_stations(i_block)  = steptimes_stations(i_block,start_station);
        % time sublines
        blockdata.time_sublines(i_block)  = steptimes_sublines(i_block,start_station);
        % exch stations
        blockdata.exch_stations(i_block)  = exchanges_stations(i_block,start_station);
        % exch sublines
        blockdata.exch_sublines(i_block)  = exchanges_sublines(i_block,start_station);
        
    end
    
    %% human/dijkstra ratios
    blockdata.rel_time_stations = blockdata.human_stations ./ blockdata.time_stations;
    blockdata.rel_time_sublines = blockdata.human_sublines ./ blockdata.time_sublines;
    blockdata.rel_exch_stations = blockdata.human_stations ./ blockdata.exch_stations;
    blockdata.rel_exch_sublines = blockdata.human_sublines ./ blockdata.exch_sublines;
end
