if ~parameters.flag_break; i_break = nan; return; end
if end_of_task; return; end

%% Do break?
do_break = 1;
tmp_nbreaks = length(parameters.run_breaks);
if ~exist('i_break','var')
    i_break = 0;
else
    if ~isnan(ptb.time_break)
        gs = GetSecs - ptb.time_break;
        gm = gs/60;
        if i_break > length(parameters.run_breaks) || parameters.run_breaks(i_break) > gm
            do_break = 0;
        end
    end    
end

%% Break
if do_break
    i_break = i_break+1;
    
    Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
    Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
    Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
    Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

    %% pos blank screen
    if i_break>1
        Screen(ptb.screen_w, 'FillRect', ptb.screen_bg_color);
        % flip
        [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
        ptb.screen_time_this = tmp_stimulusonset;
        if parameters.flag_timize
            ptb.screen_time_next = tmp_stimulusonset + parameters.time_breakpos;
        else
            ptb.screen_time_next = tmp_stimulusonset;
            ptb_resp_click;
        end
        time.screens{end+1}  = 'break pos';
        time.getsecs(end+1) = tmp_stimulusonset;
        time.breakgs(end+1) = time.breakgs(end);
    end
    
    %% was this last break?
    if i_break > length(parameters.run_breaks)
        end_of_block = 1;
        end_of_task = 1;
    end
    
    %% end of task (by click or by last break)
    if end_of_task
        clear do_break;
        clear gm gs;
        clear tmp_nbreaks;
        clear tmp_scantrigger;
        clear tmp_vbltimestamp tmp_stimulusonset;
        return
    end
    
    %% wait screen
    % screen
    Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
    if parameters.flag_scanner
        DrawFormattedText(ptb.screen_w,['Run ',num2str(i_break),'/',num2str(tmp_nbreaks)],'center',ptb.screen_center(2));
        DrawFormattedText(ptb.screen_w,'Please wait for scanner signal','center',ptb.screen_center(2)+50);
    else
        DrawFormattedText(ptb.screen_w,['Run ',num2str(i_break),'/',num2str(tmp_nbreaks)],'center',ptb.screen_center(2));
        DrawFormattedText(ptb.screen_w,'Dummy mode. Press any key.','center',ptb.screen_center(2)+50);
    end
    % flip
    [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');
    time.screens{end+1}  = 'break wait';
    time.getsecs(end+1) = tmp_stimulusonset;
    time.breakgs(end+1) = time.breakgs(end);
    input('break','s');
    % trigger
    ptb_resp_trigger;
    if end_of_task; return; end

    %% pre blank screen
    Screen(ptb.screen_w, 'FillRect', ptb.screen_bg_color);
    % flip
    [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
    ptb.screen_time_this = tmp_stimulusonset;
    if parameters.flag_timize
        ptb.screen_time_next = tmp_stimulusonset + parameters.time_breakpre;
    else
        ptb.screen_time_next = tmp_stimulusonset;
        ptb_resp_click;
    end
    time.screens{end+1}  = 'break pre';
    time.getsecs(end+1) = tmp_stimulusonset;
    time.breakgs(end+1) = tmp_scantrigger;
    ptb.time_break = tmp_scantrigger;
    % trigger
    if end_of_task; return; end
end

%% Clean
clear do_break;
clear gm gs;
clear tmp_nbreaks;
clear tmp_scantrigger;
clear tmp_vbltimestamp tmp_stimulusonset;
