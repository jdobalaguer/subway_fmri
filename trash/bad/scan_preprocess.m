
function scan_preprocess()
    
    % generate paths
    paths       = scan_genpaths();
    paths.subs  = scan_list(paths.nii);
    paths       = scan_asserts(paths);

    % mkdir
    scan_mkdir(paths);

    % expand
    scan_expand(paths);
    
    % slice timing correction
    scan_slicetiming(paths);            ... todo
    
    % set origin
    scan_anteriorcomissure(paths);      ... todo

    % realign (soft)
    scan_realign(paths);
    
    % fieldmap distortion
    scan_fieldmap(paths);               ... todo
        
    % transform to nmi (hard)
    scan_transform(paths);              ... todo

    % smooth
    scan_smooth(paths);                 ... todo

end

