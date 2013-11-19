if ~parameters.debug_subject; return; end
if end_of_task; return; end

%% show reward
if parameters.flag_showreward && parameters.flag_stopprob
    % show reward
    if (map.avatar.in_station ~= map.avatar.to_station)
        DrawFormattedText(ptb.screen_w,'Phone Call','center','center');
        parameters.screen_instation.labelstr = ['You''ve lost ',num2str(map.avatar.reward),' coin(s)'];
    elseif map.avatar.reward==1
        parameters.screen_instation.labelstr = ['Good! You''ve won ',num2str(map.avatar.reward),' coin'];
    else
        parameters.screen_instation.labelstr = ['Good! You''ve won ',num2str(map.avatar.reward),' coins'];
    end
%% show number of steps
else
    % if minimum time
    if map.avatar.time == map.dists.steptimes_stations(map.avatar.to_station,map.avatar.start_station)
        parameters.screen_instation.labelstr = ['Perfect!  You got there in ',num2str(map.avatar.time),' steps (the quickest).'];
    % if longuer
    else
        parameters.screen_instation.labelstr = ['Well done!  You got there in ',num2str(map.avatar.time),' steps.  The quickest route was in ',num2str(map.dists.steptimes_stations(map.avatar.to_station,map.avatar.start_station)),' steps.'];
    end
end
    
%% show screen_instation
tmp_sublines = 2*unique(ceil(.5*map.links(:,map.avatar.to_station)));
tmp_sublines(~tmp_sublines) = [];
tmp_nb       = length(tmp_sublines);
tmp_color    = nan(tmp_nb,3);
for i_sublines = 1:tmp_nb
    tmp_color(i_sublines,:) = map.sublines(tmp_sublines(i_sublines)).color;
end
parameters.screen_instation.stationstr = [map.stations(map.avatar.in_station).name,' Station'];
ptb_screen_station(ptb,parameters.screen_instation,tmp_color);
    
%% flip
Screen(ptb.screen_w,'Flip',ptb.screen_time_next);

%% click
ptb_resp_click;

%% clean
clear tmp_sublines tmp_nb tmp_color;
