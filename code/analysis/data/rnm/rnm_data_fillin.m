
function data = rnm_data_fillin(data,maps)
    %% numbers
    [u_subject,n_subject] = numbers(data.expt_subject);
    
    %% experiment
    
    % expt_trigger
    data.expt_trigger(data.resp_bool) = (data.resp_getsecs(data.resp_bool) - data.resp_onset(data.resp_bool));
    for ii_trigger = find(~data.resp_bool)
        ii_subject = (data.expt_subject == data.expt_subject(ii_trigger));
        ii_session = (data.expt_session == data.expt_session(ii_trigger));
        ii_notanan = (data.resp_bool);
        assert(numel(unique(data.expt_trigger(ii_subject & ii_session & ii_notanan)))==1, 'rnm_data_fillin: error. expt_trigger');
        data.expt_trigger(ii_trigger) = unique(data.expt_trigger(ii_subject & ii_session & ii_notanan));
    end
    
    %% independant variables
    
    % time
    data.vbxi_onset = data.vbxi_getsecs - data.expt_trigger;
    data.vbxi_scans = data.vbxi_onset ./ 2;
    
    % elbow
    data.vbxi_elbow_in = jb_applyvector( ...
        @(subject) [maps(subject).stations(data.vbxi_station_in(data.expt_subject == subject)).elbow], ... function
        data.expt_subject);                                                                            ... categories
    
    % regular
    data.vbxi_regular_in = (~data.vbxi_elbow_in & ~data.vbxi_exchange_in);
    
    % subline
    data.vbxi_subline_goal = jb_applyvector( ...
        @(subject,session,block) jb_filter(unique(maps(subject).links(data.vbxi_station_goal(data.expt_subject == subject & data.expt_session == session & data.expt_block == block),:)),@(x)x>0),  ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                                                                                     ... categories
        
    % position
    data.vbxi_xposition_start = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.vbxi_station_start(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(1)),... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    data.vbxi_xposition_in = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.vbxi_station_in(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(1)),   ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    data.vbxi_xposition_goal = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.vbxi_station_goal(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(1)), ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories

    data.vbxi_yposition_start = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.vbxi_station_start(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(2)),... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    data.vbxi_yposition_in = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.vbxi_station_in(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(2)),   ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    data.vbxi_yposition_goal = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.vbxi_station_goal(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(2)), ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    
    %% optimal behaviour
    
    % distance
    data.optm_dist_station_start    = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.steptimes_stations(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),  ... function
        data.expt_subject);                                                                                                                                                 ... categories
    data.optm_dist_station_journey  = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.steptimes_stations(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_goal(data.expt_subject == subject))),... function
        data.expt_subject);                                                                                                                                                 ... categories
        
    data.optm_dist_subline_start    = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.steptimes_sublines(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),  ... function
        data.expt_subject);                                                                                                                                                 ... categories
    data.optm_dist_subline_journey  = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.steptimes_sublines(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_goal(data.expt_subject == subject))),... function
        data.expt_subject);                                                                                                                                                 ... categories
        
    data.optm_dist_euclide_start    = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.euclidean(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),           ... function
        data.expt_subject);                                                                                                                                                 ... categories
    data.optm_dist_euclide_journey  = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.euclidean(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_goal(data.expt_subject == subject))),         ... function
        data.expt_subject);                                                                                                                                                 ... categories
    
    %% response
    
    % distance
    data.resp_dist_station_goal = jb_applyvector( ...
        @(subject,session,block,trial) sum(data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial >= trial),  ... function
        data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);                                                                                ... categories
    data.resp_dist_station_journey = jb_applyvector( ...
        @(subject,session,block,trial) sum(data.expt_subject == subject & data.expt_session == session & data.expt_block == block), ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                     ... categories
        
    data.resp_dist_subline_start = jb_applyvector( ...
        @(subject,session,block,trial) length(unique(data.vbxi_subline_in(data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial <= trial)))-1,   ... function
        data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);                                                                                ... categories
    data.resp_dist_subline_goal = jb_applyvector( ...
        @(subject,session,block,trial) length(unique(data.vbxi_subline_in(data.expt_subject == subject & data.expt_session == session & data.expt_block == block & data.expt_trial >= trial)))-1,   ... function
        data.expt_subject, data.expt_session, data.expt_block, data.expt_trial);                                                                                ... categories
    data.resp_dist_subline_journey = jb_applyvector( ...
        @(subject,session,block,trial) length(unique(data.vbxi_subline_in(data.expt_subject == subject & data.expt_session == session & data.expt_block == block)))-1,  ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                                                         ... categories
        
    % position
    data.resp_xposition_to = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.resp_station_to(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(1)),   ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    data.resp_yposition_to = jb_applyvector(...
        @(subject,session,block,trial) (maps(subject).stations(data.resp_station_to(data.expt_subject==subject & data.expt_session==session & data.expt_block==block & data.expt_trial==trial)).position(2)),   ... function
        data.expt_subject,data.expt_session,data.expt_block,data.expt_trial);                                                                                                                                   ... categories
    
    %% independant variables (dependent on response)
    
    % direction
    data.vbxi_direction_code = [0,data.resp_direction_code(1:end-1)] .* double(~data.expt_first);
    while any(isnan(data.vbxi_direction_code))
        ii_nan = find(isnan(data.vbxi_direction_code),1,'first');
        data.vbxi_direction_code(ii_nan) = data.vbxi_direction_code(ii_nan-1);
    end
    data.vbxi_direction_west  = (data.vbxi_direction_code == 1);
    data.vbxi_direction_north = (data.vbxi_direction_code == 2);
    data.vbxi_direction_south = (data.vbxi_direction_code == 3);
    data.vbxi_direction_east  = (data.vbxi_direction_code == 4);
    
    %% response
    
    % direction
    data.resp_direction_code(isnan(data.resp_direction_code)) = 0;
    data.resp_direction_back   = (  (data.vbxi_direction_code == 1 & data.resp_direction_code == 4) | ...
                                    (data.vbxi_direction_code == 2 & data.resp_direction_code == 3) | ...
                                    (data.vbxi_direction_code == 3 & data.resp_direction_code == 2) | ...
                                    (data.vbxi_direction_code == 4 & data.resp_direction_code == 1)   ...
                                );
    data.resp_direction_switch = (data.vbxi_direction_code ~= data.resp_direction_code) & data.vbxi_direction_code & data.resp_direction_code & ~data.resp_direction_back;
    
end
