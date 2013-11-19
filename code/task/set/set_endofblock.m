
% bailing out
if map.avatar.stopprob > rand()
    end_of_block = 1;
end

% goal reached
if resp.station==map.avatar.to_station
    end_of_block = 1;
end
