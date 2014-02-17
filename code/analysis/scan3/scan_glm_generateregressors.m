
function [timeruns,dataruns] = scan_glm_generateregressors(datafiles)
    
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
        timerun_template = struct();
        u_screen = unique(datafile.time.screens);
        for i_screen = 1:length(u_screen)
            timerun_template.(['screen_',u_screen{i_screen}]) = [];
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
            timerun = timerun_template;
            % set index
            ii_trial = ii_break(i_break):(ii_break(i_break+1)-1);
            % set trial
            for i_trial = 1:length(ii_trial)
                timerun.(['screen_',datafile.time.screens{ii_trial(i_trial)}])(end+1) = datafile.time.offset(ii_trial(i_trial));
            end
            
            %% add trial data
            breakgs = datafile.time.breakgs(ii_break(i_break+1)-1);
            trial_gs = datafile.data.time_trial;
            trial_os = trial_gs - breakgs;
            ii_run = (datafile.data.exp_break==i_break);
            
            % all
            timerun.('avat_all') = trial_os(ii_run);
            
            % forwards / backwards
            ii_start     = datafile.data.exp_starttrial;
            ii_stop      = logical(datafile.data.exp_stoptrial);
            ii_forwline  = logical(datafile.data.resp_subline ==                     datafile.data.avatar_insubline) ;
            ii_backline  =        (datafile.data.resp_subline == tools_backwardsline(datafile.data.avatar_insubline));
            ii_backline(isnan(ii_backline)) = 0;
            ii_backline  = logical(ii_backline);
            ii_noline    = logical(~datafile.data.resp_bool);
            ii_noward    = ii_noline                   & ~ii_start;
            ii_forward   = ii_forwline  & ~ii_noline   & ~ii_start;
            ii_backward  = ii_backline                 & ~ii_start;
            ii_change    = ~ii_noline   & ~ii_forwline & ~ii_backline & ~ii_start;
            timerun.('avat1_noward')   = trial_os(ii_run & ii_noward);
            timerun.('avat1_forward')  = trial_os(ii_run & ii_forward);
            timerun.('avat1_backward') = trial_os(ii_run & ii_backward);
            timerun.('avat1_change')   = trial_os(ii_run & ii_change);
            timerun.('avat1_start')    = trial_os(ii_run & ii_start);
            
            % inertia/exertia
            ii_inertia = [0,(datafile.data.resp_keycode(1:end-1)==datafile.data.resp_keycode(2:end))];
            ii_inertia(isnan(ii_inertia)) = 0;
            ii_inertia =  ii_inertia & ~ii_start;
            ii_exertia = ~ii_inertia & ~ii_start;
            timerun.('avat2_inertia') = trial_os(ii_run & ii_inertia);
            timerun.('avat2_exertia') = trial_os(ii_run & ii_exertia);
            
            % exchange / elbow / regular / backward
            ii_exchange = logical([datafile.map.stations(datafile.data.avatar_instation).exchange]);
            ii_exchyes  = ~ii_noward & ~ii_backward & ii_exchange &  ii_change;
            ii_exchno   = ~ii_noward & ~ii_backward & ii_exchange & ~ii_change;
            ii_elbow    = ~ii_noward & ~ii_backward & logical([datafile.map.stations(datafile.data.avatar_instation).elbow]);
            ii_regular  = ~ii_noward & ~ii_backward & ~ii_exchange & ~ii_elbow;
            timerun.('avat3_exchyes')  = trial_os(ii_run & ii_exchyes);
            timerun.('avat3_exchno')   = trial_os(ii_run & ii_exchno);
            timerun.('avat3_elbow')    = trial_os(ii_run & ii_elbow);
            timerun.('avat3_regular')  = trial_os(ii_run & ii_regular);
            timerun.('avat3_backward') = trial_os(ii_run & ii_backward);
            timerun.('avat3_noward')   = trial_os(ii_run & ii_noward);
            
            % exchange / elbow / else
            ii_else = ~ii_exchange & ~ii_elbow;
            timerun.('avat4_exchyes')  = trial_os(ii_run & ii_exchyes);
            timerun.('avat4_exchno')   = trial_os(ii_run & ii_exchno);
            timerun.('avat4_elbow')    = trial_os(ii_run & ii_elbow);
            timerun.('avat4_else')     = trial_os(ii_run & ii_else);
            
            % face/place
            ii_face  =  logical([datafile.map.stations(datafile.data.avatar_instation).face]);
            ii_place = ~logical([datafile.map.stations(datafile.data.avatar_instation).face]);
            timerun.('avat5_face')  = trial_os(ii_run & ii_face);
            timerun.('avat5_place') = trial_os(ii_run & ii_place);
           
            % reward
            ii_lowrew     = (datafile.data.avatar_reward==1);
            ii_highrew    = (datafile.data.avatar_reward==5);
            timerun.('avat6_lowrew' ) = trial_os(ii_run & ii_lowrew);
            timerun.('avat6_highrew') = trial_os(ii_run & ii_highrew);
            
            % line
            ii_line1 = (datafile.data.avatar_insubline == 1) | (datafile.data.avatar_insubline == 2);
            ii_line3 = (datafile.data.avatar_insubline == 3) | (datafile.data.avatar_insubline == 4);
            ii_line5 = (datafile.data.avatar_insubline == 5) | (datafile.data.avatar_insubline == 6);
            ii_line7 = (datafile.data.avatar_insubline == 6) | (datafile.data.avatar_insubline == 8);
            timerun.('avat7_line1' ) = trial_os(ii_run & ii_line1);
            timerun.('avat7_line3' ) = trial_os(ii_run & ii_line3);
            timerun.('avat7_line5' ) = trial_os(ii_run & ii_line5);
            timerun.('avat7_line7' ) = trial_os(ii_run & ii_line7);
            
            %% add feedback data
            % achieved/bailout
            ii_togoal = (datafile.data.avatar_goalstation(ii_run & ii_stop)==datafile.data.resp_station(ii_run & ii_stop));
            timerun.('feed_achieved') = timerun.screen_rew( ii_togoal(1:length(timerun.screen_rew)));
            timerun.('feed_bailout')  = timerun.screen_rew(~ii_togoal(1:length(timerun.screen_rew)));
            
            %% remove fields
            timerun = rmfield(timerun,'screen_blank');
            timerun = rmfield(timerun,'screen_blockpos');
            timerun = rmfield(timerun,'screen_blockpre');
            timerun = rmfield(timerun,'screen_breakpos');
            timerun = rmfield(timerun,'screen_breakpre');
            timerun = rmfield(timerun,'screen_breakwait');
            timerun = rmfield(timerun,'screen_clickpress');
            timerun = rmfield(timerun,'screen_clickrelease');
            timerun = rmfield(timerun,'screen_nan');
            timerun = rmfield(timerun,'screen_trialpress');
            try     timerun = rmfield(timerun,'screen_endblank');
                    timerun = rmfield(timerun,'screen_endtext');
                    timerun = rmfield(timerun,'screen_lottery');
            end
            
            %% save run
            timeruns{end+1} = timerun;
        end
    end
end