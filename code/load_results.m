function allresults = load_results(session)
    %% participant files
    path_data = sprintf('data/result/%s/',session);
    % ls the 'data' folder
    lsdata   = dir(path_data);
    lsdata = {lsdata.name};
    i = 1;
    while i<=length(lsdata)
        if (lsdata{i}(1)=='.')
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
        loadvar = load([path_data,lsdata{i_lsdata}]);
        
        % change subject number
        loadvar.results.trial_data.exp_sub(:) = i_lsdata;
        loadvar.results.trial_quiz.exp_sub(:) = i_lsdata;
        loadvar.results.block_data.exp_sub(:) = i_lsdata;
        loadvar.results.block_quiz.exp_sub(:) = i_lsdata;
        
        % firste create
        if i_lsdata==1
            % data
            allresults.trial_data = loadvar.results.trial_data;
            allresults.block_data = loadvar.results.block_data;
            % quiz
            if loadvar.parameters.flag_quiz
                allresults.trial_quiz = loadvar.results.trial_quiz;
                allresults.block_quiz = loadvar.results.block_quiz;
            end
            % participant
            allresults.participant = {loadvar.results.participant};
            allresults.map         = {loadvar.results.map};
        % then concatenate
        else
            % data
            allresults.trial_data = tools_catstruct(allresults.trial_data,loadvar.results.trial_data);
            allresults.block_data = tools_catstruct(allresults.block_data,loadvar.results.block_data);
            % quiz
            if loadvar.parameters.flag_quiz
                allresults.trial_quiz = tools_catstruct(allresults.trial_quiz,loadvar.results.trial_quiz);
                allresults.block_quiz = tools_catstruct(allresults.block_quiz,loadvar.results.block_quiz);
            end
            % participant
            allresults.participant{end+1} = loadvar.results.participant;
            allresults.map{end+1}         = loadvar.results.map;
        end
    end
end