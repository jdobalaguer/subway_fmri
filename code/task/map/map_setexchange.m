
function map = map_setexchange(map)
    
    for i_station = 1:map.nb_stations
        
        if length(unique(map.links(i_station,:))) > 3
            map.stations(i_station).exchange = 1;
        else
            map.stations(i_station).exchange = 0;
        end
            
    end
end
