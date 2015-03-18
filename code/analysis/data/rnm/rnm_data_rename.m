
function newdata = rnm_data_rename(olddata)

    newdata = struct();
    
    %% experiment
    
    % index
    newdata.('expt_subject')             = olddata.('exp_sub');
    newdata.('expt_session')             = olddata.('exp_break');
    newdata.('expt_block')               = olddata.('exp_block');
    newdata.('expt_index')               = olddata.('exp_jtrial');
    newdata.('expt_trial')               = olddata.('exp_trial');
    newdata.('expt_start')               = (newdata.expt_trial == 1 & newdata.expt_block == 1);
    newdata.('expt_end')                 = [newdata.expt_start(2:end),1];
    newdata.('expt_first')               = (newdata.expt_trial == 1);
    newdata.('expt_last')                = [newdata.expt_first(2:end),1];
    
    % trigger
    newdata.('expt_trigger') = [];
    
    %% independent variables
    
    % time
    newdata.('vbxi_getsecs')              = olddata.('time_trial');
    newdata.('vbxi_onset')                = [];
    newdata.('vbxi_scans')                = [];
    
    % trial
    newdata.('vbxi_reward')               = olddata.('avatar_reward');
    newdata.('vbxi_stop')                 = olddata.('avatar_stopprob');
    
    % station
    newdata.('vbxi_station_start')        = olddata.('avatar_startstation');
    newdata.('vbxi_station_goal')         = olddata.('avatar_goalstation');
    newdata.('vbxi_station_in')           = olddata.('avatar_instation');
    
    % exchange
    newdata.('vbxi_exchange_in')          = olddata.('avatar_inexchange');
    
    % elbow
    newdata.('vbxi_elbow_in')             = [];
    
    % regular
    newdata.('vbxi_regular_in')           = [];
    
    % subline
    newdata.('vbxi_subline_start')        = olddata.('avatar_startsubline');
    newdata.('vbxi_subline_in')           = olddata.('avatar_insubline');
    newdata.('vbxi_subline_goal')         = [];
    
    % position
    newdata.('vbxi_xposition_start')      = [];
    newdata.('vbxi_xposition_in')         = [];
    newdata.('vbxi_xposition_goal')       = [];
    newdata.('vbxi_yposition_start')      = [];
    newdata.('vbxi_yposition_in')         = [];
    newdata.('vbxi_yposition_goal')       = [];
    
    % direction
    newdata.('vbxi_direction_code')       = [];
    newdata.('vbxi_direction_west')       = [];
    newdata.('vbxi_direction_north')      = [];
    newdata.('vbxi_direction_south')      = [];
    newdata.('vbxi_direction_east')       = [];

    % options
    newdata.('vbxi_option_number')        = olddata.('resp_nboptions');
    newdata.('vbxi_option_station')       = olddata.('resp_optionsstations');
    newdata.('vbxi_option_subline')       = olddata.('resp_optionssublines');
    newdata.('vbxi_option_dist')          = olddata.('resp_optionsdists');
    
    %% optimal behaviour
    
    % distance
    newdata.('optm_dist_station_goal')    = olddata.('dists_steptimes_stations');
    newdata.('optm_dist_station_start')   = [];
    newdata.('optm_dist_station_journey') = [];
    newdata.('optm_dist_subline_goal')    = olddata.('dists_steptimes_sublines');
    newdata.('optm_dist_subline_start')   = [];
    newdata.('optm_dist_subline_journey') = [];
    newdata.('optm_dist_euclide_goal')    = olddata.('dists_euclidean');
    newdata.('optm_dist_euclide_start')   = [];
    newdata.('optm_dist_euclide_journey') = [];
    

    %% response
    
    % trial
    newdata.('resp_bool')                 = logical(olddata.('resp_bool'));
    newdata.('resp_correct')              = olddata.('resp_cor');
    
    % time
    newdata.('resp_getsecs')              = olddata.('resp_gs');
    newdata.('resp_onset')                = olddata.('resp_ts');
    newdata.('resp_scans')                = (newdata.resp_onset ./ 2);
    newdata.('resp_reactiontime')         = olddata.('resp_rt');
    
    % station
    newdata.('resp_station_to')           = olddata.('resp_station');
    newdata.('resp_station_same')         = (newdata.vbxi_station_in == newdata.resp_station_to);
    newdata.('resp_station_change')       = (~newdata.resp_station_same);
    
    % subline
    newdata.('resp_subline_to')           = olddata.('resp_subline');
    newdata.('resp_subline_same')         = (newdata.vbxi_subline_in == newdata.resp_subline_to);
    newdata.('resp_subline_change')       = (~newdata.resp_subline_same);
    
    % distance
    newdata.('resp_dist_station_start')   = []; %olddata.('avatar_time');
    newdata.('resp_dist_station_goal')    = [];
    newdata.('resp_dist_station_journey') = [];
    newdata.('resp_dist_station_diff')    = []; %(olddata.resp_dist - newdata.optm_dist_station_goal);

    newdata.('resp_dist_subline_start')   = [];
    newdata.('resp_dist_subline_goal')    = [];
    newdata.('resp_dist_subline_journey') = [];
    
    % position
    newdata.('resp_xposition_to')         = [];
    newdata.('resp_yposition_to')         = [];
    
    % direction
    newdata.('resp_direction_code')       = olddata.('resp_option');
    newdata.('resp_direction_west')       = (newdata.resp_direction_code == 1);
    newdata.('resp_direction_north')      = (newdata.resp_direction_code == 2);
    newdata.('resp_direction_south')      = (newdata.resp_direction_code == 3);
    newdata.('resp_direction_east')       = (newdata.resp_direction_code == 4);
    newdata.('resp_direction_back')       = [];
    newdata.('resp_direction_switch')     = [];
    
end