
function scan = scan3_glm_copycontrasts(scan)
    %% SCAN3_GLM_COPYCONTRASTS()
    % copy second level contrasts into a new file
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED>
    
    %% COPY CONTRASTS
    mkdirp(scan.dire.glm_contrast);
    for i_con = 1:length(scan.glm.contrast)
        img_from = sprintf('%scon_%s/spmT_0001.img',scan.dire.glm_secondlevel,scan.glm.contrast{i_con}.name);
        img_to   = sprintf('%s/con_%s.img',scan.dire.glm_contrast,scan.glm.contrast{i_con}.name);
        if exist(img_from,'file'), copyfile(img_from,img_to); end
        hdr_from = sprintf('%scon_%s/spmT_0001.hdr',scan.dire.glm_secondlevel,scan.glm.contrast{i_con}.name);
        hdr_to   = sprintf('%s/con_%s.hdr',scan.dire.glm_contrast,scan.glm.contrast{i_con}.name);
        if exist(hdr_from,'file'), copyfile(hdr_from,hdr_to); end
        nii_from = sprintf('%scon_%s/spmT_0001.nii',scan.dire.glm_secondlevel,scan.glm.contrast{i_con}.name);
        nii_to   = sprintf('%s/con_%s.nii',scan.dire.glm_contrast,scan.glm.contrast{i_con}.name);
        if exist(nii_from,'file'), copyfile(nii_from,nii_to); end
    end
    
end