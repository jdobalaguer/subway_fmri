if ~parameters.debug_subject; return; end
if end_of_task; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% Screen
tmp_ok    = sum((quiz.exp_quiz==i_quiz) & quiz.resp_cor);
tmp_total = sum( quiz.exp_quiz==i_quiz );
DrawFormattedText(ptb.screen_w,['You''ve done ',num2str(tmp_ok),' correct answers out of ',num2str(tmp_total),'!'],'center','center');

% Flip
Screen(ptb.screen_w,'Flip');
ptb_resp_click;

% Clean
clear tmp_ok tmp_total;