function map = allo_translate(allo)
    
    % stations dictionnary
    station_names = {   ...
        'Ali',...
        'Armstrong',...
        'Aristotle',...
        'Astaire',...
        'Austen',...
        'Ball',...
        'Banks',...
        'Beethoven',...
        'Bell',...
        'Beyonce',...
        'Brown',...
        'Bush',...
        'Carrey',...
        'Carrol',...
        'Charles',...
        'Cleopatra',...
        'Clinton',...
        'Columbus',...
        'Connery',...
        'Cosby',...
        'Cruise',...
        'Vinci',...
        'Vader',...
        'Dean',...
        'Diana',...
        'Dickens',...
        'Disney',...
        'Dylan',...
        'Eastwood',...
        'Edison',...
        'Einstein',...
        'Eisenhower',...
        'Ford',...
        'Fox',...
        'Franklin',...
        'Freud',...
        'Gandhi',...
        'Gates',...
        'Goldberg',...
        'Hawking',...
        'Hemingway',...
        'Hitchcock',...
        'Hope',...
        'Houdini',...
        'Jackson',...
        'Jagger',...
        'Jefferson',...
        'Johnson',...
        'Jordan',...
        'Keller',...
        'Kennedy',...
        'Lennon',...
        'Letterman',...
        'Lewis',...
        'Lincoln',...
        'King',...
        'Madonna',...
        'Martin',...
        'McCartney',...
        'Michelangelo',...
        'Monroe',...
        'Mozart',...
        'Murphy',...
        'Napoleon',...
        'Newman',...
        'Newton',...
        'Nicholson',...
        'Onasis',...
        'Pasteur',...
        'Pele',...
        'Piccaso',...
        'Plato',...
        'Poe',...
        'Presley',...
        'Putin',...
        'Reagan',...
        'Roberts',...
        'Sagan',...
        'Seuss',...
        'Shakespeare',...
        'Spears',...
        'Streep',...
        'Taylor',...
        'Teresa',...
        'Thatcher',...
        'Timberlake',...
        'Travolta',...
        'Twain',...
        'Washington',...
        'Williams',...
        'Winfrey',...
        'West',...
        'Wright' ...
    };
	
    station_names = station_names(randperm(length(station_names)));
    
	% map struct
    map = struct;
    
    % id
    map.id = allo.id;
    
    % nb_stations
    map.nb_stations = length(allo.main_stations);
    
    % nb_sublines
    map.nb_sublines = length(allo.main_sublines);
    
    % stations
    fprintf('allo_translate: stations\n');
    map.stations = map_createstation(nan,'',[nan,nan]);
    for i_stations = 1:map.nb_stations
        map.stations(i_stations) = map_createstation(   i_stations, ...
                                                        station_names{i_stations}, ...
                                                        allo.main_stations(i_stations).draw_position ...
                                                    );
    end
    
    % sublines
    fprintf('allo_translate: sublines\n');
    map.sublines = map_createsubline(nan,[0,0,0],nan);
    for i_sublines = 1:map.nb_sublines
        map.sublines(i_sublines) = map_createsubline(   ...
            i_sublines,...                                      % id
            allo.main_sublines(i_sublines).draw_color,...       % color
            1 ...                                               % time
                                                    );
    end
    
    % links
    fprintf('allo_translate: links\n');
    map.links = zeros(map.nb_stations,map.nb_stations);
    for i_sublines = 1:map.nb_sublines
        stops = allo.main_sublines(i_sublines).main_stations;
        for i_stops = 1:(length(stops)-1)
            map.links(stops(i_stops),stops(i_stops+1)) = i_sublines;
        end
    end
    
    % dists
    fprintf('allo_translate: distances\n');
    map.dists = map_dists(map);
    
    % avatar
    fprintf('allo_translate: avatar\n');
    map.avatar = struct();
    map.avatar.start_station = nan;
    map.avatar.start_subline = nan;
    map.avatar.in_station = nan;
    map.avatar.in_subline = nan;
    map.avatar.to_station = nan;
    map.avatar.time = nan;
    map.avatar.reward = nan;
end