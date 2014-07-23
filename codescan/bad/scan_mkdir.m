
function scan_mkdir(paths)
    for i_sub = 1:length(paths.subs)
        % epi3
        path_epi3 = [paths.nii,paths.subs{i_sub},'/',paths.epi3];
        if ~exist(path_epi3,'dir'); mkdir(path_epi3); end
        for i_run = 1:4
            % run
            path_run = [path_epi3,sprintf(paths.run,i_run)];
            if ~exist(path_run,'dir'); mkdir(path_run); end
            % images
            path_images     = [path_run,paths.images];
            if ~exist(path_images,'dir'); mkdir(path_images); end
            % realigned
            path_realigned  = [path_run,paths.realigned];
            if ~exist(path_realigned,'dir'); mkdir(path_realigned); end
            % smooth
            path_smooth     = [path_run,paths.smooth];
            if ~exist(path_smooth,'dir'); mkdir(path_smooth); end
        end
    end
end
