
function scan3_glm_checkregressors()
    %% SCAN3_GLM_CHECKREGRESSORS()
    % check regressors for GLM
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
    
    %% CHECK REGRESSORS
    for sub = u_subject
        dire_niiepi3 = strtrim(dire_nii_epi3(sub,:));
        fprintf('Checking regressors for: %s\n',dire_niiepi3);
        dire_niiruns = dir([strtrim(dire_nii_epi3(sub,:)),'run*']); dire_niiruns = strcat(strvcat(dire_niiruns.name),'/');
        nb_runs     = size(dire_niiruns, 1);
        u_run       = 1:nb_runs;
        for i_run = u_run
            % load regressors
            file_datcon = sprintf('%scondition_sub_%02i_run_%02i.mat',dire_glm_condition,sub,i_run);
            file_datrea = sprintf('%srealign_sub_%02i_run_%02i.mat',  dire_glm_condition,sub,i_run);
            cond = load(file_datcon); cond = cond.cond;
            R    = load(file_datrea); R = R.R;
            % check regressors length
            for i_cond = 1:length(cond)
                nb_scans_R      = size(R,1);
                scans_cond      = (cond{i_cond}.onset ./ pars_tr);
                scans_to_remove = (scans_cond + glm_marge > nb_scans_R);
                if any(scans_to_remove)
                    cond{i_cond}.onset(scans_to_remove) = [];
                    for i_level = 1:length(cond{i_cond}.level)
                        cond{i_cond}.level{i_level}(scans_to_remove) = [];
                    end
                    cprintf([1,0.5,0],'scan3_glm: warning. subject %02i run %02i cond %s removed %d samples',sub,u_run(i_run),cond{i_cond}.name);
                    fprintf('\n');
                end
            end
            % save regressors
            save(file_datcon,'cond');
        end
    end
end