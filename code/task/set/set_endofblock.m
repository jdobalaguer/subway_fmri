
% probability of stopping (after optimal distance)
% (is inversely proportional to the distance of the optimal journey)
optnb_trials = map.dists.steptimes_stations(map.avatar.to_station,map.avatar.start_station);
if i_trial > optnb_trials
    stop_prob = power(optnb_trials,-parameters.stop_power);
else
    stop_prob = 0;
end

% stop?
if parameters.flag_stopprob && rand < stop_prob
    end_of_block = 1;
end

% goal reached?
if resp.station==map.avatar.to_station
    end_of_block = 1;
end
