
function alltime = load_time(path)
    if ~exist('path','var'); path = 'scanner'; end
    path_dir = ['data',filesep(),'data',filesep(),path,filesep()];
    assert(logical(exist(path_dir,'dir')),sprintf('load_data: directory "%s" does not exist',path_dir));
    path_subject = dir([path_dir,'data_*.mat']);
    path_subject = strcat(path_dir,cell2mat({path_subject(:).name}'));
    nb_subject = size(path_subject,1);
    
    % concatenate
    alltime = struct('breakgs',{},'getsecs',{},'screens',{});
    for i_subject = 1:nb_subject
        path_file = strtrim(path_subject(i_subject,:));
        assert(exist(path_file,'file')>0,'load_data: cant find "%s"',path_file);
        subtime = load(path_file,'time');
        alltime(end+1) = struct_sort(subtime.time); %#ok<AGROW>
    end

end
