

function data = load_data_ext(varargin)
    %% warnings
    %#ok<*BDSCI>
    
    %% defaults
    path   = 'scanner';
    forced = 0;
    if length(varargin) >= 1, path   = varargin{1}; end
    if length(varargin) >= 2, forced = varargin{2}; end
    
    %% preload
    path_dir = ['data',filesep(),'data',filesep(),path,filesep()];
    path_fil = [path_dir,'000_ext.mat'];
    if ~forced && exist(path_fil,'file') && ~isempty(who('-file',path_fil,'data'))
        loadfile = load(path_fil);
        data = loadfile.data;
        return;
    end
    
    %% load
    data  = load_data_rnm(path);
    maps  = load_maps(path);
    
    %% extend
    % empty
    
    %% sort
    data = struct_sort(data);
    
    %% save
    if exist(path_fil,'file')
        save(path_fil,'-append','data');
    else
        save(path_fil,'data');
    end
    
end