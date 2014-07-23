function set_results(session)
    %% participant files
    % ls the 'data' folder
    tmp_lsdata= dir(['data',filesep,'data',filesep,session]);
    lsdata = {};
    for i = 1:length(tmp_lsdata)
        if ~(tmp_lsdata(i).name(1)=='.')
            lsdata{end+1} = tmp_lsdata(i).name;
        end
    end
    nb_lsdata = length(lsdata);
    clear i;
    
    % mkdir the 'results' folder
    if ~exist(['data',filesep,'result'],'dir');
        mkdir(['data',filesep,'result']);
    end
    if ~exist(['data',filesep,'result',filesep,session],'dir');
        mkdir(['data',filesep,'result',filesep,session]);
    end
    
    % for each data file
    for i_lsdata = 1:nb_lsdata
        %% initialise
        % load
        load(['data',filesep,'data',filesep,session,filesep,lsdata{i_lsdata}]);
        % struct
        results = struct();
        fprintf(['set_results: setting results for ',participant.name,'\n']);
        
        %% trial results
        % data
        results.trial_data = data;
        
        % quiz
        if parameters.flag_quiz
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
        results.map         = map;
        
        
        %% save
        save(['data',filesep,'result',filesep,session,filesep,lsdata{i_lsdata}]);
    end
end
