function [tmp_startstation,tmp_goalstation] = tools_setstations(dists,map,parameters,participant,ptb,i_block,j_trial,do_quiz)
    
    if do_quiz
        sel = parameters.flag_quizsel;
    else
        sel = parameters.flag_tasksel;
    end
    
    switch(sel)
        case 'rand'
            %% random selection
            tmp_startstation = randi(size(dists,1));
            tmp_goalstation  = tmp_startstation;
            while (tmp_goalstation == tmp_startstation)
                tmp_goalstation  = randi(size(dists,2));
            end
        case 'home'
            %% start from home
            if do_quiz
                error('error. ''home'' selection in quiz mode');
            end
            tmp_startstation  = participant.homestation;
            tmp_goalstation  = tmp_startstation;
            while (tmp_goalstation == tmp_startstation)
                tmp_goalstation  = randi(size(dists,2));
            end
        case 'oneorone'
            %% one elbow (or more) or (not exclusive) one (exact) exchange
            ok = 0;
            while ~ok
                % set random regular stations
                tmp_startstation = 0;
                tmp_goalstation  = 0;
                while tmp_startstation==tmp_goalstation
                    tmp_startstation = randi(size(dists,1));
                    while ( map.stations(tmp_startstation).exchange || ...
                            map.stations(tmp_startstation).ending   || ...
                            map.stations(tmp_startstation).elbow    );
                                tmp_startstation = randi(size(dists,1));
                    end
                    tmp_goalstation = randi(size(dists,2));
                    while ( map.stations(tmp_goalstation).exchange || ...
                            map.stations(tmp_goalstation).ending   || ...
                            map.stations(tmp_goalstation).elbow    );
                                tmp_goalstation = randi(size(dists,2));
                    end
                end
                
                % calculate values
                tmp_steps     = map.dists.steptimes_stations(tmp_startstation,tmp_goalstation);
                tmp_exchanges = map.dists.steptimes_sublines(tmp_startstation,tmp_goalstation);
                tmp_elbows    = map.dists.steptimes_elbows(tmp_startstation,tmp_goalstation);
                
                % criterium
                if tmp_steps<12 && tmp_steps>4
                    if tmp_exchanges==1;                ok=1; end
                    if tmp_elbows==1 && ~tmp_exchanges; ok=1; end
                end
            end
        case 'incr'
            %% increasing difficulty
            % tmp variables
            nb_stations       = size(dists,1);
            tmp_startstations = ones(nb_stations,1)*(1:nb_stations);
            tmp_goalstations  = tmp_startstations';
            tmp_dists         = dists(:);
            tmp_mindist       = min(tmp_dists);
            tmp_maxdist       = max(tmp_dists);

            % alpha index (proportion to endoftask)
            tmp_alpha = [];
            if parameters.run_by_min
                tmp_gs = GetSecs - ptb.time_start;
                tmp_gm = tmp_gs/60;
                tmp_alpha(end+1) = tmp_gm/parameters.run_min;
            end
            if parameters.run_by_blocks
                tmp_alpha(end+1) = i_block/parameters.run_blocks;
            end
            if parameters.run_by_trials
                tmp_alpha(end+1) = j_trial/parameters.run_trials;
            end
            tmp_alpha = max(tmp_alpha);

            % slope
            if tmp_alpha<0.5
                tmp_slope = 1./(1-tmp_alpha);
            else
                tmp_slope = 1./(tmp_alpha-0);
            end

            % zeta values, gamma values
            tmp_zeta  = (tmp_dists-tmp_mindist)./(tmp_maxdist-tmp_mindist);
            tmp_gamma = 1 - tmp_slope * abs(tmp_zeta - tmp_alpha);

            % normalize gamma values (by frequency)
            tmp_ngamma = tmp_gamma;
            for zeta = unique(tmp_zeta(:))'
                ii = (tmp_zeta==zeta);
                tmp_ngamma(ii) = tmp_gamma(ii) ./ sum(ii);
            end

            % softmax selection
            tmp_startstation = 0;
            tmp_goalstation = 0;
            while tmp_startstation==tmp_goalstation
                i_gamma = tools_randsel(tmp_ngamma);
                tmp_startstation = tmp_startstations(i_gamma);
                tmp_goalstation  = tmp_goalstations(i_gamma);
            end
    end
end