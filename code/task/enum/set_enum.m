if ~parameters.flag_enum; return; end
if end_of_task; return; end

do_enum = 1;

%% ENUM TIME?
% minutes counter
if parameters.run_by_min
    gs = GetSecs - ptb.time_start;
    gm = gs/60;
    if i_enum > length(parameters.enum_min) || parameters.enum_min(i_enum) > gm
        do_enum = 0;
    end
end    
% block counter
if parameters.run_by_blocks
    if i_enum > length(parameters.enum_blocks) || parameters.enum_blocks(i_enum) > i_block
        do_enum = 0;
    end
end
% trial counter
if parameters.run_by_trials
    if i_enum > length(parameters.enum_trials) || parameters.enum_trials(i_enum) > j_trial
        do_enum = 0;
    end
end

if do_enum
    %% INTRO
    % intro screen
    ptb_screen_enumintro;
    
    % set lines
    tmp_sublines = randperm(map.nb_sublines);
    tmp_sublines(parameters.enum_nbsublines+1:end) = [];
    
    %% ENUM
    for i_subline = tmp_sublines
        % set stations
        [tmp_stations,tmp_names] = tools_getstations(map,i_subline);
        tmp_askstations = [0,((randperm(length(tmp_stations)-2) <= parameters.enum_nbstations)),0];
        
        % for stations
        for i_trial = 1:length(tmp_stations)
            end_of_trial = 0;
            % set this/previous stations
            map.avatar.in_station   = tmp_stations(i_trial);
            map.avatar.in_subline   = i_subline;
            map.avatar.to_station = tmp_stations(length(tmp_stations));
            
            % ask
            if tmp_askstations(i_trial)
                % show mouse
                ShowCursor;
                % draw list and labels
                ptb_screen_enum;
                % hide mouse
                HideCursor;
            % don't ask
            else
                % show station
                ptb_screen_trial;
                % null response
                ptb_resp_enum;
            end
            
            % escape
            if end_of_task; return; end
            
            % save enum
            enum_add;
            data_save;
        end
    end
    
    % end screen
    ptb_screen_enumend;
    
    % increment index
    i_enum = i_enum + 1;
end

% clean
clear gs gm;
clear do_enum;
