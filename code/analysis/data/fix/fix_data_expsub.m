
function data = fix_data_expsub(data)
    % index
    ii_start = find((data.exp_break==1 & data.exp_block==1 & data.exp_trial==1));
    ii_start(end+1) = length(data.exp_sub)+1;
    
    % create vector
    exp_sub = nan(size(data.exp_sub));
    
    % numbers
    n_sub = length(ii_start)-1;
    for i_sub = 1:n_sub
        exp_sub(ii_start(i_sub):ii_start(i_sub+1)-1) = i_sub;
    end
        
    % set vector
    data.exp_sub = exp_sub;
end
