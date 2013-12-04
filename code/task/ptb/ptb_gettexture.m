
function texture = ptb_gettexture(ptb,name)
    
    texture = nan;
    for i_texture = 1:length(ptb.texture_id)
        if strcmp(name,ptb.texture_name{i_texture})
            texture = ptb.texture_id{i_texture};
            break;
        end
    end
    
end