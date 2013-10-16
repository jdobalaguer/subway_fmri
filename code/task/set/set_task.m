end_of_task = 0;
if isempty(parameters.debug_preload)
    i_block = 0;
    j_trial = 0;
else
    i_block = max(data.exp_block);
    j_trial = length(data.exp_block);
end
