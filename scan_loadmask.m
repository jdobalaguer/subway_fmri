
function mask = scan_loadmask(region)

    %% check xjview
    if ~exist([fileparts(which('xjview.m')),filesep(),'TDdatabase.mat'],'file')
        error('scan_loadmask: error. xjview not found');
    end
    wholeMaskMNIAll = struct();
    DB = {};
    load('TDdatabase');
    
    %% abstraction level
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
    
    %% generate mask
    mask = (DB{region_floor}.mnilist==region_number);
    
    %% print regions
    function print_regions()
        for i = 1:length(DB)
            for j = 1:length(DB{i}.anatomy)
                fprintf('scan_loadmask: region "%s"\n',DB{i}.anatomy{j});
            end
        end
    end    
end
