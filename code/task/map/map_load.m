if ~isempty(parameters.debug_preload); return; end

% check for the files directory
if ~exist('files','dir')
    error('map_load: error. no ''files'' directory.');
end
% check for the files directory
if ~exist('donefiles','dir')
    mkdir('donefiles');
end

% preload map
if parameters.debug_mapload
    if ~exist(['donefiles',   filesep,    'allmap_',participant.name,'.mat'],'file')
        error('map_load: error. map does not exists');
    else
        load(['donefiles',   filesep,    'allmap_',participant.name,'.mat'],'map');
    end
    % resize
    map_resize;
    return;
end

% ls the 'data' folder
if ispc
    tmp_lsfiles = dir('files');
    lsfiles = {};
    for i = 1:length(tmp_lsfiles)
        if ~(tmp_lsfiles(i).name(1)=='.')
            lsfiles{end+1} = tmp_lsfiles(i).name;
        end
    end
    nb_lsfiles = length(lsfiles);
else
    lsfiles = regexp(ls('files'),'\s','split');
    i = 1;
    while i<=length(lsfiles)
        if isempty(lsfiles{i})
            lsfiles(i) = [];
        else
            i = i+1;
        end
        nb_lsfiles = length(lsfiles);
    end
    clear i;
end

% check files
if ~nb_lsfiles
    error('map_load: no files. please create maps');
end


% load map
file_map = lsfiles{randi(nb_lsfiles)};
load(['files',filesep,file_map],'map');

% move that file, so no one else uses it
if parameters.debug_subject
    if exist(['donefiles',   filesep,    'allmap_',participant.name,'.mat'],'file')
        error('map_load: error. map already exists');
    end
    movefile(   ['files',       filesep,    file_map],...
                ['donefiles',   filesep,    'allmap_',participant.name,'.mat']);
end

% clean
clear lsfiles nb_lsfiles;
clear i_map;
clear file_map;

