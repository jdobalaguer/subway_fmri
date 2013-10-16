
%% Time
if ~isfield(ptb,'time_stop')
    ptb.time_stop = GetSecs;
else
    ptb.time_stop(end+1) = GetSecs;
end

%% Screen

% mouse
ShowCursor;

% remove anything pressed during the experiment?
FlushEvents;

% window
Screen('CloseAll');

%% Audio

% stop sound
if parameters.flag_audio
    PsychPortAudio('Close', ptb.audio_port);
    ptb.audio_port = [];
end