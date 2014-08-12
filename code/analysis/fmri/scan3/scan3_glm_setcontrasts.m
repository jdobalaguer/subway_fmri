
function scan3_glm_setcontrasts()
    %% SCAN3_GLM_SETCONTRASTS()
    % set contrasts for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW>
    
    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask basis_function pars_ordfir pars_lenfir pars_delay pars_marge;
    global n_subject u_subject;
    global u_contrast;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    %% SET CONTRASTS
    u_contrast  = {};
    % set names
    tmp = load(sprintf('%scondition_sub_%02i_run_%02i.mat',dire_glm_condition,u_subject(1),1),'cond');
    u_name = {};
    for i = 1:length(tmp.cond)
        u_name = [u_name, {tmp.cond{i}.name}, tmp.cond{i}.subname];
    end
    n_name = length(u_name);
    % set order
    switch(basis_function)
        case 'hrf', n_order = 1;
        case 'fir', n_order = pars_ordfir;
    end
    % set contrasts
    j_name = 0;
    for i_name = 1:n_name
        for i_order = 1:n_order
            j_name = j_name + 1;
            name_contrast = sprintf('%s_%03i',u_name{i_name},i_order);
            conv_contrast = zeros(1,n_name*n_order);
            conv_contrast(j_name) = 1;
            u_contrast{j_name} = struct('name',name_contrast, 'convec',conv_contrast);
        end
    end
    
end