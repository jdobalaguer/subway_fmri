
function scan3_glm_mergeregressors()
    %% SCAN3_GLM_MERGEREGRESSORS()
    % merge regressors for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*FPARK>
    
    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask glm_function glm_ordfir glm_lenfir glm_delay glm_marge;
    global n_subject u_subject;
    global do_pooling;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    %% MERGE REGRESSORS
    for sub = u_subject
        dire_niiepi3 = strtrim(dire_nii_epi3(sub,:));
        fprintf('Merge regressors for:    %s\n',dire_niiepi3);
        dire_niiruns = dir([dire_niiepi3,'run*']); dire_niiruns = strcat(strvcat(dire_niiruns.name),'/');
        nb_runs     = size(dire_niiruns, 1);
        u_run       = 1:nb_runs;

        % concatenate realignment
        R = zeros(0,6);
        nb_volumes = nan(size(u_run));
        for i_run = 1:nb_runs
            run = u_run(i_run);
            file_datreaR = sprintf('%srealign_sub_%02i_run_%02i.mat',  dire_glm_condition,sub,i_run);
            % run onset
            R     = [R,zeros(size(R,1),1)];
            tmp   = load(file_datreaR,'R');
            tmp.R = [tmp.R, zeros(size(tmp.R,1),i_run-1), ones(size(tmp.R,1),1)];
            % concatenate
            R = [R ; tmp.R];
            nb_volumes(i_run) = size(tmp.R,1);
        end
        R(:,end) = [];
        file_datreaS = sprintf('%smerged_realign_sub_%02i.mat',  dire_glm_condition,sub);
        save(file_datreaS,'R');

        % concatenate conditions
        onset = 0;
        cond = {};
        load(sprintf('%scondition_sub_%02i_run_%02i.mat',dire_glm_condition,sub,u_run(1)));
        for i_run = 2:nb_runs
            onset = onset + pars_tr * nb_volumes(i_run-1);
            run = u_run(i_run);
            file_datconR = sprintf('%scondition_sub_%02i_run_%02i.mat',dire_glm_condition,sub,i_run);
            tmp = load(file_datconR,'cond');
            for i_cond = 1:length(cond)
                cond{i_cond}.onset = [cond{i_cond}.onset, tmp.cond{i_cond}.onset + onset];
                for i_level = 1:length(cond{i_cond}.level)
                    cond{i_cond}.level{i_level} = [cond{i_cond}.level{i_level}, tmp.cond{i_cond}.level{i_level}];
                end
            end

        end
        file_datconS = sprintf('%smerged_condition_sub_%02i.mat',dire_glm_condition,sub);
        save(file_datconS,'cond');
    end
end