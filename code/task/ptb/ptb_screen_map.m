if end_of_task; return; end
if ~parameters.flag_showmap; return; end

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.map_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_blackcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

%% Map screen
% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
map_view;
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
ptb.screen_time_next = tmp_stimulusonset + parameters.time_map;
% time
time.screens{end+1}  = 'map show';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);
% click
ptb_resp_kbmap;

%% Blank screen
% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');
ptb.screen_time_this = tmp_stimulusonset;
ptb.screen_time_next = tmp_stimulusonset;
% time
time.screens{end+1}  = 'map clean';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

%% Release
ptb_release;

%% Clean
clear tmp_vbltimestamp tmp_stimulusonset;
