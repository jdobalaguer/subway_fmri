% create pitch array
i_ymax = round(ptb.audio_duration*ptb.audio_sampling);
y = sin(linspace(0,ptb.audio_duration*ptb.audio_freqlow,i_ymax));

% start the audioport
PsychPortAudio('FillBuffer',ptb.audio_port,y);
PsychPortAudio('Start',ptb.audio_port);
