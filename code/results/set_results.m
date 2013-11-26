function set_results(session)
    %% participant files
        % ls the 'data' folder
    if ispc()
        tmp_lsdata= dir(['data',filesep,session]);
        lsdata = {};
        for i = 1:length(tmp_lsdata)
            if ~(tmp_lsdata(i).name(1)=='.')
                lsdata{end+1} = tmp_lsdata(i).name;
            end
        end
        nb_lsdata = length(lsdata);
    else
        lsdata = regexp(ls(['data',filesep,session]),'\s','split');
        i = 1;
        while i<=length(lsdata)
            if isempty(lsdata{i})
                lsdata(i) = [];
            else
                i = i+1;
            end
            nb_lsdata = length(lsdata);
        end
        clear i;
    end
        % mkdir the 'results' folder
    if ~exist('result','dir');
        mkdir('result');
    end
    if ~exist(['result',filesep,session],'dir');
        mkdir(['result',filesep,session]);
    end
    
    % for each data file
    for i_lsdata = 1:nb_lsdata
        %% initialise
        % load
        load(['data',filesep,session,filesep,lsdata{i_lsdata}]);
        % struct
        results = struct();
        fprintf(['set_results: setting results for ',participant.name,'\n']);
        
        %% trial results
        % data
        %{
        data.avatar_inexchange = [];
        for i_trial = 1:length(data.avatar_instation)
            data.avatar_inexchange(end+1)     = (length(unique(map.links(data.avatar_instation(i_trial),:))) > 3);
        end
        %}
        results.trial_data = data;
        
        % quiz
        if parameters.flag_quiz
            %{
            quiz.avatar_inexchange = [];
            for i_trial = 1:length(quiz.avatar_instation)
                quiz.avatar_inexchange(end+1)     = (length(unique(map.links(quiz.avatar_instation(i_trial),:))) > 3);
            end
            %}
            results.trial_quiz  = quiz;
        end

        %% block results
        % data
        max_blocks = max(data.exp_block);
        results.block_data = results_blockdata(map,data);
        
        % quiz
        if parameters.flag_quiz
            results.block_quiz = results_blockquiz(quiz);
        end
        
        %% participant results
        results.participant = participant;
        
        
        %% save
        save(['result',filesep,session,filesep,'results_',participant.name,'_',num2str(participant.id),'.mat'],'results','map','parameters','participant','ptb');
    end
end
