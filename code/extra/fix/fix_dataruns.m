%{
	notes:
        files have to be                                       "dat_sub_XX*.mat"
        moves files to another folder, then save the result as "dat_sub_XX.mat"
        concatenates files by alphabetical order
%}

%#ok<*NASGU>
%#ok<*AGROW>

function data = fix_dataruns(session,i_sub,min_trial)
    
    if ~exist('min_trial','var'); min_trial = 10; end
    
    %% set paths
    dir_data = sprintf('data/data/%s/',         session);
    dir_nfix = sprintf('data/data/%s_notfixed/',session);
    fil_data = dir(sprintf('%sdata_sub_%02i*.mat',dir_data,i_sub));
    fil_data = char(fil_data.name);
    
    %% handle files
    loadfiles = cell(1,size(fil_data,1));
    for i_file = 1:size(fil_data,1)
        % load a dn filter file
        loadfile  = load(strcat(dir_data,strtrim(fil_data(i_file,:))));
        ii_filter = filter(loadfile,min_trial);
        loadfile  = rm_data(loadfile,ii_filter);
        loadfile  = rm_time(loadfile,ii_filter);
        loadfiles{i_file} = loadfile;
        % move file
        tools_mkdirp(dir_nfix);
        movefile([dir_data,strtrim(fil_data(i_file,:))],[dir_nfix,strtrim(fil_data(i_file,:))]);
    end
    
    %% set variables
    data        = cat_data(loadfiles);
    map         = loadfiles{1}.map; 
    parameters  = loadfiles{1}.parameters;
    participant = loadfiles{1}.participant;
    ptb         = loadfiles{1}.ptb;
    time        = cat_time(loadfiles);
    
    %% save file
    save(sprintf('%sdata_sub_%02i.mat',dir_data,i_sub),'data','map','parameters','participant','ptb','time');
end

%% auxiliar functions

% filter uncomplete breaks (with less than [min_trial] blocks)
function ii_filter = filter(loadfile,min_trial)
    ii_filter = [];
    u_breaks  = unique(loadfile.data.exp_break);
    u_field   = fieldnames(loadfile.data);
    nb_breaks = length(u_breaks);
    nb_fields = length(u_field);
    for i_break = 1:nb_breaks
        ii_break = (loadfile.data.exp_break==u_breaks(i_break));
        u_block  = unique(loadfile.data.exp_block(ii_break));
        if length(u_block)<min_trial
            ii_filter(end+1) = i_break; 
        end
    end
end

% remove [data] blocks
function loadfile = rm_data(loadfile,ii_filter)
    u_breaks  = unique(loadfile.data.exp_break);
    u_field   = fieldnames(loadfile.data);
    nb_breaks = length(u_breaks);
    nb_fields = length(u_field);
    for i_break = ii_filter
        ii_break = (loadfile.data.exp_break==u_breaks(i_break));
        u_block  = unique(loadfile.data.exp_block(ii_break));
        for i_field = 1:nb_fields
            loadfile.data.(u_field{i_field})(:,ii_break) = [];
        end
    end
end

% remove [time] blocks
function loadfile = rm_time(loadfile,ii_filter)
    u_breakgs = unique(loadfile.time.breakgs);
    for i_break = ii_filter
        ii_break = (loadfile.time.breakgs == u_breakgs(i_break));
        loadfile.time.breakgs(ii_break) = [];
        loadfile.time.getsecs(ii_break) = [];
        loadfile.time.screens(ii_break) = [];
    end
end

% concatenate resulting [data]s
function data = cat_data(loadfiles)
    data = loadfiles{1}.data;
    j_breaks = length(unique(data.exp_break));
    for i_loadfile = 2:length(loadfiles)
        loadfile = loadfiles{i_loadfile};
        % fix break
        v_break   = loadfile.data.exp_break;
        u_break   = unique(loadfile.data.exp_break);
        nb_breaks = length(u_break);
        for i_break = 1:nb_breaks
            ii_break = (loadfile.data.exp_break==u_break(i_break));
            v_break(ii_break) = i_break;
        end
        loadfile.data.exp_break = v_break + j_breaks;
        j_breaks = j_breaks + nb_breaks;
        % add data
        u_field = fieldnames(loadfile.data);
        for i_field = 1:length(u_field)
            u_values  = loadfile.data.(u_field{i_field});
            nb_values = size(u_values,2);
            data.(u_field{i_field})(:,end+1:end+nb_values) = u_values;
        end
    end
    % fix jtrial
    data.exp_jtrial = 1:length(data.exp_jtrial);
    % fix block
    f_start = find(data.exp_starttrial);
    f_stop  = find(data.exp_stoptrial);
    for i_block = 1:length(f_start)
        data.exp_block(f_start(i_block):f_stop(i_block)) = i_block;
    end
end

% concatenate resulting [time]s
function time = cat_time(loadfiles)
    time = loadfiles{1}.time;
    for i_loadfile = 2:length(loadfiles)
        loadfile = loadfiles{i_loadfile};
        breakgs = loadfile.time.breakgs;
        getsecs = loadfile.time.getsecs;
        screens = loadfile.time.screens;
        ii_num  = find(~isnan(breakgs) & ~isnan(getsecs));
        nb_num  = length(ii_num);
        time.breakgs(:,end+1:end+nb_num) = breakgs(ii_num);
        time.getsecs(:,end+1:end+nb_num) = getsecs(ii_num);
        time.screens(:,end+1:end+nb_num) = screens(ii_num);
    end
end
