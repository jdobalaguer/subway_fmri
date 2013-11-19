%{
    notes.

    things to do:   set bailing out
    things to do:   enum is not working anymore.
%}

clc;

%% SET
set_parameters;
set_preload;
set_participant;

%% LOAD
map_load;

%% CREATE
data_create;

%% TASK
set_task;
try
    % initialise psychtoolbox
    ptb_start;
    % resize map
    map_resize;
    % show introduction screen
    ptb_screen_intro;
    
    %% SET INITIAL MODE
    set_session;
    set_mode;
    % scanner connection
    set_scanner;

    %% BLOCK
    while ~end_of_task
        % new block
        set_block;
        % change modes
        set_session;
        set_mode;
        % restart map
        map_reset;
        % block screen
        ptb_screen_block;
        
        %% TRIAL
        % show map
        ptb_screen_map;
        % trial loop
        while (~end_of_task) && (~end_of_block)
            % new trial
            set_trial;
            while ~end_of_trial
                % trial screen
                ptb_screen_trial;
                % get response
                ptb_resp_kbtrial;
                % wait for exchange
                ptb_screen_wait;
            end
            % limit_time screen
            ptb_screen_trial;
            % end of block
            set_endofblock;
            % save data
            data_add;
            data_save;
            % set changes
            map_change;
        end
        
        % clean
        clear i_trial end_of_trial end_of_block options_enabled options_sublines options_stations options_dists options_symbols options_thicks options_sizes nb_options tmp_maptime;
        
        % block screen
        ptb_screen_blockend;
        
        %% ENUM or QUIZ
        % enum
        set_enum;
        % quiz
        set_quiz;
        
        % end of task
        set_endoftask;
        
        % clean
        clear i_trial end_of_trial end_of_block options_enabled options_sublines options_stations options_dists options_symbols options_thicks options_sizes nb_options tmp_maptime;
    end
    
    % show end screen
    ptb_screen_lottery;
    ptb_screen_end;
    
    % close psychtoolbox
    ptb_stop;
    
    % clean
    clear i_block j_trial i_quiz end_of_task ans;
    
catch err
    % close psychtoolbox
    ptb_stop;
    
    % save data
    data_error;
    
    % rethrow error
    rethrow(err);
end