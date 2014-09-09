
% optimal behaviour (dependent on response, dependent on independent variables, dependent on response)
function data = rnm_data_fillin_optm_2(data,maps)
    %% distance to subgoal
    function dist = dist_station_subgoal(subject), ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(data.resp_station_subgoal); ii_dist    = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.steptimes_stations(data.resp_station_subgoal(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    data.optm_dist_station_subgoal = jb_applyvector(@dist_station_subgoal,data.expt_subject);
    function dist = dist_subline_subgoal(subject), ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(data.resp_station_subgoal); ii_dist    = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.exchanges_sublines(data.resp_station_subgoal(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    data.optm_dist_subline_subgoal = jb_applyvector(@dist_subline_subgoal,data.expt_subject);
    function dist = dist_euclide_subgoal(subject), ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(data.resp_station_subgoal); ii_dist    = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.euclidean(         data.resp_station_subgoal(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    data.optm_dist_euclide_subgoal = jb_applyvector(@dist_euclide_subgoal,data.expt_subject);
    
    %% distance to subelbow
    function dist = dist_station_subelbow(subject),  ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(data.resp_station_subelbow); ii_dist    = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.steptimes_stations(data.resp_station_subelbow(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    data.optm_dist_station_subelbow = jb_applyvector(@dist_station_subelbow,data.expt_subject);
    function dist = dist_subline_subelbow(subject),  ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(data.resp_station_subelbow); ii_dist    = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.exchanges_sublines(data.resp_station_subelbow(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    data.optm_dist_subline_subelbow = jb_applyvector(@dist_subline_subelbow,data.expt_subject);
    function dist = dist_euclide_subelbow(subject),  ii_subject = (data.expt_subject == subject); ii_notanan = ~isnan(data.resp_station_subelbow); ii_dist    = ii_notanan(ii_subject); dist = nan(1,sum(ii_subject)); dist(ii_dist) = diag(maps(subject).dists.euclidean(      data.resp_station_subelbow(ii_subject & ii_notanan),data.vbxi_station_in(ii_subject & ii_notanan))); end
    data.optm_dist_euclide_subelbow = jb_applyvector(@dist_euclide_subelbow,data.expt_subject);
    
    %% distance to boundary
    data.optm_dist_station_boundary = jb_applyvector( @(subject) diag(maps(subject).dists.steptimes_stations(data.resp_station_boundary(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),     ... function
        data.expt_subject);                                                                                                                                                                                                     ... categories
    data.optm_dist_subline_boundary = jb_applyvector( @(subject) diag(maps(subject).dists.exchanges_sublines(data.resp_station_boundary(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),     ... function
        data.expt_subject);                                                                                                                                                                                                     ... categories
    data.optm_dist_euclide_boundary = jb_applyvector( @(subject) diag(maps(subject).dists.euclidean(         data.resp_station_boundary(data.expt_subject == subject),data.vbxi_station_in(data.expt_subject == subject))),     ... function
        data.expt_subject);                                                                                                                                                                                                     ... categories
end
