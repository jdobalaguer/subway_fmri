
function scan = scan3_glm_mergeregressors(scan)
    %% SCAN3_GLM_MERGEREGRESSORS()
    % merge regressors for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*FPARK>
    
    %% MERGE REGRESSORS
    for sub = scan.subject.u
        dire_niiepi3 = strtrim(scan.dire.nii_epi3(sub,:));
        fprintf('Merge regressors for:    %s\n',dire_niiepi3);
        dire_niiruns = dir([dire_niiepi3,'run*']); dire_niiruns = strcat(strvcat(dire_niiruns.name),'/');
        nb_runs     = size(dire_niiruns, 1);
        u_run       = 1:nb_runs;

        % concatenate realignment
        R = zeros(0,6);
        nb_volumes = nan(size(u_run));
        for i_run = 1:nb_runs
            run = u_run(i_run);
            file_datreaR = sprintf('%srealign_sub_%02i_run_%02i.mat',  scan.dire.glm_condition,sub,i_run);
            % run onset
            R     = [R,zeros(size(R,1),1)];
            tmp   = load(file_datreaR,'R');
            tmp.R = [tmp.R, zeros(size(tmp.R,1),i_run-1), ones(size(tmp.R,1),1)];
            % concatenate
            R = [R ; tmp.R];
            nb_volumes(i_run) = size(tmp.R,1);
        end
        R(:,end) = [];
        file_datreaS = sprintf('%smerged_realign_sub_%02i.mat',  scan.dire.glm_condition,sub);
        save(file_datreaS,'R');

        % concatenate conditions
        onset = 0;
        cond = {};
        load(sprintf('%scondition_sub_%02i_run_%02i.mat',scan.dire.glm_condition,sub,u_run(1)));
        for i_run = 2:nb_runs
            onset = onset + scan.pars.tr * nb_volumes(i_run-1);
            run = u_run(i_run);
            file_datconR = sprintf('%scondition_sub_%02i_run_%02i.mat',scan.dire.glm_condition,sub,i_run);
            tmp = load(file_datconR,'cond');
            for i_cond = 1:length(cond)
                cond{i_cond}.onset = [cond{i_cond}.onset, tmp.cond{i_cond}.onset + onset];
                for i_level = 1:length(cond{i_cond}.level)
                    cond{i_cond}.level{i_level} = [cond{i_cond}.level{i_level}, tmp.cond{i_cond}.level{i_level}];
                end
            end

        end
        file_datconS = sprintf('%smerged_condition_sub_%02i.mat',scan.dire.glm_condition,sub);
        save(file_datconS,'cond');
    end
end