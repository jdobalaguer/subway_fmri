
%% draw sublines
tmp_links       = map.links;
tmp_fromstation = (1:size(tmp_links,1))' * ones(1,size(tmp_links,1));
tmp_tostation   = ones(size(tmp_links,1),1) * (1:size(tmp_links,1));
for i_link = 1:numel(tmp_links)
    i_subline = tmp_links(i_link);
    if i_subline
        % get link
        tmp_from      = map.stations(tmp_fromstation(i_link)).screen;
        tmp_to        = map.stations(tmp_tostation(i_link)).screen;
        tmp_subline   = i_subline;
        tmp_color     = map.sublines(tmp_subline).color;
        tmp_dir       = tmp_to-tmp_from;
        tmp_ang       = atan2(tmp_dir(2),tmp_dir(1));
        % draw link
        tmp_ang1  = tmp_ang - .5*pi;
        tmp_ang2  = tmp_ang + .5*pi;
        tmp_from1 = tmp_from + parameters.map_thick*[cos(tmp_ang1),sin(tmp_ang1)];
        tmp_from2 = tmp_from + parameters.map_thick*[cos(tmp_ang2),sin(tmp_ang2)];
        tmp_to1   = tmp_to   + parameters.map_thick*[cos(tmp_ang1),sin(tmp_ang1)];
        tmp_to2   = tmp_to   + parameters.map_thick*[cos(tmp_ang2),sin(tmp_ang2)];
        % draw
        Screen('FillPoly',ptb.screen_w,round(map.sublines(i_subline).color),round([tmp_from1;tmp_to1;tmp_to2;tmp_from2]));
    end
end

%% draw stations
for i_station = 1:map.nb_stations
    tmp_rectmin = map.stations(i_station).screen - 2*parameters.map_thick;
    tmp_rectmax = map.stations(i_station).screen + 2*parameters.map_thick;
    tmp_rect = [tmp_rectmin,tmp_rectmax];
    Screen('FillOval', ptb.screen_w, 0, round(tmp_rect));
    tmp_rectmin = map.stations(i_station).screen - 1.5*parameters.map_thick;
    tmp_rectmax = map.stations(i_station).screen + 1.5*parameters.map_thick;
    tmp_rect = [tmp_rectmin,tmp_rectmax];
    Screen('FillOval', ptb.screen_w, 255, round(tmp_rect));
end

%% draw names
for i_station = 1:map.nb_stations
    tmp_name    = map.stations(i_station).name;
    tmp_statpos = map.stations(i_station).screen;
    tmp_txtrect = Screen('TextBounds',ptb.screen_w,tmp_name);
    tmp_txtpos  = tmp_statpos - .5*tmp_txtrect([3,4]) + [0,-25];
    DrawFormattedText(ptb.screen_w,tmp_name,tmp_txtpos(1),tmp_txtpos(2));
end

%% clean
clear i_link i_subline i_station;
clear tmp_links tmp_fromstation tmp_tostation;
clear tmp_from tmp_from1 tmp_from2;
clear tmp_to tmp_to1 tmp_to2;
clear tmp_ang tmp_ang1 tmp_ang2;
clear tmp_subline tmp_color tmp_dir;
clear tmp_rect tmp_rectmin tmp_rectmax;
clear tmp_name tmp_statpos tmp_txtrect tmp_txtpos;
