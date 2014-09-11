
function imgs = scan3_dprime(session)
    if ~exist('session','var'); session = 'scanner'; end
    
    n_sub   = 2:19; %%%[6,10];
    fields  = {'screen_block','screen_rew','avat7_line1','avat7_line3','avat7_line5','avat7_line7'};
    u_ttest = [3,4];
    
    %% set paths
    dir_spm                     = [fileparts(which('spm.m')),filesep];
    dir_study                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_study,'sub_*']); dir_subs = strcat(dir_study,strvcat(dir_subs.name),'/');
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    dir_epis4                   = strcat(dir_subs,'epi4',filesep);
    
    %% set parameters
    pars_tr      = 2;
    pars_bold    = 6;
    
    %% set numbers
    nb_subs   = size(dir_subs,1);
    u_sub     = 1:nb_subs;
    u_sub(n_sub) = [];
    nb_fields = length(fields);

    %% get regressors
    fprintf('\n');
    fprintf('scan3_dprime: get regressors \n');
    times  = scan3_glm_loadregressors(session);
    
    %% get times
    fprintf('\n');
    fprintf('scan3_dprime: get times \n');
    cats   = cell(1,nb_subs);
    j_run = 0;
    for i_sub = u_sub
        dir_sub  = strtrim(dir_subs(i_sub,:));
        dir_nii3 = strtrim(dir_epis3(i_sub,:));
        dir_runs = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
        nb_runs  = size(dir_runs, 1);
        u_run    = 1:nb_runs;
        
        cat = cell(1,nb_runs);
        for i_run = u_run
            fprintf('scan3_dprime: participant %02d run %02i \n',i_sub,i_run);
            j_run = j_run + 1;
            
            dir_run = strcat(dir_nii3,dir_runs(i_run,:),'images/');
            fil_run = dir([dir_run,'u*']); fil_run = strcat(dir_run,strvcat(fil_run.name));
            nb_scans = size(fil_run,1);
            
            time = times{j_run};
            time = clean_time(time,fields);
            cat{i_run} = scan3_dprime_regressors(time,pars_tr,pars_bold,nb_scans);
        end
        cats{i_sub} = cat;
    end
    
    %% get images
    fprintf('\n');
    fprintf('scan3_dprime: get regressors \n');
    imgs = cell(1,nb_subs);
    for i_sub = u_sub
        fprintf('scan3_dprime: participant %02d \n',i_sub);
        dir_sub  = strtrim(dir_subs(i_sub,:));
        dir_nii3 = strtrim(dir_epis3(i_sub,:));
        dir_runs = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
        nb_runs  = size(dir_runs, 1);
        u_run    = 1:nb_runs;
        for i_run = u_run
            fprintf('scan3_dprime: participant %02d run %02i \n',i_sub,i_run);
            dir_run = strcat(dir_nii3,dir_runs(i_run,:),'images/');
            fil_run = dir([dir_run,'u*']); fil_run = strcat(dir_run,strvcat(fil_run.name));
            nb_scans = size(fil_run,1);
            u_scan   = 1:nb_scans;
            
            img = cell(1,nb_fields);
            cat = cats{i_sub}{i_run};
            for i_scan = u_scan
                nii = load_untouch_nii(strtrim(fil_run(i_scan,:)));
                if isempty(img{cat(i_scan)})
                    img{cat(i_scan)} = zeros([0,size(nii.img)]);
                end
                img{cat(i_scan)}(end+1,:,:,:) = nii.img;
            end
        end
        imgs{i_sub} = img;
    end
    
    %% ttest
    fprintf('\n');
    fprintf('scan3_dprime: ttest2 \n');
    s_img = size(nii.img);
    timgs = nan([nb_subs,s_img]);
    for i_sub = u_sub
        fprintf('scan3_dprime: participant %02d \n',i_sub);
        [~,p,~,~] = ttest2(imgs{i_sub}{u_ttest(1)}(:,:),imgs{i_sub}{u_ttest(2)}(:,:));
        timgs(i_sub,:) = p(:);
    end
    
end

function time = clean_time(time,fields)
    u_field   = fieldnames(time);
    nb_fields = length(u_field);
    for i_field = 1:nb_fields
        if ~ismember(u_field{i_field},fields)
            time = rmfield(time,u_field{i_field});
        end
    end
end