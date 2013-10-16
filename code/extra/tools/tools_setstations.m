function [tmp_startstation,tmp_goalstation] = tools_setstations(dists,parameters,ptb,i_block,j_trial)

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