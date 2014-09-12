
function scan = scan3_glm_copybetas(scan)
    %% SCAN3_GLM_COPYBETAS()
    % copy first level beta files into a new folder
    % see also scan3_glm

    %%  WARNINGS
    %#ok<>
    
    %% FUNCTION
    for subject = scan.subject.u
        fprintf('glm copy betas for :       subject %02i \n',subject);
        for i_con = 1:length(scan.glm.contrast)
            dire_first = sprintf('%ssub_%02i/',scan.dire.glm_firstlevel,subject);
            dire_beta  = sprintf('%scon_%s/',  scan.dire.glm_beta,scan.glm.contrast{i_con}.name);
            mkdirp(dire_beta);
            if exist(sprintf('%sbeta_%04i.hdr',dire_first,i_con),'file'), copyfile(sprintf('%sbeta_%04i.hdr',dire_first,i_con),sprintf('%sbeta_sub%02i_con%02i.hdr',dire_beta,subject,i_con)); end
            if exist(sprintf('%sbeta_%04i.img',dire_first,i_con),'file'), copyfile(sprintf('%sbeta_%04i.img',dire_first,i_con),sprintf('%sbeta_sub%02i_con%02i.img',dire_beta,subject,i_con)); end
            if exist(sprintf('%sbeta_%04i.nii',dire_first,i_con),'file'), copyfile(sprintf('%sbeta_%04i.nii',dire_first,i_con),sprintf('%sbeta_sub%02i_con%02i.nii',dire_beta,subject,i_con)); end
        end
    end
    
end
