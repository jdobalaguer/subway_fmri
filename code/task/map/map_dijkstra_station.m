% function implementing the dijkstra algorithm (used by the computer interface to move inside the map)

%{
modified from http://www.mathworks.com/matlabcentral/fileexchange/5550-dijkstra-shortest-path-routing

% inputs ------------------------------------------------------------------
map     = fmri version map
i_block = block number

% outputs -----------------------------------------------------------------
path_mainstation = the list of main stations in the path from source to destination
path_mainsubline = the list of main sublines in the path from source to destination
time_cost = timing for travelling the path

% variables ---------------------------------------------------------------
is_station = source node index
it_station = target node index
%}

% dijkstra algorithm for a main map ---------------------------------------
function [path_station,path_subline,time_cost,distances_station,distances_subline] = map_dijkstra_station(map,is_station)
    
    it_station = 1;
    
    % declarations
    n = length(map.stations);
    visited(1:n) = 0;
    distances_station(1:n) = inf;
    distances_station(is_station) = 0;
    distances_subline(1:n) = inf;
    distances_subline(is_station) = 0;
    parent_station(1:n) = 0;
    parent_subline(1:n) = 0;
    
    % n-1 nodes visited at most
    for i = 1:(n-1),
        % find the nearest node to the source not visited yet
        temp = zeros(1,n);
        for h = 1:n
            if visited(h) == 0
                temp(h) = distances_station(h);
            else
                temp(h) = inf;
            end
        end
        [t, u] = min(temp);
        % update distance for each node if found a better path is found
        % update parent to that node needed for this shortest path
        visited(u) = 1;
        for v = 1:n
            % look for neighbout stations
            uv_neighbours = find(map.links(u,v));
            % calculate the cost for each possible subline
            if uv_neighbours
                in_subline = map.links(u,v);
                cost_station = map.sublines(in_subline).time;
                cost_subline = (parent_subline(u)~=in_subline);
            else
                % if no possible main sublines, infinite cost
                cost_station = Inf;
                cost_subline = Inf;
            end

            % update values
            if cost_station + distances_station(u) < distances_station(v)
                distances_station(v) = distances_station(u) + cost_station;
                distances_subline(v) = distances_subline(u) + cost_subline;
                parent_station(v) = u;
                parent_subline(v) = in_subline;
            end
        end
    end
    
    % deduce the path (if exists) and its average time cost
    path_subline = [];
    path_station = it_station;
    time_cost = distances_station(it_station);
    if parent_station(it_station) ~= 0
        ii_station = it_station;
        % until you find the source main station
        while ii_station ~= is_station
            path_station = [parent_station(ii_station) path_station];
            path_subline = [parent_subline(ii_station) path_subline];
            ii_station = parent_station(ii_station);
            %todo: increase time
        end
    end
    
    % inverse paths
    path_station = fliplr(path_station);
    path_subline = fliplr(path_subline);
end