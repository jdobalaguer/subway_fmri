
function map = map_setelbow(map)
    
    for i_station = 1:map.nb_stations
        
        % exchange, no elbow
        if map.stations(i_station).exchange
            map.stations(i_station).ending = 0;
            map.stations(i_station).elbow = 0;
        % straight, no elbow
        else
            tmp_s = find(map.links(i_station,:));
            if length(tmp_s)==1
                map.stations(i_station).ending = 1;
                map.stations(i_station).elbow  = 0;
            else
                tmp_v = map.stations(tmp_s(1)).position + map.stations(tmp_s(2)).position - 2*map.stations(i_station).position;
                if any(tmp_v)
                    map.stations(i_station).ending = 0;
                    map.stations(i_station).elbow = 1;
                else
                    map.stations(i_station).ending = 0;
                    map.stations(i_station).elbow = 0;
                end
            end
        end
            
    end
end
