if ~parameters.debug_subject; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% Screen
DrawFormattedText(ptb.screen_w,'Yeehaw! Quiz time!!','center','center');

% Flip
Screen(ptb.screen_w,'Flip');
ptb_resp_click;
