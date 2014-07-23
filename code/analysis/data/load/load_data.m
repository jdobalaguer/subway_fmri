

function alldata = load_data(path)
    if ~exist('path','var'); path = 'scanner'; end
    path_dir = ['data',filesep(),'data',filesep(),path,filesep()];
    assert(logical(exist(path_dir,'dir')),sprintf('load_data: directory "%s" does not exist',path_dir));
    path_subject = dir([path_dir,'data_*.mat']);
    path_subject = strcat(path_dir,cell2mat({path_subject(:).name}'));
    nb_subject = size(path_subject,1);
    
    % concatenate
    alldata = [];
    for i_subject = 1:nb_subject
        path_file = strtrim(path_subject(i_subject,:));
        assert(exist(path_file,'file')>0,'load_data: cant find "%s"',path_file);
        subdata = load(path_file,'data','map');
        alldata = struct_concat(2,alldata,subdata.data);
    end
    
    % fix
    alldata = fix_data_expsub(alldata);         ... subject id
    alldata = fix_data_expblock(alldata);       ... block
    alldata = fix_data_subline(alldata);        ... subline
    
    % sort
    alldata = struct_sort(alldata);
    
end

function ret = struct_concat(dim,s1,s2)
    if isempty(s1), ret = s2; return; end
    
    u_field = fieldnames(s1);
    nb_fields = length(u_field);
    
    ret = struct();
    for i_field = 1:nb_fields
        this_field = u_field{i_field};
        
        % get values
        v1 = s1.(this_field);
        v2 = s2.(this_field);
        
        % concat values
        v = cat(dim,v1,v2);
        
        % save value
        ret.(this_field) = v;
    end
end