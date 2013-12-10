if end_of_task; return; end

%% default mode
parameters.flag_arrowthicks     = 0;
parameters.flag_arrowsizes      = 0;
parameters.flag_mapload         = 0;
parameters.flag_blackandwhite   = 1;
parameters.flag_avatarlines     = 0;
parameters.flag_showmap         = 0;
parameters.flag_showpics        = 0;
parameters.flag_quiz            = 0;
parameters.flag_enum            = 0;
parameters.flag_disabledchanges = 0;
parameters.flag_showdisabled    = 0;
parameters.flag_stopprob        = 0;
parameters.flag_showreward      = 0;
parameters.flag_timelimit       = 0;
parameters.flag_timize          = 0;
parameters.flag_break           = 0;
parameters.flag_blank           = 0;
parameters.flag_jittering       = 0;
parameters.flag_scanner         = 0;
parameters.resp_buttonbox       = 0;


%% set modes
for i_mode = 1:length(parameters.mode)
    switch parameters.mode{i_mode}
        % arrows thicker/bigger
        case 'arrows'
            parameters.flag_arrowthicks = 1;
            parameters.flag_arrowsizes  = 1;
        case 'noarrows'
            parameters.flag_arrowthicks = 0;
            parameters.flag_arrowsizes  = 0;
        
        % same map
        case 'samemap'
            parameters.flag_mapload = 1;
        case 'nosamemap'
            parameters.flag_mapload = 0;
            
        % colour
        case 'colour'
            parameters.flag_blackandwhite = 0;
        case 'nocolour'
            parameters.flag_blackandwhite = 1;
            
        % avalines
        case 'avalines'
            parameters.flag_avatarlines = 1;
        case 'noavalines'
            parameters.flag_avatarlines = 0;
            
        % map
        case 'map'
            parameters.flag_showmap = 1;
        case 'nomap'
            parameters.flag_showmap = 0;
            
        % map
        case 'pics'
            parameters.flag_showpics = 1;
        case 'nopics'
            parameters.flag_showpics = 0;
            
        % quiz
        case 'quiz'
            parameters.flag_quiz = 1;
        case 'noquiz'
            parameters.flag_quiz = 0;
            
        % enum
        case 'enum'
            parameters.flag_enum = 1;
        case 'noenum'
            parameters.flag_enum = 0;
            
        % exchange
        case 'exchange'
            parameters.flag_disabledchanges = 1;
        case 'noexchange'
            parameters.flag_disabledchanges = 0;
            
        % disabled
        case 'disabled'
            parameters.flag_showdisabled    = 1;
        case 'nodisabled'
            parameters.flag_showdisabled    = 0;
            
        % bail out
        case 'bailout'
            parameters.flag_stopprob   = 1;
        case 'nobailout'
            parameters.flag_stopprob   = 0;
            
        % reward
        case 'reward'
            parameters.flag_showreward = 1;
        case 'noreward'
            parameters.flag_showreward = 0;
            
        % time
        case 'time'
            parameters.flag_timelimit = 1;
        case 'notime'
            parameters.flag_timelimit = 0;
            
        % timize
        case 'timize'
            parameters.flag_timize = 1;
        case 'notimize'
            parameters.flag_timize = 0;
            
        % break
        case 'break'
            parameters.flag_break = 1;
        case 'nobreak'
            parameters.flag_break = 0;
            
        % blank
        case 'blank'
            parameters.flag_blank = 1;
        case 'noblank'
            parameters.flag_blank = 0;
            
        % jitter
        case 'jitter'
            parameters.flag_jittering = 1;
        case 'nojitter'
            parameters.flag_jittering = 0;
            
        % scanner
        case 'scanner'
            parameters.flag_scanner = 1;
        case 'noscanner'
            parameters.flag_scanner = 0;
        
        % button box
        case 'buttonbox'
            parameters.resp_buttonbox = 1;
        case 'nobuttonbox'
            parameters.resp_buttonbox = 0;
            
        % one or one
        case 'taskrand'
            parameters.flag_tasksel = 'rand';
        case 'taskoneorone'
            parameters.flag_tasksel = 'oneorone';
            
        % error
        otherwise
            error(['set_mode: error. mode "',parameters.mode{i_mode},'" doesn''t exist']);
    end
end

%% clean
clear i_mode;
