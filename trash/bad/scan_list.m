
% list participants
function paths_subs = scan_list(paths_nii)
    dir_subs = dir(paths_nii);
    paths_subs = {dir_subs.name};
    paths_subs = tools_undot(paths_subs);
end
