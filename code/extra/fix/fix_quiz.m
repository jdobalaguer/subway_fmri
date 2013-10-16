
function fix_quiz()
    
    % ls the 'data' folder
    lsdata = regexp(ls('data'),'\s','split');
    i = 1;
    while i<=length(lsdata)
        if isempty(lsdata{i})
            lsdata(i) = [];
        else
            i = i+1;
        end
    end
    
    % for each data file
    for i_lsdata = 1:length(lsdata)
        % load
        load(['data/',lsdata{i_lsdata}]);
        % for each goal
        u_goalstation = unique(quiz.avatar_goalstation);
        nb_goalstation = length(u_goalstation);
        for i_goalstation = 1:length(u_goalstation)
            % find a seq
            i_seq = find(u_goalstation(i_goalstation)==map.seqs(:,2));
            i_seq = i_seq(1);
            % find trials
            ii_trial = (quiz.avatar_goalstation==u_goalstation(i_goalstation));
            % change resp_dist
            data.resp_dist(ii_trial) = map.dists.steptimes_stations(i_seq,quiz.resp_station(ii_trial));
        end
        quiz.resp_cor = (quiz.resp_dist < quiz.dists_steptimes_stations);
        % save
        if parameters.flag_quiz
            save(['data/',lsdata{i_lsdata}],'data','map','allo','parameters','participant','ptb','quiz');
        else
            save(['data/',lsdata{i_lsdata}],'data','map','allo','parameters','participant','ptb');
        end
    end
    
    
end