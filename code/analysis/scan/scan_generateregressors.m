

function runs = scan_generateregressors(scans)
    
    runs = {};
    if ~iscell(scans); scans = {scans}; end
    
    for i_scan = 1:length(scans)
        scan = scans{i_scan};

        %% go through screens
        % remove espace characters
        % find break indices
        ii_break = [];
        for i_screen = 1:length(scan.time.screens)
            scan.time.screens{i_screen}(scan.time.screens{i_screen}==' ') = [];
            if strcmp(scan.time.screens{i_screen},'breakwait')
                ii_break(end+1) = i_screen;
            end
        end
        ii_break(end+1) = length(scan.time.screens)+1;

        %% prepare runs
        % set offset time
        scan.time.offset = scan.time.getsecs - scan.time.breakgs;

        % set run template
        run_template = struct();
        u_screen = unique(scan.time.screens);
        for i_screen = 1:length(u_screen)
            run_template.(['screen_',u_screen{i_screen}]) = [];
        end
        
        % map faces
        faces = char(map_getfaces());
        faces = reshape(faces',[1,numel(faces)]);
        for i_station = 1:scan.map.nb_stations
            if strfind(faces,scan.map.stations(i_station).name)
                scan.map.stations(i_station).face = 1;
            else
                scan.map.stations(i_station).face = 0;
            end
        end

        for i_break = 1:(length(ii_break)-1)
            %% add screens
            % load template
            run = run_template;
            % set index
            ii_trial = ii_break(i_break):(ii_break(i_break+1)-1);
            % set trial
            for i_trial = 1:length(ii_trial)
                run.(['screen_',scan.time.screens{ii_trial(i_trial)}])(end+1) = scan.time.offset(ii_trial(i_trial));
            end
            
            %% add data
            breakgs = scan.time.breakgs(ii_break(i_break+1)-1);
            trial_gs = scan.data.resp_gs - scan.data.resp_rt;
            trial_os = trial_gs - breakgs;
            ii_run = (scan.data.exp_break==i_break);
            % exchange
            ii_exchange = logical([scan.map.stations(scan.data.avatar_instation).exchange]);
            time_exchange = trial_os(ii_run & ii_exchange);
            run.('avatar_exchange') = time_exchange;
            % elbow
            ii_elbow = logical([scan.map.stations(scan.data.avatar_instation).elbow]);
            time_elbow = trial_os(ii_run & ii_elbow);
            run.('avatar_elbow') = time_elbow;
            % face
            ii_face  = logical([scan.map.stations(scan.data.avatar_instation).face]);
            time_face = trial_os(ii_run & ii_face);
            run.('avatar_face') = time_face;
            % switch
            ii_diffline = logical([diff(scan.data.avatar_insubline),0]);
            ii_stop = scan.data.exp_stoptrial;
            time_switch = trial_os(ii_run & ii_diffline & ~ii_stop & ii_exchange);
            run.('avatar_switch') = time_switch;
            % backwards
            ii_start = scan.data.exp_starttrial;
            time_backwards = trial_os(ii_run & ii_diffline & ~ii_stop & ~ii_exchange & ~ii_start);
            run.('avatar_backwards') = time_backwards;
            
            %% remove fields
            run = rmfield(run,'screen_breakwait');
            run = rmfield(run,'screen_clickpress');
            run = rmfield(run,'screen_clickrelease');
            run = rmfield(run,'screen_nan');
            
            %% save run
            runs{end+1} = run;
        end
    end
end