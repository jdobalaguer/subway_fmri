
function data = load_data_rnm(path)
    %% load_data_rnm
    
    %% warnings
    
    %% function
    if ~exist('path','var'); path = 'scanner'; end

    % load
    data = load_data(path);
    maps = load_maps(path);
    
    % rename
    data = rnm_data_rename(data);           ... rename fields
    data = rnm_data_fillin(data,maps);      ... fill in missing fields
    
    % sort
    data = struct_sort(data);
end