
%% default mode
%   no colour
%   no map
%   no exchange
%   no bail out
%   no reward
%   no scanner
parameters.flag_blackandwhite   = 1;
parameters.flag_showmap         = 0;
parameters.flag_quiz            = 0;
parameters.flag_enum            = 0;
parameters.flag_disabledchanges = 0;
parameters.flag_showdisabled    = 0;
parameters.flag_stopprob        = 0;
parameters.flag_showreward      = 0;
parameters.flag_jittering       = 0;
parameters.flag_scanner         = 0;


%% set modes
for i_mode = 1:length(parameters.mode)
    switch parameters.mode{i_mode}
        % colour
        case 'colour'
            parameters.flag_blackandwhite = 0;
        case 'nocolour'
            parameters.flag_blackandwhite = 1;
            
        % map
        case 'map'
            parameters.flag_showmap = 1;
        case 'nomap'
            parameters.flag_showmap = 0;
            
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
            
        % error
        otherwise
            error(['set_mode: error. mode "',parameters.mode,'" doesn''t exist']);
    end
end

%% clean
clear i_mode;