
function tools_showmap(map)
    try
        % set variables
        set_parameters;
        time_create;
        ptb_start;
        end_of_task = 0;
        parameters.flag_showmap = 1;
        parameters.time_map = Inf;
        
        % show map
        ptb_screen_map;
        
        % close
        ptb_stop;
        
    catch err
        % close
        ptb_stop;
        
        % error
        rethrow(err);
    end
end