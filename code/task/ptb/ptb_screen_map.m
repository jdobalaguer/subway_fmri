if ~parameters.flag_showmap; return; end

%% Clean screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_blackcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

%% Show map
map_view;

%% Flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');

time.screens{end+1}  = 'map show';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

ptb.screen_time_this = tmp_stimulusonset;
ptb.screen_time_next = tmp_stimulusonset + parameters.time_map;

%% Click
ptb_resp_kbmap;

%% Clean screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');

time.screens{end+1}  = 'map clean';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

ptb.screen_time_this = tmp_stimulusonset;
ptb.screen_time_next = tmp_stimulusonset;

%% Release
ptb_release;


%% Clean
clear tmp_vbltimestamp tmp_stimulusonset;
