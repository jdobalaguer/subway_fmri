if ~parameters.flag_break; i_break = nan; return; end
if end_of_task; return; end

if ~exist('i_break','var')
    i_break = 1;
end

%% Do break?
do_break = 1;
% minutes counter
if parameters.run_by_min
    tmp_nbreaks = length(parameters.break_min);
    gs = GetSecs - ptb.time_start;
    gm = gs/60;
    if i_break > length(parameters.break_min) || parameters.break_min(i_break) > gm
        do_break = 0;
    end
end    
% block counter
if parameters.run_by_blocks
    tmp_nbreaks = length(parameters.break_blocks);
    if i_break > length(parameters.break_blocks) || parameters.break_blocks(i_break) > i_block
        do_break = 0;
    end
end
% trial counter
if parameters.run_by_trials
    tmp_nbreaks = length(parameters.break_trials);
    if i_break > length(parameters.break_trials) || parameters.break_trials(i_break) > j_trial
        do_break = 0;
    end
end

%% Break
if do_break
    Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
    Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
    Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
    Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);
    
    %% wait screen
    % screen
    Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
    if parameters.flag_scanner
        if exist('lptread','builtin')
            DrawFormattedText(ptb.screen_w,['Break ',num2str(i_break),'/',num2str(tmp_nbreaks)],'center',ptb.screen_center(2));
            DrawFormattedText(ptb.screen_w,'Please wait for scanner signal','center',ptb.screen_center(2)+50);
        else
            DrawFormattedText(ptb.screen_w,'LPTREAD doesnt exist. Please cancel.','center','center');
        end
    else
        DrawFormattedText(ptb.screen_w,['Break ',num2str(i_break),'/',num2str(tmp_nbreaks)],'center',ptb.screen_center(2));
        DrawFormattedText(ptb.screen_w,'Dummy mode. Press any key.','center',ptb.screen_center(2)+50);
    end
    % flip
    [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');
    time.screens{end+1}  = 'break wait';
    time.getsecs(end+1) = tmp_stimulusonset;
    time.breakgs(end+1) = time.breakgs(end);
    % trigger
    ptb_resp_trigger;
    if end_of_task; return; end

    %% ready screen
    Screen(ptb.screen_w, 'FillRect', ptb.screen_bg_color);
    DrawFormattedText(ptb.screen_w,'Ready? Press any button','center','center');
    % flip
    [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');
    time.screens{end+1}  = 'break ready';
    time.getsecs(end+1) = tmp_stimulusonset;
    time.breakgs(end+1) = tmp_scantrigger;
    % trigger
    ptb_resp_click;
    if end_of_task; return; end

    i_break = i_break+1;
end

%% Clean
clear do_break;
clear tmp_nbreaks;
clear tmp_scantrigger;
clear tmp_vbltimestamp tmp_stimulusonset;
