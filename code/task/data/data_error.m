if ~parameters.debug_subject; return; end

% make dir
if ~exist(['data',filesep],'dir')
    mkdir('data');
end

% save error
save(participant.filename_error);
