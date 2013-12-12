%{
    notes.
    things to do:   fix enum. it is not working anymore.
%}

clc;

%% SET
set_parameters;
set_preload;
set_participant;


%% CREATE
data_create;
time_create;

%% TASK
set_task;
try
    % initialise psychtoolbox
    ptb_start;
    
    %% SET INITIAL MODE
    set_session;
    set_mode;

    %% MAP
    % load
    map_load;
    % resize
    map_resize;
    
    %% SAVE
    data_save;
    
    %% BLOCK
    while ~end_of_task
        % set break
        set_break;
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
            % add data
            data_add;
            % set changes
            map_change;
            % blank screen
            ptb_screen_blank;
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
        
        %% SAVE
        data_save;
    end
    
    % show end screen
    ptb_screen_lottery;
    ptb_screen_end;
    
    % save
    data_save;
        
    % close psychtoolbox
    ptb_stop;
    
    % clean
    clear i_block j_trial i_quiz i_break end_of_task ans;
    
catch err
    % close psychtoolbox
    ptb_stop;
    
    % save data
    data_error;
    
    % rethrow error
    rethrow(err);
end