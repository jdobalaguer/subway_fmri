
%% Get key
tmp_escapecode      = KbName(parameters.screen_optionsline.exitkbname);

% press key
tmp_while = 1;
while tmp_while
    tmp_gs = GetSecs();
    
    % time limit
    if  tmp_gs > ptb.screen_time_next
        tmp_maptime = tmp_gs - ptb.screen_time_this;
        break;
    end
    
    [kdown,ksecs,kcode] = KbCheck();
    if kdown && sum(kcode)==1
        kcode = find(kcode);
        switch kcode
            % escape
            case tmp_escapecode
                end_of_trial = 1;
                end_of_block = 1;
                end_of_task  = 1;
                fprintf('Exit forced by user.\n');
                break
            otherwise
                tmp_while = 0;
                tmp_maptime = tmp_gs - ptb.screen_time_this;
                break
        end
    end
end

% release
while kdown; kdown = KbCheck(); end

% timestamps
ptb.screen_time_this = GetSecs();
ptb.screen_time_next = GetSecs();

%% Clean
clear tmp_gs tmp_escapecode tmp_while;
clear kdown ksecs kcode;
clear tmp_stations tmp_options;
