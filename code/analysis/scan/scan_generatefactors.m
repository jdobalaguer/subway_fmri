
function [timeruns,dataruns] = scan_generatefactors(datafiles)
    
    timeruns = {};
    dataruns = {};
    if ~iscell(datafiles); datafiles = {datafiles}; end
    
    for i_datafiles = 1:length(datafiles)
        datafile = datafiles{i_datafiles};
        
        %% set breakgs
        breakgs = unique(datafile.time.breakgs);
        breakgs(isnan(breakgs)) = [];
        
        %% go through runs
        u_break   = unique(datafile.data.exp_break);
        nb_breaks = length(u_break);
        
        for i_break = 1:nb_breaks
            ii_break = (datafile.data.exp_break==u_break(i_break));
            % time
            timeruns{end+1} = datafile.data.time_trial(ii_break) - breakgs(i_break);
            % data
            dataruns{end+1} = struct_index(datafile.data,ii_break);
        end
    end
    
end

function [substruct] = struct_index(mainstruct,index)
    substruct = mainstruct;
    u_field = fieldnames(substruct);
    nb_fields = length(u_field);
    for i_field = 1:nb_fields
        field = u_field{i_field};
        if  strcmp(field,'dists_steptimes_stations') || ...
            strcmp(field,'dists_steptimes_sublines') || ...
            strcmp(field,'dists_exchanges_stations') || ...
            strcmp(field,'dists_exchanges_sublines') || ...
            strcmp(field,'dists_euclidean')
            substruct.(field) = substruct.(field) - nanmean(substruct.(field)); end
        substruct.(field)(~index) = [];
    end
end    