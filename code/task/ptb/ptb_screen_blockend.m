if ~parameters.debug_subject; return; end
if end_of_task; return; end

%% reward screen
% screen (reward)
if parameters.flag_showreward && parameters.flag_stopprob
    % show reward
    if (map.avatar.in_station ~= map.avatar.to_station)
        DrawFormattedText(ptb.screen_w,'Sorry! Bad luck.','center','center');
    elseif map.avatar.reward==1
        DrawFormattedText(ptb.screen_w,['Good! You''ve won ',num2str(map.avatar.reward),' coin'],'center','center');
    else
        DrawFormattedText(ptb.screen_w,['Good! You''ve won ',num2str(map.avatar.reward),' coins'],'center','center');
    end
    
% screen(number of steps)
else
    % if minimum time
    if map.avatar.time == map.dists.steptimes_stations(map.avatar.to_station,map.avatar.start_station)
        parameters.screen_instation.labelstr = ['Perfect!  You got there in ',num2str(map.avatar.time),' steps (the quickest).'];
    % if longuer
    else
        parameters.screen_instation.labelstr = ['Well done!  You got there in ',num2str(map.avatar.time),' steps.  The quickest route was in ',num2str(map.dists.steptimes_stations(map.avatar.to_station,map.avatar.start_station)),' steps.'];
    end
    
    % show screen_instation
    tmp_sublines = 2*unique(ceil(.5*map.links(:,map.avatar.to_station)));
    tmp_sublines(~tmp_sublines) = [];
    tmp_nb       = length(tmp_sublines);
    tmp_color    = nan(tmp_nb,3);
    for i_sublines = 1:tmp_nb
        tmp_color(i_sublines,:) = map.sublines(tmp_sublines(i_sublines)).color;
    end
    parameters.screen_instation.stationstr = [map.stations(map.avatar.in_station).name,' Station'];
    ptb_screen_station(ptb,parameters.screen_instation,tmp_color);
end
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_rew + parameters.time_rewjit*(2*rand()-1);
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1}  = 'rew';
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

%% blank screen
% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
% flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
ptb.screen_time_this = tmp_stimulusonset;
if parameters.flag_timize
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_blockpos + parameters.time_blockposjit*(2*rand()-1);
else
    ptb.screen_time_next = tmp_stimulusonset;
    ptb_resp_click;
end
% time
time.screens{end+1}  = 'block pos';
time.getsecs(end+1)  = tmp_stimulusonset;
time.breakgs(end+1)  = time.breakgs(end);

%% clean
clear tmp_sublines tmp_nb tmp_color;
clear tmp_vbltimestamp tmp_stimulusonset;
