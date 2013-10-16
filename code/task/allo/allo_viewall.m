function allo_viewall()
    % ls the 'donefiles' folder
    if IsWin
        tmp_lsfiles = dir('donefiles');
        lsfiles = {};
        for i = 1:length(tmp_lsfiles)
            if ~(tmp_lsfiles(i).name(1)=='.')
                lsfiles{end+1} = tmp_lsfiles(i).name;
            end
        end
        nb_lsfiles = length(lsfiles);
    else
        lsfiles = regexp(ls('donefiles'),'\s','split');
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
    
    % for each data file
    for i_lsfiles = 1:length(lsfiles)
        %% initialise
            % load
        load(['donefiles/',lsfiles{i_lsfiles}]);
            % struct
        allo_view(allo);
    end
    
end