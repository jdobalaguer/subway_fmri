if ~parameters.debug_subject; return; end

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

%% quiz start
% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
DrawFormattedText(ptb.screen_w,'Yeehaw! Quiz time!!','center','center');
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_quizstart;
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1}  = 'quiz start';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

%% blank screen
% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_quizpre;
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1}  = 'quiz pre';
time.getsecs(end+1)  = tmp_stimulusonset;
time.breakgs(end+1)  = time.breakgs(end);

%% clean
clear tmp_vbltimestamp tmp_stimulusonset;
