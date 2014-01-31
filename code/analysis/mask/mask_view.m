
function mask_view(regions)
    mask = mask_load(regions);
    mask = mask_resample(mask,[64,64,36]);
    nii  = make_nii(mask);
    view_nii(nii);
end

