if ~parameters.debug_subject; return; end
if end_of_task; return; end

save(participant.filename_data,'data','map','allo','parameters','participant','ptb');
if parameters.flag_quiz
    save(participant.filename_data,'quiz','-append');
end
if parameters.flag_enum
    save(participant.filename_data,'enum','-append');
end

% clean
clear ans;
