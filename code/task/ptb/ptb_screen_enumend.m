if ~parameters.debug_subject; return; end
if end_of_task; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% Screen
tmp_ok    = nansum(enum.resp_cor(enum.exp_enum==i_enum));
tmp_total = sum(~isnan(enum.resp_cor));
DrawFormattedText(ptb.screen_w,['You''ve done ',num2str(tmp_ok),' correct answers out of ',num2str(tmp_total),'!'],'center','center');

% Flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');

time.screens{end+1}  = 'enum end';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

% Click
ptb_resp_click;

% Clean
clear tmp_ok tmp_total;
clear tmp_vbltimestamp tmp_stimulusonset;
