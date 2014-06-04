
function scan_check_smooth()
    
    % set structural T1 paths
    dir_root = 'data/nii/';
    dir_subs = dir([dir_root,'sub*']);
    fns_str = {};
    for i_subs = 1:length(dir_subs)
        dir_sub = [dir_root,dir_subs(i_subs).name,'/'];
        dir_str = dir(sprintf('%sepi3/run1/smooth/sw*%03i.nii',dir_sub,randi(100)));
        for i_str = 1:length(dir_str)
            fn_str = [dir_sub,'epi3/run1/smooth/',dir_str(i_str).name];
            fns_str{end+1} = fn_str;
        end
    end
    
    % convert to matrix
    image_list = strvcat(fns_str);
    
    % spm check registration
    spm_check_registration(image_list);

end