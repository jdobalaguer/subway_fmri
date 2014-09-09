
% optimal behaviour
function data = rnm_data_fillin_optm(data,maps)
    %% distance
    data.optm_dist_station_start    = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.steptimes_stations(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),  ... function
        data.expt_subject);                                                                                                                                                 ... categories
    data.optm_dist_station_journey  = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.steptimes_stations(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_goal(data.expt_subject == subject))),... function
        data.expt_subject);                                                                                                                                                 ... categories
        
    data.optm_dist_subline_start    = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.exchanges_sublines(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),  ... function
        data.expt_subject);                                                                                                                                                 ... categories
    data.optm_dist_subline_journey  = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.exchanges_sublines(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_goal(data.expt_subject == subject))),... function
        data.expt_subject);                                                                                                                                                 ... categories
        
    data.optm_dist_euclide_start    = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.euclidean(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),           ... function
        data.expt_subject);                                                                                                                                                 ... categories
    data.optm_dist_euclide_journey  = jb_applyvector( ...
        @(subject) diag(maps(subject).dists.euclidean(data.vbxi_station_start(data.expt_subject == subject),data.vbxi_station_goal(data.expt_subject == subject))),         ... function
        data.expt_subject);                                                                                                                                                 ... categories
end
