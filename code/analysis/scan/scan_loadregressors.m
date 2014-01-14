
function [timeregs,dataregs] = scan_loadregressors(session)
    
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
        fprintf('scan_loadregressors: loading datafile: %s\n',file);
        scans{i_lsdata} = data;
    end
    
    %% generate regressors (screen-based)
    
    % generate regressors 
    [timeregs,dataregs] = scan_generateregressors(scans);
    
    % remove cancelled runs
    ii_remove = [];
    for i_runs = 1:length(timeregs)
        if length(timeregs{i_runs}.screen_block)<10
            fprintf('scan_loadregressors: removing run %d/%d\n',i_runs,length(timeregs));
            ii_remove(end+1) = i_runs;
        end
    end
    timeregs(ii_remove) = [];
    dataregs(ii_remove) = [];
    
end