
function data = fix_data_expblock(data)
    % index
    ii_start        = find([1,diff(data.exp_break)]);
    ii_start(end+1) = length(data.exp_block)+1;
    
    % create vector
    exp_block = nan(size(data.exp_block));
    
    % numbers
    n_break = length(ii_start)-1;
    for i_break = 1:n_break
        ii_session = (ii_start(i_break):ii_start(i_break+1)-1);
        exp_block(ii_session) = data.exp_block(ii_session) - data.exp_block(ii_session(1)) + 1;
    end
        
    % set vector
    data.exp_block = exp_block;
end