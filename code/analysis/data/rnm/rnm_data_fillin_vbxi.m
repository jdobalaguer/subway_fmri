    
% independant variables
function data = rnm_data_fillin_vbxi(data,maps)
    %% time
    data.vbxi_onset = data.vbxi_getsecs - data.expt_trigger;
    data.vbxi_scans = data.vbxi_onset ./ 2;
    
    %% elbow
    data.vbxi_elbow_in = jb_applyvector( ...
        @(subject) [maps(subject).stations(data.vbxi_station_in(data.expt_subject == subject)).elbow], ... function
        data.expt_subject);                                                                            ... categories
    
    %% regular
    data.vbxi_regular_in = (~data.vbxi_elbow_in & ~data.vbxi_exchange_in);
    
    %% subline
    data.vbxi_subline_goal = jb_applyvector( ...
        @(subject,session,block) jb_filter(unique(maps(subject).links(data.vbxi_station_goal(data.expt_subject == subject & data.expt_session == session & data.expt_block == block),:)),@(x)x>0),  ... function
        data.expt_subject, data.expt_session, data.expt_block);                                                                                                                                     ... categories
        
    %% face / place
    data.vbxi_face_start = jb_applyvector( ...
        @(subject) [maps(subject).stations(data.vbxi_station_start(data.expt_subject == subject)).face], ... function
        data.expt_subject);                                                                              ... categories
    data.vbxi_face_goal  = jb_applyvector( ...
        @(subject) [maps(subject).stations(data.vbxi_station_goal(data.expt_subject == subject)).face],  ... function
        data.expt_subject);                                                                              ... categories
    data.vbxi_face_in    = jb_applyvector( ...
        @(subject) [maps(subject).stations(data.vbxi_station_in(data.expt_subject == subject)).face],    ... function
        data.expt_subject);                                                                              ... categories
        
    data.vbxi_place_start = ~data.vbxi_face_start;
    data.vbxi_place_goal   = ~data.vbxi_face_goal;
    data.vbxi_place_in     = ~data.vbxi_face_in;
        
    %% position
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
end