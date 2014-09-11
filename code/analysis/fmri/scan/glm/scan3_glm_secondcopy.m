
function scan = scan3_glm_secondcopy(scan)
    %% SCAN3_GLM_SECONDCOPY()
    % copy files for a second level analysis of the GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED>
    
    %% SECOND COPY
    for i_sub = scan.subject.u
        fprintf('glm second level copy for: subject %02i\n',i_sub);
        for i_con = 1:length(scan.glm.contrast)
            dir_datglm1 = sprintf('%ssub_%02i/',scan.dire.glm_firstlevel,i_sub);
            dir_datglm2 = sprintf('%scon_%s/',scan.dire.glm_secondlevel,scan.glm.contrast{i_con}.name);
            if ~exist(dir_datglm2,'dir'); mkdirp(dir_datglm2); end
            if exist(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),'file'), copyfile(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.hdr',dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),'file'), copyfile(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.img',dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%sspmT_%04i.nii',dir_datglm1,i_con),'file'), copyfile(sprintf('%sspmT_%04i.nii',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.nii',dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%scon_%04i.hdr', dir_datglm1,i_con),'file'), copyfile(sprintf('%scon_%04i.hdr', dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.hdr' ,dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%scon_%04i.img', dir_datglm1,i_con),'file'), copyfile(sprintf('%scon_%04i.img', dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.img' ,dir_datglm2,i_sub,i_con)); end
            if exist(sprintf('%scon_%04i.nii', dir_datglm1,i_con),'file'), copyfile(sprintf('%scon_%04i.nii', dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.nii' ,dir_datglm2,i_sub,i_con)); end
        end
    end
    
end
