if ~isempty(parameters.debug_preload)
    p = parameters;
    % preload 
    load(['data',filesep,parameters.session,filesep,parameters.debug_preload]);
    % change filenames
    while exist(participant.filename_data,'file') || exist(participant.filename_error,'file')
        participant.id   = participant.id + 1;
        participant.filename_data  = ['data',filesep,parameters.session,filesep,'data_',participant.name,'_',num2str(participant.id),'.mat'];
        participant.filename_error = ['data',filesep,parameters.session,filesep,'error_',participant.name,'_',num2str(participant.id),'.mat'];
    end
    % set preload option
    parameters.debug_preload = p.debug_preload;
    clear p;
end
