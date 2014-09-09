
function data = rnm_data_fillin_expt(data)
    % expt_trigger
    data.expt_trigger(data.resp_bool) = (data.resp_getsecs(data.resp_bool) - data.resp_onset(data.resp_bool));
    for ii_trigger = find(~data.resp_bool)
        ii_subject = (data.expt_subject == data.expt_subject(ii_trigger));
        ii_session = (data.expt_session == data.expt_session(ii_trigger));
        ii_notanan = (data.resp_bool);
        assert(numel(unique(data.expt_trigger(ii_subject & ii_session & ii_notanan)))==1, 'rnm_data_fillin: error. expt_trigger');
        data.expt_trigger(ii_trigger) = unique(data.expt_trigger(ii_subject & ii_session & ii_notanan));
    end
end
