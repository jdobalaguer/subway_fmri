
function scan3_glm_copycontrasts()
    %% SCAN3_GLM_COPYCONTRASTS()
    % copy second level contrasts into a new file
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED>
    
    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask glm_function glm_ordfir glm_lenfir glm_delay glm_marge;
    global n_subject u_subject;
    global u_contrast;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    %% COPY CONTRASTS
    mkdirp(dire_glm_contrast);
    for i_con = 1:length(u_contrast)
        img_from = sprintf('%scon_%s/spmT_0001.img',dire_glm_secondlevel,u_contrast{i_con}.name);
        img_to   = sprintf('%s/con_%s.img',dire_glm_contrast,u_contrast{i_con}.name);
        if exist(img_from,'file'), copyfile(img_from,img_to); end
        hdr_from = sprintf('%scon_%s/spmT_0001.hdr',dire_glm_secondlevel,u_contrast{i_con}.name);
        hdr_to   = sprintf('%s/con_%s.hdr',dire_glm_contrast,u_contrast{i_con}.name);
        if exist(hdr_from,'file'), copyfile(hdr_from,hdr_to); end
        nii_from = sprintf('%scon_%s/spmT_0001.nii',dire_glm_secondlevel,u_contrast{i_con}.name);
        nii_to   = sprintf('%s/con_%s.nii',dire_glm_contrast,u_contrast{i_con}.name);
        if exist(nii_from,'file'), copyfile(nii_from,nii_to); end
    end
    
end