
%% build response struct
resp = struct();
resp.bool = 0;
resp.code = nan;
resp.name = '';
resp.gs = nan;
resp.ts = nan;
resp.rt = nan;
resp.option = nan;
resp.subline = nan;
resp.station = nan;
resp.steptime = nan;
resp.dist = nan;
resp.cor = nan;
resp.maptime = nan;
if exist('tmp_maptime','var')
    resp.maptime = tmp_maptime;
end

%% press key
while ~resp.bool
    tmp_gs = GetSecs();
    
    % time limit
    if  parameters.flag_timelimit && ...
        tmp_gs > ptb.screen_time_next
        end_of_trial = 1;
        
        % default response
        switch(parameters.resp_default)
            % random response
            case 'random'
                resp.option = tools_randomelement(find(options_sublines));
                resp.subline = options_sublines(resp.option);
                resp.station = options_stations(resp.option);
                resp.steptime = map.sublines(resp.subline).time;
                resp.dist = map.dists.steptimes_stations(map.avatar.to_station,resp.station);
                resp.cor  = (resp.dist < map.dists.steptimes_stations(map.avatar.to_station,map.avatar.in_station));
            % forward response
            case 'forward'
                resp.option = find(options_sublines==map.avatar.in_subline);
                if isempty(resp.option)
                    resp.option = tools_randomelement(find(options_sublines));
                end
                resp.subline = options_sublines(resp.option);
                resp.station = options_stations(resp.option);
                resp.steptime = map.sublines(resp.subline).time;
                resp.dist = map.dists.steptimes_stations(map.avatar.to_station,resp.station);
                resp.cor  = (resp.dist < map.dists.steptimes_stations(map.avatar.to_station,map.avatar.in_station));
            % no response
            case 'none'
                resp.option = nan;
                resp.subline = map.avatar.in_subline;
                resp.station = map.avatar.in_station;
                resp.steptime = map.sublines(resp.subline).time;
                resp.dist = map.dists.steptimes_stations(map.avatar.to_station,resp.station);
                resp.cor  = 0;
            % otherwise error
            otherwise
                error(['ptb_resp_kbtrial: error. response "',parameters.resp_default,'" is not valid']);
        end
    
        break;
    end
    
    % get response
    ptb_response;
    
    if (tmp_response.nbkeys==1)
        %% escape
        if tmp_response.escape
            end_of_trial = 1;
            end_of_block = 1;
            end_of_task  = 1;
            fprintf('Exit forced by user.\n');
            break
        end
        
        %% enable other lines
        if tmp_response.enable && parameters.flag_disabledchanges
            tmp_instation = map.avatar.in_station;
            tmp_difflines = map.links(map.stations(tmp_instation).id,:);
            tmp_difflines(~tmp_difflines) = [];
            tmp_difflines = unique(ceil(.5*tmp_difflines));
            tmp_nbdifflines = length(tmp_difflines);
            if tmp_nbdifflines>1
                parameters.flag_disabledchanges = 3 - parameters.flag_disabledchanges;
                break;
            end
        end
        
        %% directions
        if tmp_response.nbcard
            % west
            if tmp_response.west
                resp.code = 1;
                resp.option = 1;
                resp.name = 'west';
            end
            % north
            if tmp_response.north
                resp.code = 2;
                resp.option = 2;
                resp.name = 'north';
            end
            % south
            if tmp_response.south
                resp.code = 3;
                resp.option = 3;
                resp.name = 'south';
            end
            % east
            if tmp_response.east
                resp.code = 4;
                resp.option = 4;
                resp.name = 'east';
            end
            if options_stations(resp.option) && options_sublines(resp.option) && options_enabled(resp.option)
                % set resp
                resp.bool = 1;
                resp.gs = tmp_gs;
                resp.ts = tmp_gs - time.breakgs(end);
                resp.rt = tmp_gs - ptb.screen_time_this;
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

time.screens{end+1}  = 'trial press';
time.getsecs(end+1) = tmp_gs;
time.breakgs(end+1) = time.breakgs(end);

% release
if ~parameters.flag_timelimit
    ptb_release;
    
    time.screens{end+1}  = 'trial release';
    time.getsecs(end+1) = GetSecs();
    time.breakgs(end+1) = time.breakgs(end);
end

%% Clean

clear i_options;
clear tmp_gs;
clear kdown;
clear tmp_response;
clear tmp_stations tmp_options;
clear tmp_instation tmp_difflines tmp_nbdifflines;
