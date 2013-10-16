if ~parameters.debug_subject; return; end
if end_of_task; return; end


switch parameters.session
    % session 1 -----------------------------------------------------------
    case 1
        % apriori: we're always reaching the goal!
        
        % check
        if parameters.mode ~= 1
            error('ptb_screen_blockend: fix this. session 1 multimode?');
        end
        if parameters.flag_showreward
            error('ptb_screen_blockend: fix this. why rewards here?');
        end        
        
        % in station
        tmp_sublines = 2*unique(ceil(.5*map.links(:,map.avatar.to_station)));
        tmp_sublines(~tmp_sublines) = [];
        tmp_nb       = length(tmp_sublines);
        tmp_color    = nan(tmp_nb,3);
        for i_sublines = 1:tmp_nb
            tmp_color(i_sublines,:) = map.sublines(tmp_sublines(i_sublines)).color;
        end
        parameters.screen_instation.stationstr = [map.stations(map.avatar.in_station).name,' Station'];
        if ~(map.avatar.time-map.dists.steptimes_stations(map.avatar.to_station,map.avatar.start_station))
            parameters.screen_instation.labelstr = ['Perfect!  You got there in ',num2str(map.avatar.time),' steps (the quickest).'];
        else
            parameters.screen_instation.labelstr = ['Well done!  You got there in ',num2str(map.avatar.time),' steps.  The quickest route was in ',num2str(map.dists.steptimes_stations(map.avatar.to_station,map.avatar.start_station)),' steps.'];
        end
        ptb_screen_station(ptb,parameters.screen_instation,tmp_color);
        
    % session 2 -----------------------------------------------------------
    case 2
        % goal reached
        if  (map.avatar.in_station == map.avatar.to_station)
            % in station
            tmp_sublines = 2*unique(ceil(.5*map.links(:,map.avatar.to_station)));
            tmp_sublines(~tmp_sublines) = [];
            tmp_nb       = length(tmp_sublines);
            tmp_color    = nan(tmp_nb,3);
            for i_sublines = 1:tmp_nb
                tmp_color(i_sublines,:) = map.sublines(tmp_sublines(i_sublines)).color;
            end
            parameters.screen_instation.stationstr = [map.stations(map.avatar.in_station).name,' Station'];
            if parameters.flag_showreward
                % show reward
                if map.rewards(i_block)==1  parameters.screen_instation.labelstr = ['Good! You''ve won ',num2str(map.rewards(i_block)),' coin'];
                else                        parameters.screen_instation.labelstr = ['Good! You''ve won ',num2str(map.rewards(i_block)),' coins'];
                end
            else
                parameters.screen_instation.labelstr = ' ';
            end
            ptb_screen_station(ptb,parameters.screen_instation,tmp_color);
        % no left time
        elseif parameters.flag_stopprob
            DrawFormattedText(ptb.screen_w,'�Phone Call�','center',ptb.screen_center(2));
        else
            fprintf('ptb_screen_blockend: error. end_of_block = 1\n');
            fprintf('ptb_screen_blockend: error. end_of_task  = 0\n');
            fprintf('ptb_screen_blockend: error. flag_stopptob = 0\n');
            fprintf('ptb_screen_blockend: error. goal not reached\n');
            error('how did that happen?');
        end
end

% flip
Screen(ptb.screen_w,'Flip',ptb.screen_time_next);

% click
ptb_resp_click;

% clean
clear tmp_sublines tmp_nb tmp_color;
