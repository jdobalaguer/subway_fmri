
function data = rnm_data_fillin(data,maps)
    %% warnings
    %#ok<*NASGU,*ASGLU>

    %% numbers
    [u_subject,n_subject] = numbers(data.expt_subject);
    
    %% experiment
    data = rnm_data_fillin_expt(data);
    
    %% independant variables
    data = rnm_data_fillin_vbxi(data,maps);

    %% optimal behaviour
    data = rnm_data_fillin_optm(data,maps);
    
    %% response
    data = rnm_data_fillin_resp(data,maps);
    
    %% independant variables (dependent on response)
    data = rnm_data_fillin_vbxi_2(data);

    %% response (dependent on independent variables, dependent on response)
    data = rnm_data_fillin_resp_2(data);
    
    %% optimal behaviour (dependent on response, dependent on independent variables, dependent on response)
    data = rnm_data_fillin_optm_2(data,maps);
    
end
