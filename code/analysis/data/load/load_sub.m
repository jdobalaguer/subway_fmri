
function alldata = load_sub(path)
    if ~exist('path','var'); path = 'scanner'; end
    path_dir = ['data',filesep(),'data',filesep(),path,filesep()];
    path_subject = dir([path_dir,'data_*.mat']);
    path_subject = strcat(path_dir,cell2mat({path_subject(:).name}'));
    
    % numbers
    nb_subject = size(path_subject,1);
    
    % concatenate
    alldata = [];
    for i_subject = 1:nb_subject
        path_file = strtrim(path_subject(i_subject,:));
        assert(exist(path_file,'file')>0,'load_data: cant find "%s"',path_file);
        subdata = load(path_file,'participant');
        alldata = struct_concat(2,alldata,subdata.participant);
    end
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
        
        % to cell
        if ~iscell(v1), v1 = {v1}; end
        if ~iscell(v2), v2 = {v2}; end
            
        % concat values
        v = cat(dim,v1,v2);
        
        % save value
        ret.(this_field) = v;
    end
end