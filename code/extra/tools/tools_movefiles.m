function tools_movefiles()

    %% donefiles
    % ls the 'data' folder
    lsdata = regexp(ls('donefiles'),'\s','split');
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
        movefile(['donefiles/',lsdata{i_lsdata}] , ['files/allmap_',num2str(randi(10000)),'.mat']);
    end
    
end