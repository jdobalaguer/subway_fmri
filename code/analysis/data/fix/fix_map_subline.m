
function maps = fix_map_subline(maps)

    for i_maps = 1:length(maps)
        maps(i_maps).nb_sublines = maps(i_maps).nb_sublines ./ 2;
        maps(i_maps).sublines(2:2:end) = [];
        maps(i_maps).links = floor((maps(i_maps).links + 1) ./ 2);
    end

end