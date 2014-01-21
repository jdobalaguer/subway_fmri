
function nii = mask_save(mask,filename)
    nii = make_nii(mask);
    save_nii(nii,filename);
end
