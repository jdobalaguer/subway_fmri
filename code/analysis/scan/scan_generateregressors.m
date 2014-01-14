

function [timeruns,dataruns] = scan_generateregressors(datafiles)
    
    timeruns = {};
    dataruns = {};
    if ~iscell(datafiles); datafiles = {datafiles}; end
    
    for i_datafile = 1:length(datafiles)
        datafile = datafiles{i_datafile};

        %% go through screens
        % remove espace characters
        % find break indices
        ii_break = [];
        for i_screen = 1:length(datafile.time.screens)
            datafile.time.screens{i_screen}(datafile.time.screens{i_screen}==' ') = [];
            if strcmp(datafile.time.screens{i_screen},'breakwait')
                ii_break(end+1) = i_screen;
            end
        end
        ii_break(end+1) = length(datafile.time.screens)+1;

        %% prepare runs
        % set offset time
        datafile.time.offset = datafile.time.getsecs - datafile.time.breakgs;

        % set run template
        run_template = struct();
        u_screen = unique(datafile.time.screens);
        for i_screen = 1:length(u_screen)
            run_template.(['screen_',u_screen{i_screen}]) = [];
        end
        
        % map faces
        faces = char(map_getfaces());
        faces = reshape(faces',[1,numel(faces)]);
        for i_station = 1:datafile.map.nb_stations
            if strfind(faces,datafile.map.stations(i_station).name)
                datafile.map.stations(i_station).face = 1;
            else
                datafile.map.stations(i_station).face = 0;
            end
        end

        for i_break = 1:(length(ii_break)-1)
            %% add data
            dataruns{end+1} = datafile;
            
            %% add screens
            % load template
            run = run_template;
            % set index
            ii_trial = ii_break(i_break):(ii_break(i_break+1)-1);
            % set trial
            for i_trial = 1:length(ii_trial)
                run.(['screen_',datafile.time.screens{ii_trial(i_trial)}])(end+1) = datafile.time.offset(ii_trial(i_trial));
            end
            
            %% add trial data
            breakgs = datafile.time.breakgs(ii_break(i_break+1)-1);
            trial_gs = datafile.data.time_trial;
            trial_os = trial_gs - breakgs;
            ii_run = (datafile.data.exp_break==i_break);
            
            % exchange
            ii_exchange = logical([datafile.map.stations(datafile.data.avatar_instation).exchange]);
            time_exchange = trial_os(ii_run & ii_exchange);
            run.('avatar_exchange') = time_exchange;
            
            % elbow
            ii_elbow = logical([datafile.map.stations(datafile.data.avatar_instation).elbow]);
            time_elbow = trial_os(ii_run & ii_elbow);
            run.('avatar_elbow') = time_elbow;
            
            % regular
            time_regular = trial_os(ii_run & ~ii_exchange);
            run.('avatar_regular') = time_regular;
            
            % face/place
            ii_face  = logical([datafile.map.stations(datafile.data.avatar_instation).face]);
            time_face = trial_os(ii_run & ii_face);
            time_place = trial_os(ii_run & ~ii_face);
            run.('avatar_face') = time_face;
            run.('avatar_place') = time_place;
            
            % switch / no switch (in exchange stations)
            ii_diffline = logical([diff(datafile.data.avatar_insubline),0]);
            ii_stop = logical(datafile.data.exp_stoptrial);
            ii_switch = ii_exchange & ii_diffline & ~ii_stop;
            time_switch = trial_os(ii_run & ii_switch);
            time_noswitch = trial_os(ii_run & ~ii_switch);
            run.('avatar_switch') = time_switch;
            run.('avatar_noswitch') = time_noswitch;
            
            % forwards/backwards
            ii_start = datafile.data.exp_starttrial;
            ii_backwards = ii_diffline & ~ii_stop & ~ii_exchange & ~ii_start;
            time_forward   = trial_os(ii_run & ~ii_backwards);
            time_backwards = trial_os(ii_run &  ii_backwards);
            run.('avatar_forward'  ) = time_forward;
            run.('avatar_backwards') = time_backwards;
            
            % inertia/exertia
            ii_exertia = ii_diffline | ii_elbow | ii_switch | ii_backwards;
            time_inertia = trial_os(ii_run & ~ii_exertia);
            time_exertia = trial_os(ii_run &  ii_exertia);
            run.('avatar_inertia') = time_inertia;
            run.('avatar_exertia') = time_exertia;
            
            % achieved/bailout
            ii_togoal = (datafile.data.avatar_goalstation(ii_run & ii_stop)==datafile.data.resp_station(ii_run & ii_stop));
            time_achieved = run.screen_rew(ii_togoal(1:length(run.screen_rew)));
            time_bailout = run.screen_rew(~ii_togoal(1:length(run.screen_rew)));
            run.('avatar_achieved') = time_achieved;
            run.('avatar_bailout') = time_bailout;
            
            %% remove fields
            run = rmfield(run,'screen_blank');
            run = rmfield(run,'screen_blockpos');
            run = rmfield(run,'screen_blockpre');
            run = rmfield(run,'screen_breakpos');
            run = rmfield(run,'screen_breakpre');
            run = rmfield(run,'screen_breakwait');
            run = rmfield(run,'screen_clickpress');
            run = rmfield(run,'screen_clickrelease');
            run = rmfield(run,'screen_nan');
            run = rmfield(run,'screen_trialpress');
            run = rmfield(run,'screen_endblank');
            run = rmfield(run,'screen_endtext');
            run = rmfield(run,'screen_lottery');
            
            %% save run
            timeruns{end+1} = run;
        end
    end
end