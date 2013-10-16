% minutes counter
if parameters.run_by_min
    gs = GetSecs - ptb.time_start;
    gm = gs/60;
    if parameters.run_min <= gm
        end_of_task = 1;
    end
end
    
% block counter
if parameters.run_by_blocks
    if parameters.run_blocks <= i_block
        end_of_task = 1;
    end
end

% trial counter
if parameters.run_by_trials
    if parameters.run_trials <= j_trial
        end_of_task = 1;
    end
end

% clean
clear gs gm;