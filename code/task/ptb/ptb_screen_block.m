if ~parameters.debug_subject; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% get a random goal subline
tmp_tosubline = unique(map.links(map.avatar.to_station,:));
tmp_tosubline(~tmp_tosubline) = [];
tmp_tosubline = tmp_tosubline(randi(length(tmp_tosubline)));

%% block screen
% screen
if i_block == 1
    DrawFormattedText(ptb.screen_w,'Your first meeting is at ',                             'center',ptb.screen_center(2) - 150,  parameters.screen_fontcolor);
    DrawFormattedText(ptb.screen_w,[map.stations(map.avatar.to_station).name,' Station'],   'center',ptb.screen_center(2) - 100,  map.sublines(tmp_tosubline).color);
    DrawFormattedText(ptb.screen_w,'Departure from ',                                       'center',ptb.screen_center(2) + 0,    parameters.screen_fontcolor);
    DrawFormattedText(ptb.screen_w,[map.stations(map.avatar.in_station).name,' Station'],   'center',ptb.screen_center(2) + 50,   map.sublines(map.avatar.in_subline).color);
else
    DrawFormattedText(ptb.screen_w,'Your next meeting is at ',                              'center',ptb.screen_center(2) - 150,  parameters.screen_fontcolor);
    DrawFormattedText(ptb.screen_w,[map.stations(map.avatar.to_station).name,' Station'],   'center',ptb.screen_center(2) - 100,  map.sublines(tmp_tosubline).color);
    DrawFormattedText(ptb.screen_w,'Departure from ',                                       'center',ptb.screen_center(2) + 0,    parameters.screen_fontcolor);
    DrawFormattedText(ptb.screen_w,[map.stations(map.avatar.in_station).name,' Station'],   'center',ptb.screen_center(2) + 50,   map.sublines(map.avatar.in_subline).color);
end
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_block;
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1}  = 'block';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

%% blank screen
% screen
Screen(ptb.screen_w, 'FillRect', ptb.screen_bg_color);
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_blockpre + parameters.time_blockprejit*(2*rand()-1);
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1} = 'block pre';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

%% clean
clear tmp_tosubline;
clear tmp_vbltimestamp tmp_stimulusonset;
