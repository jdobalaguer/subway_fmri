
function tools_mkdirp(path)
    assert(~ispc(),'mkdirp: doesnt work under win');
    if path(1  )~='/'; path = [pwd(),filesep(),path]; end
    if path(end)=='/'; path(end)=[];                  end
    i_filesep = find(path=='/',1,'last');
    rootpath = path;
    rootpath(i_filesep:end) = [];
    if ~exist(rootpath,'dir'); tools_mkdirp(rootpath); end
    if exist(path,'dir'); return; end
    mkdir(path);
end

