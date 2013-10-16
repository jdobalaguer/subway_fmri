if ~isempty(parameters.debug_preload)
    p = parameters;
    % preload 
    load(['data/',parameters.debug_preload,'.mat']);
    % change filenames
    while exist(participant.filename_data,'file') || exist(participant.filename_error,'file')
        participant.id   = participant.id + 1;
        participant.filename_data  = ['data',filesep,'data_',participant.name,'_',num2str(participant.id),'.mat'];
        participant.filename_error = ['data',filesep,'error_',participant.name,'_',num2str(participant.id),'.mat'];
    end
    % set preload option
    parameters.debug_preload = p.debug_preload;
    clear p;
end
