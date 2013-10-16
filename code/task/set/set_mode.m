
switch parameters.session
    
    %% Session 1
    case 1
        %% Exploration
        if parameters.mode ~= 1
            parameters.mode = 1;

            % mail
            if parameters.flag_mail
                tools_alertmail([participant.name,' starts the exploration mode']);
            end

            % flags
            parameters.flag_blackandwhite = 0;
            parameters.flag_showreward = 0;
            parameters.flag_stopprob   = 0;
            parameters.flag_disabledchanges = 1;

            % screen
            Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
            Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
            Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
            Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
            Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);
            DrawFormattedText(ptb.screen_w,'Exploration phase :)','center','center');
            Screen(ptb.screen_w,'Flip');
            ptb_resp_click;
        end
        
    %% Session 2
    case 2
        %% Warm-up
        if parameters.mode ~=1 && j_trial >= 0 && j_trial < .1*parameters.run_trials
            parameters.mode = 1;

            % mail
            if parameters.flag_mail
                tools_alertmail([participant.name,' starts the warmup mode']);
            end

            % flags
            parameters.flag_blackandwhite = 0;
            parameters.flag_showreward = 0;
            parameters.flag_stopprob   = 1;
            parameters.flag_disabledchanges = 1;

            % screen
            Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
            Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
            Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
            Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
            Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);
            DrawFormattedText(ptb.screen_w,'Warm-up phase :)','center','center');
            Screen(ptb.screen_w,'Flip');
            ptb_resp_click;

        end

        %% Black and White
        if parameters.mode ~=2 && j_trial >= .1*parameters.run_trials
            parameters.mode = 2;

            % mail
            if parameters.flag_mail
                tools_alertmail([participant.name,' starts the black-and-white mode']);
            end

            % flags
            parameters.flag_blackandwhite = 1;
            parameters.flag_showreward = 1;
            parameters.flag_stopprob   = 1;
            parameters.flag_disabledchanges = 0;

            % screen
            Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
            Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
            Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
            Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);
                % screen 1
            Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
            DrawFormattedText(ptb.screen_w,'Black-and-White phase :)','center',ptb.screen_center(2));
            Screen(ptb.screen_w,'Flip');
            ptb_resp_click;
                % screen 2
            Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
            DrawFormattedText(ptb.screen_w,'Good luck!','center',ptb.screen_center(2)+50);
            Screen(ptb.screen_w,'Flip');
            ptb_resp_click;
        end
end
        
    