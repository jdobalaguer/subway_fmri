

resp.bool           = nan;
resp.gs             = nan;
resp.rt             = nan;
resp.resp_istation  = nan;
resp.resp_station   = nan;
resp.resp_name      = nan;
resp.in_istation    = nan;
resp.in_station     = nan;
resp.in_name        = nan;
resp.distin         = nan;
resp.cor            = nan;

while isnan(resp.bool)
    % press
    ptb.mouse_buttons = 0;
    kdown = 0;
    while ~any(ptb.mouse_buttons) && ~kdown
        [ptb.mouse_x,ptb.mouse_y,ptb.mouse_buttons] = GetMouse;
        [kdown,ksecs,kcode] = KbCheck();
    end

    % release
    while any(ptb.mouse_buttons) || kdown
        [ptb.mouse_x,ptb.mouse_y,ptb.mouse_buttons] = GetMouse;
        [kdown,ksecs,kcode] = KbCheck();
    end

    % check escape key
    if kdown && sum(kcode)==1
        kcode = find(kcode);
        switch kcode
            % escape
            case KbName(parameters.screen_list.exitkbname);
                end_of_trial = 1;
                end_of_block = 1;
                end_of_task  = 1;
                fprintf('Exit forced by user.\n');
                return;
        end
    end

    % exit if stations not asked
    if ~(exist('tmp_askstations','var') && tmp_askstations(i_trial))
        return;
    end

    % find box
    nb_names = size(br_names,1);
    for i_station = i_trial:nb_names
        if      ptb.mouse_x > br_names(i_station,1) && ...
                ptb.mouse_x < br_names(i_station,3) && ...
                ptb.mouse_y > br_names(i_station,2) && ...
                ptb.mouse_y < br_names(i_station,4)

            resp.bool           = 1;
            resp.gs             = ksecs;
            resp.rt             = ksecs - ptb.screen_time_this;
            resp.resp_istation  = i_station;
            resp.resp_station   = tmp_nextstations(i_station-i_trial+1);
            resp.resp_name      = tmp_nextnames{i_station-i_trial+1};
            resp.in_istation    = find(tmp_nextstations==tmp_stations(i_trial))+i_trial-1;
            resp.in_station     = tmp_stations(i_trial);
            resp.in_name        = tmp_names{i_trial};
            resp.distin         = map.dists.steptimes_stations(tmp_stations(i_trial),tmp_nextstations(i_station-i_trial+1));
            resp.cor            = (tmp_stations(i_trial)==tmp_nextstations(i_station-i_trial+1));
        end
    end
end