
function scan = scan3_glm_buildregressors(scan)
    %% SCAN3_GLM_BUILDREGRESSORS()
    % build regressors for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW,*FPARK,*NASGU>
    
    %% BUILD REGRESSORS
    % make directory
    if ~exist(scan.dire.glm_condition,'dir'); mkdirp(scan.dire.glm_condition); end
    for sub = scan.subject.u
        dire_nii_epi3 = strtrim(scan.dire.nii_epi3(sub,:));
        fprintf('Building regressors for: %s\n',dire_nii_epi3);
        dire_nii_runs = dir([strtrim(dire_nii_epi3),'run*']);
        dire_nii_runs = strcat(strvcat(dire_nii_runs.name),'/');
        nb_runs     = size(dire_nii_runs, 1);
        u_run       = 1:nb_runs;
        for i_run = u_run
            file_dat_con = sprintf('%scondition_sub_%02i_run_%02i.mat',scan.dire.glm_condition,sub,i_run);
            file_dat_rea = sprintf('%srealign_sub_%02i_run_%02i.mat',  scan.dire.glm_condition,sub,i_run);

            % dirs & files
            dire_nii_run     = strcat(dire_nii_epi3,strtrim(dire_nii_runs(i_run,:)));
            dire_nii_rea     = strcat(dire_nii_run,'realignment',filesep);
            file_nii_rea     = dir([dire_nii_rea,'rp_*image*.txt']);   file_nii_rea = strcat(dire_nii_rea,strvcat(file_nii_rea.name));
            
            cond = {};
            for i_cond = 1:length(scan.glm.regressor)
                regressor = scan.glm.regressor(i_cond);
                ii_sub   = (regressor.subject == sub);
                ii_run   = (regressor.session == u_run(i_run));
                ii_dis   = (regressor.discard);
                if isempty(ii_dis), ii_dis = false(size(ii_sub)); end
                ii_data  = (ii_sub & ii_run & ~ii_dis);
                
                name     = regressor.name;
                onset    = regressor.onset(ii_data) + scan.pars.reft0 - scan.glm.delay;
                subname  = regressor.subname;
                level    = regressor.level;
                duration = regressor.duration;
                for i_level = 1:length(level), level{i_level} = level{i_level}(ii_data); end
                cond{end+1} = struct(   'name'     , name       , ...
                                        'onset'    , {onset}    , ...
                                        'subname'  , {subname}  , ...
                                        'level'    , {level}    , ...
                                        'duration' , {duration} );
            end

            % load realignment
            R = load(file_nii_rea);

            % save regressors
            save(file_dat_con,'cond');
            save(file_dat_rea,'R');
        end
    end
end
