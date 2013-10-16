
%% Possible buttons

if parameters.flag_optionscross
    nb_options = 4;
else
    nb_options = parameters.screen_optionsline.nb;
end
if parameters.flag_optionscross
    tmp_keycodes = nan(1,nb_options);
    for i_options = 1:nb_options
        if options_enabled(i_options)
            tmp_keycodes(i_options) = KbName(parameters.screen_optionscross.keynames{i_options});
        end
    end
    % escape code
    tmp_escapecode      = KbName(parameters.screen_optionscross.exitkbname);
    % enable changes station
    tmp_enablecode      = KbName(parameters.screen_optionscross.enablekbname);
else
    tmp_keycodes = nan(1,nb_options);
    for i_options = 1:nb_options
        if options_sublines(i_options)
            tmp_keycodes(i_options) = KbName(parameters.screen_optionsline.keynames{i_options});
        end
    end
    % add escape
    tmp_escapecode      = KbName(parameters.screen_optionsline.exitkbname);
    % enable changes station
    tmp_enablecode      = KbName(parameters.screen_optionsline.enablekbname);
end

%% Get key

% no response
resp = struct();
resp.bool = 0;
resp.code = nan;
resp.name = '';
resp.gs = nan;
resp.rt = nan;
resp.option = nan;
resp.subline = nan;
resp.station = nan;
resp.steptime = nan;
resp.dist = nan;
resp.cor = nan;

% press key
while ~resp.bool
    tmp_gs = GetSecs();
    
    % time limit
    if  parameters.flag_timelimit && ...
        tmp_gs > ptb.screen_time_next
        end_of_trial = 1;
        break;
    end
    
    [kdown,ksecs,kcode] = KbCheck();
    % check escape key
    if kdown && sum(kcode)==1
        kcode = find(kcode);
        switch kcode
            % escape
            case tmp_escapecode
                end_of_trial = 1;
                end_of_block = 1;
                end_of_task  = 1;
                fprintf('Exit forced by user.\n');
                break
            % enable other lines
            case tmp_enablecode
                tmp_instation    = map.avatar.in_station;
                tmp_difflines = map.links(map.stations(tmp_instation).id,:);
                tmp_difflines(~tmp_difflines) = [];
                tmp_difflines = unique(ceil(.5*tmp_difflines));
                tmp_nbdifflines = length(tmp_difflines);
                if parameters.flag_disabledchanges && tmp_nbdifflines>1
                    parameters.flag_disabledchanges = 3 - parameters.flag_disabledchanges;
                    break;
                end
            % sublines
            otherwise
                if any(kcode==tmp_keycodes)
                    resp.bool = 1;
                    resp.code = kcode;
                    resp.name = KbName(kcode);
                    resp.gs = tmp_gs;
                    resp.rt = tmp_gs - ptb.screen_time_this;
                    resp.option = find(kcode==tmp_keycodes);
                    resp.subline = options_sublines(resp.option);
                    resp.station = options_stations(resp.option);
                    resp.steptime = map.sublines(resp.subline).time;
                    resp.dist = map.dists.steptimes_stations(map.avatar.to_station,resp.station);
                    resp.cor  = (resp.dist < map.dists.steptimes_stations(map.avatar.to_station,map.avatar.in_station));
                    % reset disabledchanges
                    if parameters.flag_disabledchanges
                        parameters.flag_disabledchanges = 1;
                    end
                    % end of trial
                    end_of_trial = 1;
                    break
                end
        end
    end
end

% release
if ~parameters.flag_timelimit
    while kdown; kdown = KbCheck(); end
end

%% Clean

clear i_options;
clear tmp_gs tmp_keycodes tmp_escapecode tmp_enablecode;
clear kdown ksecs kcode;
clear tmp_stations tmp_options;
