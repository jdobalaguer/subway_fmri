
function scan3_glm_buildregressors()
    %% SCAN3_GLM_BUILDREGRESSORS()
    % build regressors for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW,*FPARK>
    
    %% GLOBAL PARAMETERS
    global name_glm delete_all name_mask basis_function pars_ordfir pars_lenfir pars_delay pars_marge;
    global n_subject u_subject;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    
    %% BUILD REGRESSORS
    % make directory
    if ~exist(dire_glm_condition,'dir'); mkdirp(dire_glm_condition); end
    % load data
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');

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

            % TRIAL & RESPONSE REGRESSORS %%%%%%%%%%%%%%%%%%%%%%%
            ii_sub   = (data.expt_subject == sub);
            ii_run   = (data.expt_session == u_run(i_run));
            ii_bool  = (data.resp_bool);
            ii_back  = (~data.resp_direction_back);
            ii_data  = (ii_sub & ii_run);
            ii_resp  = (ii_sub & ii_run & ii_bool & ii_back);

            % T --- onset trial                              ... onset
            z_TX = ztransf(data.vbxi_exchange_in(ii_resp));       ... exchange station
            z_TL = ztransf(data.vbxi_elbow_in(ii_resp));          ... elbow station
            z_TS = ztransf(data.resp_direction_switch(ii_resp));  ... switch 
            z_TC = ztransf(data.resp_subline_change(ii_resp));    ... subline change
            
            z_A1 = ztransf(data.resp_direction_west(ii_resp));
            z_A2 = ztransf(data.resp_direction_north(ii_resp));
            z_A3 = ztransf(data.resp_direction_south(ii_resp));
            z_A4 = ztransf(data.resp_direction_east(ii_resp));
            
            z_AV  = ztransf(data.resp_direction_north(ii_resp) | data.resp_direction_south(ii_resp));
            z_AH  = ztransf(data.resp_direction_east(ii_resp)  | data.resp_direction_west(ii_resp));

            % R --- onset response                           ... onset

            name     = 'T';
            onset    = data.vbxi_onset(ii_resp) + pars_reft0 - pars_delay;
            subnames = {'TAH'};
            levels   = {z_AH};
            cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});

            % name     = 'R';
            % onset    = data.resp_onset(ii) + pars_reft0 - pars_delay;
            % subnames = {};
            % levels   = {};
            % cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});

            % CUE & FEEDBACK REGRESSORS %%%%%%%%%%%%%%%%%%%%%%%%%
            ii_sub   = (block.expt_subject == sub);
            ii_run   = (block.expt_session == u_run(i_run));
            ii_cue   = (ii_sub & ii_run);
            ii_nan   = ~isnan(block.vbxi_onset_reward);
            ii_rew   = (ii_sub & ii_run & ii_nan);

            % C --- onset cue                               ... onset

            % F --- onset feedback                          ... onset
            z_FG = ztransf(block.resp_goal(ii_rew));        ... goal reached
            z_FQ = ztransf(block.vbxi_reward(ii_rew));      ... reward

%             name     = 'C';
%             onset    = block.vbxi_onset_cue(ii_cue) + pars_reft0 - pars_delay;
%             subnames = {};
%             levels   = {};
%             cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});

%             name     = 'F';
%             onset    = block.vbxi_onset_reward(ii_rew) + pars_reft0 - pars_delay;
%             subnames = {'FG'};
%             levels   = {z_FG};
%             cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});

            % load realignment
            R = load(file_niirea);

            % save regressors
            save(file_datcon,'cond');
            save(file_datrea,'R');
        end
    end
end