
set_parameters;

%% STRUCTURE

% stations
id = 0;
id = id+1; stations(id) = map_createstation(id,'Amsterdam');
id = id+1; stations(id) = map_createstation(id,'Athens');
id = id+1; stations(id) = map_createstation(id,'Berlin');
id = id+1; stations(id) = map_createstation(id,'Brussels');
id = id+1; stations(id) = map_createstation(id,'Budapest');
%{
id = id+1; stations(id) = map_createstation(id,'Copenhaguen');
id = id+1; stations(id) = map_createstation(id,'Dublin');
id = id+1; stations(id) = map_createstation(id,'Helsinky');
id = id+1; stations(id) = map_createstation(id,'Lisbon');
id = id+1; stations(id) = map_createstation(id,'London');
id = id+1; stations(id) = map_createstation(id,'Luxembourg');
id = id+1; stations(id) = map_createstation(id,'Madrid');
id = id+1; stations(id) = map_createstation(id,'Moscow');
id = id+1; stations(id) = map_createstation(id,'Oslo');
id = id+1; stations(id) = map_createstation(id,'Paris');
id = id+1; stations(id) = map_createstation(id,'Prague');
id = id+1; stations(id) = map_createstation(id,'Reykjavik');
id = id+1; stations(id) = map_createstation(id,'Rome');
id = id+1; stations(id) = map_createstation(id,'Stockholm');
id = id+1; stations(id) = map_createstation(id,'San Marino');
%}

% sublines
id = 0;
id = id+1; sublines(id) = map_createsubline(id,4,[255,128,128],1);
id = id+1; sublines(id) = map_createsubline(id,5,[255,128,128],1);
id = id+1; sublines(id) = map_createsubline(id,4,[128,255,128],1);
id = id+1; sublines(id) = map_createsubline(id,5,[128,255,128],1);
id = id+1; sublines(id) = map_createsubline(id,4,[128,128,225],1);
id = id+1; sublines(id) = map_createsubline(id,5,[128,128,225],1);

% numbers
nb_stations = length(stations);
nb_sublines = length(sublines);

% links (randomly)
links = zeros(nb_stations,nb_stations);
for i_links = 1:30
    % set a subline (randomly)
    i_subline = 1:2:nb_sublines;
    i_subline = i_subline(randperm(length(i_subline)));
    i_subline = i_subline(1);
    % two diff stations
    i_station1 = randi(nb_stations);
    i_station2 = i_station1;
    while i_station1==i_station2
        i_station2 = randi(nb_stations);
    end
    % link stations
    links(i_station1,i_station2) = i_subline;
    links(i_station2,i_station1) = i_subline + 1;
end
for i_station = 1:nb_stations
    links(i_station,i_station) = 0;
end

%% SEQUENCES

% sequences [start,goal,line]
seqs = [randi(nb_stations,parameters.run_blocks,2),nan(parameters.run_blocks,1)];
for i_block = 1:parameters.run_blocks
    
    % diff start/goal
    while seqs(i_block,1)==seqs(i_block,2)
        seqs(i_block,[1,2]) = randi(nb_stations,1,2);
    end
    
    % set line (randomly)
    tmp_f = links(seqs(i_block,1),:);
    tmp_f(~tmp_f) = [];
    tmp_f = tmp_f(randperm(length(tmp_f)));
    seqs(i_block,3) = tmp_f(1);
end

%% AVATAR

avatar = struct();
avatar.in_station = nan;
avatar.in_subline = nan;

%% CLEAN

% struct
map = struct();
map.nb_stations = nb_stations;
map.nb_sublines = nb_sublines;
map.stations  = stations;
map.sublines  = sublines;
map.links     = links;
map.seqs      = seqs;
map.avatar    = avatar;

% save
save('map.mat','map');

% clean
clear i_links i_subline i_station1 i_station2 i_station;
clear i_block tmp_f;
clear id nb_stations nb_sublines;
clear stations sublines links seqs avatar;
clear parameters;
clear map;

