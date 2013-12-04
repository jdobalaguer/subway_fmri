if ~parameters.debug_subject; return; end
if end_of_task; return; end

save(participant.filename_data,'data','map','parameters','participant','ptb','time');
if parameters.flag_quiz
    if ~exist('quiz','var'); quiz_create; end
    save(participant.filename_data,'quiz','-append');
end
if parameters.flag_enum
    if ~exist('enum','var'); enum_create; end
    save(participant.filename_data,'enum','-append');
end

% clean
clear ans;
