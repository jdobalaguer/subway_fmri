
function data = fix_data_subline(data)

    data.avatar_insubline       = floor((data.avatar_insubline      + 1) ./ 2);
    data.avatar_startsubline    = floor((data.avatar_startsubline   + 1) ./ 2);
    data.resp_subline           = floor((data.resp_subline          + 1) ./ 2);
    data.resp_optionssublines   = floor((data.resp_optionssublines  + 1) ./ 2);
    
end