
function mask = scan_loadmask(regions)

    %% check xjview
    if ~exist([fileparts(which('xjview.m')),filesep(),'TDdatabase.mat'],'file')
        error('scan_loadmask: error. xjview not found');
    end
    
    %% load xjview
    wholeMaskMNIAll = struct();
    DB = {};
    load('TDdatabase');
    
    %% defaults
    if ~exist('regions','var'); print_regions(); return; end
    if ~iscell(regions)
        regions = {regions};
    end
    
    %% generate masks
    mask = load_mask(regions{1});
    for i_region = 2:length(regions)
        mask = mask | load_mask(regions{i_region});
    end
    
    %% functions
    % find region
    function mask = load_mask(region)
        region_floor  = 0;
        region_number = 0;
        for i_DB = 1:length(DB)
            tmp_strcmp = strcmp(region,DB{i_DB}.anatomy);
            if any(tmp_strcmp)
                region_floor  = i_DB;
                region_number = find(tmp_strcmp);
                break;
            end
        end
        if ~region_floor
            print_regions();
            error('scan_loadmask: error. region "%s" not found',region);
        end
        mask = (DB{region_floor}.mnilist==region_number);
    end
    
    % print regions
    function print_regions()
        for i = 1:length(DB)
            for j = 1:length(DB{i}.anatomy)
                if ~isempty(DB{i}.anatomy{j})
                    fprintf('scan_loadmask: region "%s"\n',DB{i}.anatomy{j});
                end
            end
        end
    end    
end
