if ~parameters.debug_subject; return; end
if end_of_task; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% Screen
ny = 100;   DrawFormattedText(ptb.screen_w,'Hello and thanks for your collaboration!','center',ny);
ny = 250;
ny = ny+50; DrawFormattedText(ptb.screen_w,'You have a meeting and you are running late.'                               ,'center',ny);
ny = ny+50; DrawFormattedText(ptb.screen_w,'You need to plan how to get to the meeting as quickly as possible.'         ,'center',ny);
ny = ny+50; DrawFormattedText(ptb.screen_w,'To do that, you are going to take the subway.'                              ,'center',ny);
ny = ny+50; DrawFormattedText(ptb.screen_w,'At each step, you can move forward or you can switch to another line.'      ,'center',ny);
ny = 600;   DrawFormattedText(ptb.screen_w,'Good luck!'                                                                 ,'center',ny);

% Flip
Screen(ptb.screen_w,'Flip');
ptb_resp_click;

% clean
clear ny;
