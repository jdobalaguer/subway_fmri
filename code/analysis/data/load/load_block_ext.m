

function block = load_block_ext(varargin)
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
    if ~forced && exist(path_fil,'file') && ~isempty(who('-file',path_fil,'block'))
        loadfile = load(path_fil);
        block = loadfile.block;
        return;
    end
    
    %% load
    block  = load_block(path);
    
    
    %% extend
    % empty
    
    %% sort
    block = struct_sort(block);
    block = struct_transpose(block);
    
    %% save
    if exist(path_fil,'file')
        save(path_fil,'-append','block');
    else
        save(path_fil,'block');
    end
    
end