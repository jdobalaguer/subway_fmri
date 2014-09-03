
function scan3_glm_buildregressors()
    %% SCAN3_GLM_BUILDREGRESSORS()
    % build regressors for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW,*FPARK>
    
    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask glm_function glm_ordfir glm_lenfir glm_delay glm_marge;
    global n_subject u_subject;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    global glm_regressors;
    
    %% BUILD REGRESSORS
    % make directory
    if ~exist(dire_glm_condition,'dir'); mkdirp(dire_glm_condition); end
    for sub = u_subject
        dire_niiepi3 = strtrim(dire_nii_epi3(sub,:));
        fprintf('Building regressors for: %s\n',dire_niiepi3);
        dire_niiruns = dir([strtrim(dire_nii_epi3(sub,:)),'run*']); dire_niiruns = strcat(strvcat(dire_niiruns.name),'/');
        nb_runs     = size(dire_niiruns, 1);
        u_run       = 1:nb_runs;
        for i_run = u_run
            file_datcon = sprintf('%scondition_sub_%02i_run_%02i.mat',dire_glm_condition,sub,i_run);
            file_datrea = sprintf('%srealign_sub_%02i_run_%02i.mat',  dire_glm_condition,sub,i_run);

            % dirs & files
            dire_niirun     = strcat(dire_niiepi3,strtrim(dire_niiruns(i_run,:)));
            dire_niirea     = strcat(dire_niirun,'realignment',filesep);
            file_niirea     = dir([dire_niirea,'rp_*image*.txt']);   file_niirea = strcat(dire_niirea,strvcat(file_niirea.name));
            
            cond = {};
            for i_cond = 1:length(glm_regressors)
                regressor = glm_regressors(i_cond);
                ii_sub   = (regressor.subject == sub);
                ii_run   = (regressor.session == u_run(i_run));
                ii_dis   = (regressor.discard);
                if isempty(ii_dis), ii_dis = false(size(ii_sub)); end
                ii_data  = (ii_sub & ii_run & ~ii_dis);
                
                name     = regressor.name;
                onset    = regressor.onset(ii_data) + pars_reft0 - glm_delay;
                subname = regressor.subname;
                level   = regressor.level;
                for i_level = 1:length(level), level{i_level} = level{i_level}(ii_data); end
                cond{end+1} = struct(   'name'     , name       , ...
                                        'onset'    , {onset}    , ...
                                        'subname'  , {subname}  , ...
                                        'level'    , {level}    , ...
                                        'duration' , {0}        );
            end

            % load realignment
            R = load(file_niirea);

            % save regressors
            save(file_datcon,'cond');
            save(file_datrea,'R');
        end
    end
end