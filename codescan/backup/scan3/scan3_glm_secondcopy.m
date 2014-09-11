
function scan3_glm_secondcopy()
    %% SCAN3_GLM_SECONDCOPY()
    % copy files for a second level analysis of the GLM
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
    
    %% SECOND COPY
    for i_sub = u_subject
        fprintf('glm second level copy for: subject %02i\n',i_sub);
        for i_con = 1:length(u_contrast)
            dir_datglm1 = sprintf('%ssub_%02i/',dire_glm_firstlevel,i_sub);
            dir_datglm2 = sprintf('%scon_%s/',dire_glm_secondlevel,u_contrast{i_con}.name);
            if ~exist(dir_datglm2,'dir'); mkdirp(dir_datglm2); end
            if exist(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),'file'), copyfile(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.hdr',dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),'file'), copyfile(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.img',dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%sspmT_%04i.nii',dir_datglm1,i_con),'file'), copyfile(sprintf('%sspmT_%04i.nii',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.nii',dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%scon_%04i.hdr',dir_datglm1,i_con),'file'), copyfile(sprintf('%scon_%04i.hdr' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.hdr' ,dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%scon_%04i.img',dir_datglm1,i_con),'file'), copyfile(sprintf('%scon_%04i.img' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.img' ,dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%scon_%04i.nii',dir_datglm1,i_con),'file'), copyfile(sprintf('%scon_%04i.nii' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.nii' ,dir_datglm2,i_sub,i_con)); end
        end
    end
    
end