
function [timefacs,datafacs] = scan_loadfactors(session)
    
    %% data
    % dir the 'data' folder
    lspath = ['data',filesep,'data',filesep,session,filesep];
    lsdata = dir([lspath,'data_sub_*']);
    lsdata = cellstr(strvcat(lsdata.name));
    i = 1;
    while i<=length(lsdata)
        if isempty(lsdata{i})
            lsdata(i) = [];
        else
            i = i+1;
        end
    end
    
    % load data
    nb_lsdata = length(lsdata);
    scans = cell(1,nb_lsdata);
    for i_lsdata = 1:nb_lsdata
        file = [lspath,lsdata{i_lsdata}];
        data = load(file);
        fprintf('scan_loadfactors: loading datafile: %s\n',file);
        scans{i_lsdata} = data;
    end
    
    %% generate factors (trial-based)
    
    % generate factors
    [timefacs,datafacs] = scan_generatefactors(scans);
    
    % remove cancelled runs
    ii_remove = [];
    for i_runs = 1:length(datafacs)
        if length(unique(datafacs{i_runs}.exp_block))<10
            fprintf('scan_loadfactors: removing run %d/%d\n',i_runs,length(datafacs));
            ii_remove(end+1) = i_runs;
        end
    end
    timefacs(ii_remove) = [];
    datafacs(ii_remove) = [];

end