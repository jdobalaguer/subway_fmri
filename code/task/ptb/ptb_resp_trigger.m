
%% initialise trigger variable
tmp_scantrigger = nan;

%% scanner mode
if parameters.flag_scanner
    while 1
        % trigger
        if parameters.resp_buttonbox && ~ispc() && ptb.gamepad_i && Gamepad('GetButton', ptb.gamepad_i, 5)
            tmp_scantrigger = GetSecs();
            break;
        end
        [kdown ksecs kcode] = KbCheck(ptb.kb_i);
        % escape
        if kdown && kcode(KbName('ESCAPE'))
            end_of_task = 1;
            end_of_block = 1;
            end_of_trial  = 1;
            break;
        end
    end
        
%% dummy mode
else
    while 1
        ptb_resp_click();
        tmp_scantrigger = GetSecs();
        break;
    end
end

%% clean
clear kdown ksecs kcode;
