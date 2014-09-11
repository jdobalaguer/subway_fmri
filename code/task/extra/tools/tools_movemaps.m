function tools_movemaps()
    
    path_todo = ['data',filesep,'maps',filesep,'todo'];
    path_done = ['data',filesep,'maps',filesep,'done'];

    %% donefiles
    % ls the 'data' folder
    lsdata = regexp(ls(path_done),'\s','split');
    i = 1;
    while i<=length(lsdata)
        if isempty(lsdata{i})
            lsdata(i) = [];
        else
            i = i+1;
        end
    end
    nb_lsdata = length(lsdata);

    %% move them
    for i_lsdata = 1:nb_lsdata
        movefile([path_done,filesep,lsdata{i_lsdata}] , [path_todo,filesep,'allmap_',num2str(randi(10000)),'.mat']);
    end
    
end