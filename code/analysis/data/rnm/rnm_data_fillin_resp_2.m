
% response (dependent on independent variables, dependent on response)
function data = rnm_data_fillin_resp_2(data)
    %% direction
    data.resp_direction_code(isnan(data.resp_direction_code)) = 0;
    data.resp_direction_back   = (  (data.vbxi_direction_code == 1 & data.resp_direction_code == 4) | ...
                                    (data.vbxi_direction_code == 2 & data.resp_direction_code == 3) | ...
                                    (data.vbxi_direction_code == 3 & data.resp_direction_code == 2) | ...
                                    (data.vbxi_direction_code == 4 & data.resp_direction_code == 1) );
    data.resp_direction_back_any = jb_applyvector( ...
        @(subject,session,block) any(data.resp_direction_back(data.expt_subject == subject & data.expt_session == session & data.expt_block == block)),     ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                                             ... categories
    data.resp_direction_switch = (data.vbxi_direction_code ~= data.resp_direction_code) & data.vbxi_direction_code & data.resp_direction_code & ~data.resp_direction_back;
end
