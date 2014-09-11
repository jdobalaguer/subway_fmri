function tools_deletedata(session)

    %% sure?
    sure = str2num(input('You sure? ','s'));
    if length(sure)~=1 || sure~=1
        fprintf('cancelled\n\n');
        return;
    end
    fprintf('\n');

    %% data
    path = ['data',filesep,'data',filesep,session];
    if exist(path,'dir')
        rmdir(path,'s');
    end

    %% result
    path = ['data',filesep,'result',filesep,session];
    if exist(path,'dir')
        rmdir(path,'s');
    end

    %% error
    path = ['data',filesep,'error',filesep,session];
    if exist(path,'dir')
        rmdir(path,'s');
    end

end