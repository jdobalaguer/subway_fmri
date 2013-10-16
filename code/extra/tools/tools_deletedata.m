function tools_deletedata()

    %% sure?
    sure = str2num(input('You sure? ','s'));
    if length(sure)~=1 || sure~=1
        fprintf('cancelled\n\n');
        return;
    end
    fprintf('\n');

    %% donefiles
    % ls the 'data' folder
    lsdata = regexp(ls('data'),'\s','split');
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
        delete(['data/',lsdata{i_lsdata}]);
    end

end