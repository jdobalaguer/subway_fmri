
%% press key
tmp_while = 1;
while tmp_while
    tmp_gs = GetSecs();
    
    % time limit
    if  tmp_gs > ptb.screen_time_next
        tmp_maptime = tmp_gs - ptb.screen_time_this;
        break;
    end
    
    % get response
    ptb_response;
    
    if (tmp_response.nbkeys==1)
        %% escape
        if tmp_response.escape
            end_of_trial = 1;
            end_of_block = 1;
            end_of_task  = 1;
            fprintf('Exit forced by user.\n');
            break
        end
        
        %% otherwise
        tmp_while = 0;
        tmp_maptime = tmp_gs - ptb.screen_time_this;
    end
end

% timestamps
ptb.screen_time_this = GetSecs();
ptb.screen_time_next = GetSecs();

%% clean
clear tmp_gs tmp_escapecode tmp_while;
clear tmp_response;
clear tmp_stations tmp_options;
