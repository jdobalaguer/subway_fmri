
%% set session
switch parameters.session
    
    % training 1
    case 'training_1'
        tmp_message = 'First training';
        tmp_mode = {'arrows','colour','avalines','map','pics','quiz','exchange','disabled','taskrand'};
        parameters.run_by_min = 1;
        parameters.run_min = 45;
        
    % training 2
    case 'training_2'
        tmp_message = 'Second training';
        tmp_mode = {'samemap','bailout','reward','time','break','blank','jitter','taskoneorone'};
        parameters.run_by_min = 1;
        parameters.run_min = 60;
        
    % scanner
    case 'scanner'
        tmp_message = 'Scanner session';
        tmp_mode = {'samemap','bailout','reward','time','break','blank','jitter','scanner','taskoneorone'};
        parameters.run_by_min = 1;
        parameters.run_min = 60;
        
    % debug
    case 'debug'
        tmp_message = 'Debug session';
        tmp_mode = {'arrows','colour','avalines','map','pics','quiz','exchange','disabled','taskrand'};
        parameters.run_by_blocks = 1;
        parameters.run_blocks = 5;
        
    % error
    otherwise
        error(['set_session: error. session "',parameters.session,'" doesn''t exist']);
end


%% set start
tmp_startsession = isempty(parameters.mode) || ~isequal(parameters.mode,tmp_mode);

if tmp_startsession
    % screen
    Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
    Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
    Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
    Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);
    Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
    DrawFormattedText(ptb.screen_w,tmp_message,'center','center');
    Screen(ptb.screen_w,'Flip');
    ptb_resp_click;

    % mail
    if parameters.flag_mail
        tools_alertmail([participant.name,' starts the "',parameters.session,'" session']);
    end
end


%% set modes
parameters.mode = tmp_mode;

%% set break and quiz and enum triggers
% break
parameters.break_min   = parameters.break_rmin   * parameters.run_min;
parameters.break_blocks= parameters.break_rblocks* parameters.run_blocks;
parameters.break_trials= parameters.break_rtrials* parameters.run_trials;

% quiz
parameters.quiz_min    = parameters.quiz_rmin    * parameters.run_min;
parameters.quiz_blocks = parameters.quiz_rblocks * parameters.run_blocks;
parameters.quiz_trials = parameters.quiz_rtrials * parameters.run_trials;

% enum
parameters.enum_min    = parameters.enum_rmin    * parameters.run_min;
parameters.enum_blocks = parameters.enum_rblocks * parameters.run_blocks;
parameters.enum_trials = parameters.enum_rtrials * parameters.run_trials;


%% clean
clear tmp_message tmp_mode tmp_startsession;
