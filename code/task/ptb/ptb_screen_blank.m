if ~parameters.flag_blank || ~parameters.time_blank; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
ptb.screen_time_next = tmp_stimulusonset + parameters.time_blank;

time.screens{end+1}  = 'blank';
time.getsecs(end+1)  = tmp_stimulusonset;
time.breakgs(end+1)  = time.breakgs(end);

%% Clean
clear tmp_vbltimestamp tmp_stimulusonset;
