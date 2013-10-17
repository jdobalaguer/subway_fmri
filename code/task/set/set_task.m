end_of_task = 0;
if isempty(parameters.debug_preload)
    i_block = 0;
    j_trial = 0;
else
    i_block = max(data.exp_block);
    j_trial = length(data.exp_block);
end

% select your home location
if strcmp(parameters.flag_tasksel,'home') && ~isfield(participant,'homestation')
    participant.homestation = randi(map.nb_stations);
    % criteria
    while   (sum(map.links(participant.homestation,:)>0)~=2) ... % regular station
            || ...
            ( ...
                ~sum(map.links(participant.homestation,:)==1) ... % connection with yellow line
                && ...
                ~sum(map.links(participant.homestation,:)==7) ... % connection with blue line
            )
        participant.homestation = randi(map.nb_stations);
    end
end
