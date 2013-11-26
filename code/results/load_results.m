function allresults = load_results(session)
    %% participant files
    % ls the 'data' folder
    lsdata = regexp(ls(['result',filesep,session]),'\s','split');
    i = 1;
    while i<=length(lsdata)
        if isempty(lsdata{i})
            lsdata(i) = [];
        else
            i = i+1;
        end
    end
    nb_lsdata = length(lsdata);
    
    %% concatenate results
    allresults = struct();
    
    % for each participant
    for i_lsdata = 1:nb_lsdata
        % load
        load(['result',filesep,session,filesep,lsdata{i_lsdata}]);
        
        % change subject number
        results.trial_data.exp_sub(:) = i_lsdata;
        results.trial_quiz.exp_sub(:) = i_lsdata;
        results.block_data.exp_sub(:) = i_lsdata;
        results.block_quiz.exp_sub(:) = i_lsdata;
        
        % firste create
        if i_lsdata==1
            % data
            allresults.trial_data = results.trial_data;
            allresults.block_data = results.block_data;
            % quiz
            if parameters.flag_quiz
                allresults.trial_quiz = results.trial_quiz;
                allresults.block_quiz = results.block_quiz;
            end
            % participant
            allresults.participant = {results.participant};
        % then concatenate
        else
            % data
            allresults.trial_data = tools_catstruct(allresults.trial_data,results.trial_data);
            allresults.block_data = tools_catstruct(allresults.block_data,results.block_data);
            % quiz
            if parameters.flag_quiz
                allresults.trial_quiz = tools_catstruct(allresults.trial_quiz,results.trial_quiz);
                allresults.block_quiz = tools_catstruct(allresults.block_quiz,results.block_quiz);
            end
            % participant
            allresults.participant{end+1} = results.participant;
        end
    end
end