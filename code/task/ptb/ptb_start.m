ptb = struct();

%% Preferences
% verbosity
Screen('Preference', 'Verbosity',0);
Screen('Preference', 'SuppressAllWarnings', 1);
% skip tests
if parameters.debug_subject     Screen('Preference', 'SkipSyncTests', 1);
else                            Screen('Preference', 'SkipSyncTests', 2);
end

%% Time
if ~isfield(ptb,'time_start')
    ptb.time_start = GetSecs;
else
    ptb.time_start(end+1) = GetSecs;
end

%% Screen
% list screens
ptb.screen_ii = Screen('Screens');
ptb.screen_i = ptb.screen_ii(end);
% open window
if isfield(parameters,'screen_rect') && ~isempty(parameters.screen_rect)
    [tmp_w, tmp_r] = Screen('OpenWindow', ptb.screen_i, 0,parameters.screen_rect,32,2);
else
    [tmp_w, tmp_r] = Screen('OpenWindow', ptb.screen_i, 0,[],32,2);
end

% values
ptb.screen_w = tmp_w;
ptb.screen_rect = tmp_r;
ptb.screen_drect = [(ptb.screen_rect(3)-ptb.screen_rect(1)) , (ptb.screen_rect(4)-ptb.screen_rect(2))];
ptb.screen_center = [ptb.screen_rect(1) , ptb.screen_rect(2)] + .5*ptb.screen_drect;
ptb.screen_bg_color = parameters.screen_bg_color;
ptb.screen_time_this = GetSecs();
ptb.screen_time_next = GetSecs();

% textures
Screen('Preference', 'TextAlphaBlending', 1);
Screen(ptb.screen_w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% mouse
HideCursor;

%% Audio

if parameters.flag_audio
    % set parameters
    ptb.audio_freqlow  = 2500;
    ptb.audio_freqhigh = 7500;
    ptb.audio_duration  = 0.1;

    % initialise port
    PsychPortAudio('Verbosity',0);
    InitializePsychSound;
    try
        ptb.audio_port = PsychPortAudio('Open', [], [], 1, [], 1);
    catch
        psychlasterror('reset');
        ptb.audio_port = PsychPortAudio('Open', [], [], 1, [], 1);
    end
    tmp_s = PsychPortAudio('GetStatus',ptb.audio_port);
    ptb.audio_sampling = tmp_s.SampleRate;
end

%% Gamepad

Gamepad('Unplug');
ptb.gamepad_i = Gamepad('GetNumGamepads');
ptb.gamepad_name = '';
ptb.gamepad_nbbuttons = 0;
if ptb.gamepad_i>0
    ptb.gamepad_name      = Gamepad('GetGamepadNamesFromIndices',ptb.gamepad_i);
    ptb.gamepad_nbbuttons = Gamepad('GetNumButtons',ptb.gamepad_i);
end

%% Keyboard

% select the right keyboard
ptb.kb_ii = GetKeyboardIndices();
ptb.kb_i  = ptb.kb_ii(end);
% unify names
KbName('UnifyKeyNames');

%% Textures
[ptb.texture_name,ptb.texture_id] = ptb_maketextures(ptb.screen_w,parameters.screen_picture.alpha);

%% Clean
clear ptb_ConfigPath ptb_RootPath;
clear tmp_w tmp_r tmp_s;
