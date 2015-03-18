
% independant variables (dependent on response)
function data = rnm_data_fillin_vbxi_2(data)
    %% data = rnm_data_fillin_vbxi_2(data)

    %% direction
    data.vbxi_direction_code = [0,data.resp_direction_code(1:end-1)];
    data.vbxi_direction_code(data.expt_first) = 0;
    while any(isnan(data.vbxi_direction_code))
        ii_nan = find(isnan(data.vbxi_direction_code),1,'first');
        data.vbxi_direction_code(ii_nan) = data.vbxi_direction_code(ii_nan-1);
    end
    data.vbxi_direction_west  = (data.vbxi_direction_code == 1);
    data.vbxi_direction_north = (data.vbxi_direction_code == 2);
    data.vbxi_direction_south = (data.vbxi_direction_code == 3);
    data.vbxi_direction_east  = (data.vbxi_direction_code == 4);
end
