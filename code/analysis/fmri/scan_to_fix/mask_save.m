
function nii = mask_save(mask,filename)
    if ischar(mask)
        if ~exist('filename','var'); filename = sprintf('mask_%s.mat',mask); end
        mask = mask_load(mask);
    end
    nii = make_nii(mask);
    save_nii(nii,filename);
end
