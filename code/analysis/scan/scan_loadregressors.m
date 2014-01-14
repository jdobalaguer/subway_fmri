
function [timeruns,dataruns] = scan_loadregressors(session,u_lsdata)
    
    %% participant files
    % ls the 'data' folder
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
    
    %% load data
    if ~exist('u_lsdata','var')
        nb_lsdata = length(lsdata);
        u_lsdata = 1:nb_lsdata;
    end
    scans = {};
    for i_lsdata = u_lsdata
        file = [lspath,lsdata{i_lsdata}];
        data = load(file);
        fprintf('scan_loadregressors: loading datafile: %s\n',file);
        scans{end+1} = data;
    end
    
    %% generate regressors
    [timeruns,dataruns] = scan_generateregressors(scans);
    
    %% remove cancelled runs
    ii_remove = [];
    for i_runs = 1:length(timeruns)
        if length(timeruns{i_runs}.screen_block)<10
            fprintf('scan_loadregressors: removing run %d/%d from participant %s - %d block(s) \n',i_runs,length(timeruns),dataruns{i_runs}.participant.name,length(timeruns{i_runs}.screen_block));
            ii_remove(end+1) = i_runs;
        end
    end
    timeruns(ii_remove) = [];
    dataruns(ii_remove) = [];
    
end