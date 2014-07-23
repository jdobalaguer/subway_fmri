
function data = ext_data_main(data,maps)
    % numbers
    u_par     = unique(data.exp_sub);
    nb_pars   = length(u_par);
    
    % initialise
    data.('avatar_exchyes' )        = [];
    data.('avatar_exchno'  )        = [];
    data.('avatar_elbow'   )        = [];
    data.('avatar_regular' )        = [];
    data.('avatar_forward' )        = [];
    data.('avatar_backward')        = [];
    data.('avatar_noward'  )        = [];
    data.('avatar_exchyes_exchno')  = [];
    data.('avatar_exchyes_elbow')   = [];
    data.('avatar_exchange')        = [];
    data.('avatar_noexchange')      = [];
    data.('avatar_switch'  )        = [];
    data.('avatar_noswitch')        = [];
    data.('avatar_exch_noexch')     = [];
    data.('avatar_switch_nosw')     = [];
    data.('dists_inv_goalsteps')    = [];
    data.('avatar_subgoal')         = [];
    data.('dists_inv_substeps')     = [];
    data.('dists_inv_substeps')     = [];
    data.('avatar_hilorew' )        = [];
    data.('inter_rew_dinvgoal')     = [];
    data.('inter_rew_dinvsub' )     = [];
    data.('inter_yesno_yelb')       = [];
    data.('inter_exchnoexch_switchnosw') = [];
    
    for i_par = 1:nb_pars
        map          = maps(i_par);
        ii_par       = logical(data.exp_sub == u_par(i_par));
        f_par        = find(ii_par);
        u_block   = unique(data.exp_block(ii_par));
        nb_blocks = length(u_block);
        
        % indices
        ii_start     = logical(data.exp_starttrial(ii_par));
        ii_stop      = logical(data.exp_stoptrial(ii_par));
        ii_forwline  = logical(data.resp_subline(ii_par) ==                     data.avatar_insubline(ii_par)) ;
        ii_backline  =        (data.resp_subline(ii_par) == tools_backwardsline(data.avatar_insubline(ii_par)));
            ii_backline(isnan(ii_backline)) = 0;
            ii_backline  = logical(ii_backline);
        ii_noline    = logical(~data.resp_bool(ii_par));
        ii_noward    = logical(ii_noline                   & ~ii_start);
        ii_forward   = logical(ii_forwline  & ~ii_noline   & ~ii_start);
        ii_backward  = logical(ii_backline                 & ~ii_start);
        ii_change    = logical(~ii_noline   & ~ii_forwline & ~ii_backline & ~ii_start);
        ii_inertia = [0,(data.resp_keycode(f_par(1:end-1))==data.resp_keycode(f_par(2:end)))];
            ii_inertia(isnan(ii_inertia)) = 0;
            ii_inertia  =  logical(ii_inertia & ~ii_start);
        ii_exertia  =  logical(~ii_inertia & ~ii_start);
        ii_exchange =  logical([map.stations(data.avatar_instation(ii_par)).exchange]);
        ii_exchyes  =  logical(~ii_noward & ~ii_backward & ii_exchange &  ii_change);
        ii_exchno   =  logical(~ii_noward & ~ii_backward & ii_exchange & ~ii_change);
        ii_elbow    =  logical(~ii_noward & ~ii_backward & logical([map.stations(data.avatar_instation(ii_par)).elbow]));
        ii_regular  =  logical(~ii_noward & ~ii_backward & ~ii_exchange & ~ii_elbow);
        ii_lowrew   =  logical(data.avatar_reward(ii_par)==1);
        ii_highrew  =  logical(data.avatar_reward(ii_par)==5);
        % types of station & action
        data.('avatar_exchyes' )(ii_par) = ii_exchyes;
        data.('avatar_exchno'  )(ii_par) = ii_exchno;
        data.('avatar_elbow'   )(ii_par) = ii_elbow;
        data.('avatar_regular' )(ii_par) = ii_regular;
        data.('avatar_forward' )(ii_par) = ii_forward;
        data.('avatar_backward')(ii_par) = ii_backward;
        data.('avatar_noward'  )(ii_par) = ii_noward;
        % more general
        data.('avatar_exchyes_exchno')(ii_par) = double(ii_exchyes) - double(ii_exchno);
        data.('avatar_exchyes_elbow' )(ii_par) = double(ii_exchyes) - double(ii_elbow);
        data.('avatar_exchange'      )(ii_par) = ii_exchyes | ii_exchno;
        data.('avatar_noexchange'    )(ii_par) = ii_elbow   | ii_regular;
        data.('avatar_switch'        )(ii_par) = ii_exchyes | ii_elbow;
        data.('avatar_noswitch'      )(ii_par) = ii_exchno  | ii_regular;
        data.('avatar_exch_noexch'   )(ii_par) = double(data.avatar_exchange(ii_par)) - double(data.avatar_noexchange(ii_par));
        data.('avatar_switch_nosw'   )(ii_par) = double(data.avatar_switch(ii_par))   - double(data.avatar_noswitch(ii_par));

        % inverse goal distance
        data.('dists_inv_goalsteps')(ii_par) = 1./data.dists_steptimes_stations(ii_par);
        % subgoal 
        data.avatar_subgoal(ii_par) = nan(1,length(data.exp_block(ii_par)));
        for i_block = 1:nb_blocks
            ii_block = (data.exp_block(f_par)==u_block(i_block));
            goal_station = unique(data.avatar_goalstation(f_par(ii_block)));
            assert(length(goal_station)==1);
            subgoal_station  = [nan, ...
                                data.avatar_instation(f_par(ii_block & ii_exchyes)), ...
                                goal_station];
            f_bexch  = [f_par(find(ii_block,1,'first'))   , ...
                        f_par(     ii_block & ii_exchyes), ...
                        f_par(find(ii_block,1,'last'))        ];
            for i_bexch = 2:length(subgoal_station)
                ii_bexch = f_bexch(i_bexch-1):f_bexch(i_bexch);
                data.avatar_subgoal(ii_bexch) = subgoal_station(i_bexch);
            end
        end
        % subgoal distance
        data.('dists_inv_substeps')(ii_par) = 1./ map.dists.steptimes_stations(...
                                                sub2ind(size(map.dists.steptimes_stations), ...
                                                        data.avatar_instation(ii_par),data.avatar_subgoal(ii_par) ...
                                                ) ...
                                        );
        data.('dists_inv_substeps')(isinf(data.dists_inv_substeps)) = 0; % when noward, backward, etc..
        % reward
        data.('avatar_hilorew' )(ii_par) = double(ii_highrew)-double(ii_lowrew);
        % interactions
        data.('inter_rew_dinvgoal')(ii_par) = double(data.dists_inv_goalsteps(ii_par))          .* double(data.avatar_reward(ii_par));
        data.('inter_rew_dinvsub' )(ii_par) = double(data.dists_inv_substeps(ii_par))           .* double(data.avatar_reward(ii_par));
        data.('inter_yesno_yelb')(ii_par)   = double(data.avatar_exchyes_exchno(ii_par))        .* double(data.avatar_exchyes_elbow(ii_par));
        data.('inter_exchnoexch_switchnosw')(ii_par)  = double(data.avatar_exch_noexch(ii_par)) .* double(data.avatar_switch_nosw(ii_par));

    end
end