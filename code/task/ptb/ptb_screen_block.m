if ~parameters.debug_subject; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% Screen
if i_block == 1
    DrawFormattedText(ptb.screen_w,['Your first meeting is at ',map.stations(map.avatar.to_station).name,' Station'],'center',ptb.screen_center(2) - 50);
else
    if data.resp_station(end) == data.avatar_goalstation(end)
        DrawFormattedText(ptb.screen_w,['Your next meeting is at ',map.stations(map.avatar.to_station).name,' Station'],'center',ptb.screen_center(2) - 50);
        DrawFormattedText(ptb.screen_w,'Take some time to rest if you need it','center',ptb.screen_center(2) + 50);
    else
        DrawFormattedText(ptb.screen_w,['«Sorry, I had to go! Could we meet at ',map.stations(map.avatar.to_station).name,' Station instead?»'],'center',ptb.screen_center(2) - 50);
    end
end

% Flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');
ptb.screen_time_this = tmp_stimulusonset;
ptb.screen_time_next = tmp_stimulusonset;

% Click
ptb_resp_click;

% Clean
clear tmp_vbltimestamp tmp_stimulusonset;