if ~parameters.debug_subject; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% Screen
DrawFormattedText(ptb.screen_w,'You are done! Thank you for your participation.','center','center');

% Flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');

time.screens{end+1}  = 'end text';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

% Mail
if parameters.flag_mail
    tools_alertmail([participant.name,' has finished']);
end

% Response
ptb_resp_click;

% Clean screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');

time.screens{end+1}  = 'end blank';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

% Response
parameters.resp_buttonbox = 0;
ptb_resp_click;

% Clean
clear tmp_vbltimestamp tmp_stimulusonset;
