if ~parameters.debug_subject; return; end
if end_of_task; return; end

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

%% quiz end
% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
tmp_ok    = sum((quiz.exp_quiz==i_quiz) & quiz.resp_cor);
tmp_total = sum( quiz.exp_quiz==i_quiz );
DrawFormattedText(ptb.screen_w,['You''ve done ',num2str(tmp_ok),' correct answers out of ',num2str(tmp_total),'!'],'center','center');
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_quizend;
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1}  = 'quiz end';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

%% blank screen
% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_quizpos;
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1}  = 'quiz pos';
time.getsecs(end+1)  = tmp_stimulusonset;
time.breakgs(end+1)  = time.breakgs(end);

%% Clean
clear tmp_ok tmp_total;
clear tmp_vbltimestamp tmp_stimulusonset;
