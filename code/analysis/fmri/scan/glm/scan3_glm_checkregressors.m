
function scan = scan3_glm_checkregressors(scan)
    %% SCAN3_GLM_CHECKREGRESSORS()
    % check regressors for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*FPARK>
    
    %% CHECK REGRESSORS
    for sub = scan.subject.u
        dire_nii_epi3 = strtrim(scan.dire.nii_epi3(sub,:));
        fprintf('Checking regressors for: %s\n',dire_nii_epi3);
        dire_nii_runs = dir([strtrim(dire_nii_epi3),'run*']);
        dire_nii_runs = strcat(strvcat(dire_nii_runs.name),'/');
        nb_runs     = size(dire_nii_runs, 1);
        u_run       = 1:nb_runs;
        for i_run = u_run
            % load regressors
            file_datcon = sprintf('%scondition_sub_%02i_run_%02i.mat',scan.dire.glm_condition,sub,i_run);
            file_datrea = sprintf('%srealign_sub_%02i_run_%02i.mat',  scan.dire.glm_condition,sub,i_run);
            cond = load(file_datcon); cond = cond.cond;
            R    = load(file_datrea); R = R.R;
            % check regressors length
            for i_cond = 1:length(cond)
                nb_scans_R      = size(R,1);
                scans_cond      = (cond{i_cond}.onset ./ scan.pars.tr);
                scans_to_remove = (scans_cond + scan.glm.marge > nb_scans_R);
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
