
function maps = fix_map_face(maps)

    for i_maps = 1:length(maps)
        for i_stations = 1:length(maps(i_maps).stations)
            name = maps(i_maps).stations(i_stations).name;
            face  = any(strcmp(name,map_getfaces()));
            place = any(strcmp(name,map_getplaces()));
            assert(xor(face,place), 'fix_map_face: error.');
            maps(i_maps).stations(i_stations).face = face;
        end
    end

end