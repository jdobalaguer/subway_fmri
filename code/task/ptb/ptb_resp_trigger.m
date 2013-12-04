
%% save trigger
tmp_scantrigger = nan;
while 1
    if exist('lptread','builtin')
        tmp_value = lptread(889);
    end
    
    %% scanner mode
    if parameters.flag_scanner
        if tmp_value==199;
            tmp_scantrigger = GetSecs();
            WaitSecs(parameters.time_scanwait);
            break;
        end
        [kdown ksecs kcode] = KbCheck();
        if kdown
            % escape
            if kcode(KbName('ESCAPE'))
                end_of_task = 1;
                end_of_block = 1;
                end_of_trial  = 1;
                break;
            end
        end
        
    %% dummy mode
    else
        ptb_resp_click();
        tmp_scantrigger = GetSecs();
        break;
    end
end

%% clean
clear kdown ksecs kcode;
clear tmp_value;
