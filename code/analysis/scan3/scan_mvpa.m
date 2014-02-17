function scan_mvpa(region,ii_sub)

    %% check
    % mvpa toolbox
    if ~exist('mvpa_add_paths','file')
        error('scan_mvpa: error. requires the mvpa toolbox, if it is unavailable this will not execute');
    else
        paths     = strsplit(path(),':');
        mvpa_path = [fileparts(which('mvpa_add_paths')),filesep(),'core'];
        if ~any(strcmp(mvpa_path,paths))
            mvpa_add_paths();
        end
    end

    % neural networking toolbox
    if ~exist('newff','file')
        fprintf('scan_mvpa: warning. requires the neural networking toolbox.\n');
    end

    %% set paths
    dir_study = sprintf('data/nii/');
    dir_subs  = dir([dir_study,'sub_*']); dir_subs = strcat(dir_study,strvcat(dir_subs.name),'/');
    dir_nii4 = sprintf('%sepi4/', dir_subs);
    fil_nii4 = cellstr(strcat(dir_nii4,spm_select('List',dir_nii4,'^images.*\.nii$')));
    nb_subs   = size(dir_subs,1);
    nb_runs   = 4;
    
    %% defaults
    if ~exist('ii_sub','var'); ii_sub = 1:nb_subs; end
    
    %% set parameters
    pars_TR   = 2;
    
    %% HRF
    fprintf('\n\n');
    fprintf('\nscan_mvpa: ***********************************************');
    fprintf('\nscan_mvpa: correlate HRF *********************************');
    for i_sub = ii_sub
        tools_getworkspace();
        scan_mvpa_hrf(tmp_workspace);
        clear('tmp_workspace');
    end
    
    %% MVPA
    fprintf('\n\n');
    fprintf('\nscan_mvpa: ***********************************************');
    fprintf('\nscan_mvpa: MVPA ******************************************');
    for i_sub = ii_sub
        tools_getworkspace();
        scan_mvpa_mvpa(tmp_workspace);
        clear('tmp_workspace');
    end

end


