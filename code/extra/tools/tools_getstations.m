function [stations,names] = tools_getstations(map,i_subline)
    
    % find start
    for i_station = 1:map.nb_stations
        if ...
                any(map.links(i_station,:)==i_subline) ... % departure
                && ...
                ~ any(map.links(:,i_station)==i_subline)   % ~arrival
            break;
        end
    end
    
    % find all other stations
    stations = [];
    names = {};
    while ~isempty(i_station)
        stations(end+1) = i_station;
        names{end+1} = map.stations(i_station).name;
        i_station = find(map.links(i_station,:)==i_subline);
    end
end