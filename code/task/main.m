%{
    notes.
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
quiz_create;
enum_create;

%% TASK
try
    % initialise psychtoolbox
    ptb_start;
    % show introduction screen
    ptb_screen_intro;
    
    %% BLOCK
    set_task;
    while ~end_of_task
        % new block
        set_block;
        % modes
        set_mode;
        % restart map
        map_reset;
        % block screen
        ptb_screen_block;
        
        %% TRIAL
        while (~end_of_task) && (~end_of_block)
            % new trial
            set_trial;
            while ~end_of_trial
                % trial screen
                ptb_screen_trial;
                % get response
                ptb_resp_kb;
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
        clear i_trial end_of_trial end_of_block options_enabled options_sublines options_stations options_dists options_symbols options_thicks options_sizes nb_options;
        
        % block screen
        ptb_screen_blockend;
        
        %% ENUM or QUIZ
        % enum
        set_enum;
        % quiz
        set_quiz;
        
        % end of task
        set_endoftask;
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