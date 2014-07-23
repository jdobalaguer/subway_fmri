
function data = scan3_glm_adddata(data,map)
    % numbers
    u_block      = unique(data.exp_block);
    nb_blocks    = length(u_block);
    % indices
    ii_start     = logical(data.exp_starttrial);
    ii_stop      = logical(data.exp_stoptrial);
    ii_forwline  = logical(data.resp_subline ==                     data.avatar_insubline) ;
    ii_backline  =        (data.resp_subline == tools_backwardsline(data.avatar_insubline));
        ii_backline(isnan(ii_backline)) = 0;
        ii_backline  = logical(ii_backline);
    ii_noline    = logical(~data.resp_bool);
    ii_noward    = logical(ii_noline                   & ~ii_start);
    ii_forward   = logical(ii_forwline  & ~ii_noline   & ~ii_start);
    ii_backward  = logical(ii_backline                 & ~ii_start);
    ii_change    = logical(~ii_noline   & ~ii_forwline & ~ii_backline & ~ii_start);
    ii_inertia = [0,(data.resp_keycode(1:end-1)==data.resp_keycode(2:end))];
        ii_inertia(isnan(ii_inertia)) = 0;
        ii_inertia  =  logical(ii_inertia & ~ii_start);
    ii_exertia  =  logical(~ii_inertia & ~ii_start);
    ii_exchange =  logical([map.stations(data.avatar_instation).exchange]);
    ii_exchyes  =  logical(~ii_noward & ~ii_backward & ii_exchange &  ii_change);
    ii_exchno   =  logical(~ii_noward & ~ii_backward & ii_exchange & ~ii_change);
    ii_elbow    =  logical(~ii_noward & ~ii_backward & logical([map.stations(data.avatar_instation).elbow]));
    ii_regular  =  logical(~ii_noward & ~ii_backward & ~ii_exchange & ~ii_elbow);
    %ii_face     =  logical([map.stations(data.avatar_instation).face]);
    ii_place    = ~logical([map.stations(data.avatar_instation).face]);
    ii_lowrew   =  logical(data.avatar_reward==1);
    ii_highrew  =  logical(data.avatar_reward==5);
    % face and place
    %data.('avatar_faplace' ) = double(ii_face)-double(ii_place);
    % types of station & action
    data.('avatar_exchyes' ) = ii_exchyes;
    data.('avatar_exchno'  ) = ii_exchno;
    data.('avatar_elbow'   ) = ii_elbow;
    data.('avatar_regular' ) = ii_regular;
    data.('avatar_forward' ) = ii_forward;
    data.('avatar_backward') = ii_backward;
    data.('avatar_noward'  ) = ii_noward;
    % more general
    data.('avatar_exchyes_exchno')= double(ii_exchyes) - double(ii_exchno);
    data.('avatar_exchyes_elbow') = double(ii_exchyes) - double(ii_elbow);
    data.('avatar_exchange')      = ii_exchyes | ii_exchno;
    data.('avatar_noexchange')    = ii_elbow   | ii_regular;
    data.('avatar_switch'  )      = ii_exchyes | ii_elbow;
    data.('avatar_noswitch')      = ii_exchno  | ii_regular;
    data.('avatar_exch_noexch')   = double(data.avatar_exchange) - double(data.avatar_noexchange);
    data.('avatar_switch_nosw')   = double(data.avatar_switch)   - double(data.avatar_noswitch);
    
    % inverse goal distance
    data.('dists_inv_goalsteps') = 1./data.dists_steptimes_stations;
    % subgoal 
    data.avatar_subgoal = nan(1,length(data.exp_block));
    for i_block = 1:nb_blocks
        ii_block = (data.exp_block==u_block(i_block));
        goal_station = unique(data.avatar_goalstation(ii_block));
        assert(length(goal_station)==1);
        subgoal_station  = [nan, ...
                            data.avatar_instation(ii_block & ii_exchyes), ...
                            goal_station];
        f_bexch  = [find(ii_block,1,'first')   , ...
                    find(ii_block & ii_exchyes), ...
                    find(ii_block,1,'last')        ];
        for i_bexch = 2:length(subgoal_station)
            ii_bexch = f_bexch(i_bexch-1):f_bexch(i_bexch);
            data.avatar_subgoal(ii_bexch) = subgoal_station(i_bexch);
        end
    end
    % subgoal distance
    data.('dists_inv_substeps') = 1./ map.dists.steptimes_stations(...
                                            sub2ind(size(map.dists.steptimes_stations), ...
                                                    data.avatar_instation,data.avatar_subgoal ...
                                            ) ...
                                    );
    data.('dists_inv_substeps')(isinf(data.dists_inv_substeps)) = 0; % when noward, backward, etc..
    % reward
    data.('avatar_hilorew' ) = double(ii_highrew)-double(ii_lowrew);
    % interactions
    data.('inter_rew_dinvgoal') = double(data.dists_inv_goalsteps)   .* double(data.avatar_reward);
    data.('inter_rew_dinvsub' ) = double(data.dists_inv_substeps)    .* double(data.avatar_reward);
    data.('inter_yesno_yelb')   = double(data.avatar_exchyes_exchno) .* double(data.avatar_exchyes_elbow);
    data.('inter_exchnoexch_switchnosw')  = double(data.avatar_exch_noexch) .* double(data.avatar_switch_nosw);

end
