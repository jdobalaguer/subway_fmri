if ~parameters.flag_scanner; return; end

%% screen
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);
if exist('lptread','builtin')
    DrawFormattedText(ptb.screen_w,'Please wait','center','center');
else
    DrawFormattedText(ptb.screen_w,'LPTREAD doesnt exist. Please cancel.','center','center');
end
% flip
Screen(ptb.screen_w,'Flip');

%% wait for trigger
ptb.scan_triggers = [];
while 1
    tmp_value = -1;
    if ispc()
        tmp_value = lptread(889);
    end
    %% connection received
    if tmp_value==199;
        ptb.scan_triggers(end+1) = GetSecs();
    end
    if length(ptb.scan_triggers)>=5
        break;
    end
    
    %% escape
    [kdown ksecs kcode] = KbCheck();
    if kdown
        if kcode(KbName('ESCAPE'))
            end_of_task = 1;
            break;
        end
    end
end

%% clean
clear kdown ksecs kcode;
clear tmp_value;
