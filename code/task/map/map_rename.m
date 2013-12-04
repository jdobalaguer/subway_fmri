function map = map_rename(map)
    
    % get lists
    faces_names = map_getfaces();
    places_names = map_getplaces();
    
    % shuffle
    faces_names  = tools_shuffle(faces_names);
    places_names = tools_shuffle(places_names);
    
    % set list
    ii_faces = 1:round(.5*map.nb_stations);
    ii_places = 1:(map.nb_stations-length(ii_faces));
    stations_names = [faces_names(ii_faces),places_names(ii_places)];
    
    % shuffle
    stations_names = tools_shuffle(stations_names);
    
    % apply
    for i_stations = 1:map.nb_stations
        map.stations(i_stations).name = stations_names{i_stations};
    end
    
end