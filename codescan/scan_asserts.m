
% assert participants (all)
function paths = scan_asserts(paths)
    i_sub = 1;
    while i_sub<=length(paths.subs)
        path_sub = [paths.nii,paths.subs{i_sub}];
        if ~scan_assert(path_sub,paths)
            paths.subs(i_sub) = [];
        else
            i_sub = i_sub+1;
        end
    end
end

% assert participant (one)
function ok = scan_assert(path_sub,paths)
    ok = 1;
    ok = ok && exist([path_sub,'/',paths.epi4],'dir');  % epi3
    ok = ok && exist([path_sub,'/',paths.gre ],'dir');  % gre
    ok = ok && exist([path_sub,'/',paths.loc ],'dir');  % loc
    ok = ok && exist([path_sub,'/',paths.str ],'dir');  % str
end

