function scan_mvpa(region,ii_sub)

    %% check
    % mvpa toolbox
    if ~exist('mvpa_add_paths','file')
        error('This tutorial requires the neural networking toolbox, if it is unavailable this will not execute');
    else
        paths     = strsplit(path(),':');
        mvpa_path = fileparts(which('mvpa_add_paths'));
        if ~any(strcmp(mvpa_path,paths))
            mvpa_add_paths();
        end
    end

    % neural networking toolbox
    if ~exist('newff','file')
        error('This tutorial requires the neural networking toolbox, if it is unavailable this will not execute');
    end

    %% set parameters
        fprintf('\n');
        fprintf('scan_mvpa: set variables =================================\n');

    pars_TR   = 2;
    pars_patt = 'beta'; % 'epi'/beta'
    
    %% set paths
    dir_study = sprintf('data/nii/');
    dir_subs  = dir([dir_study,'sub_*']); dir_subs = strcat(dir_study,strvcat(dir_subs.name),'/');
    dir_nii4 = sprintf('%sepi4/', dir_sub);
    fil_nii4 = cellstr(strcat(dir_nii4,spm_select('List',dir_nii4,'^images.*\.nii$')));
    nb_subs   = size(dir_subs,1);
    nb_runs   = 4;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% HRF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('\n');
        fprintf('scan_mvpa: correlate HRF *********************************\n');
        
        
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% MVPA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('\n');
        fprintf('scan_mvpa: MVPA ******************************************\n');
    if ~exist('ii_sub','var'); ii_sub = 1:nb_subs; end
    for i_sub = ii_sub
        fprintf('\n');
        fprintf('scan_mvpa: participant %02i ================================\n',i_sub);
        
        %% set paths
        dir_sub  = strtrim(dir_subs(i_sub,:));
        dir_nii3 = cell(1,nb_runs);
        for i_run = 1:nb_runs
            dir_nii3{i_run} = sprintf('%sepi3/run%d/images/',dir_sub,i_run);
        end

        %% build subject
        fprintf('\n');
        fprintf('scan_mvpa: build subject ---------------------------------\n');

        % set the mvpa toolbox
        subj_id   = sprintf('sub%02i',i_sub);
        subj_exp  = 'subway';
        subj = init_subj(subj_id,subj_exp);

        %% build mask
        fprintf('\n');
        fprintf('scan_mvpa: build mask ------------------------------------\n');
        
        % mask
        mask_file = sprintf('mask_%s.nii',region);
        mask_var  = mask_resample(mask_load(region),[40,48,34]); %[64,64,36]);
        mask_save(mask_var,mask_file);
        % set the mvpa toolbox
        subj_maskname = region;
        subj_maskfile = mask_file;
        subj = load_spm_mask(subj,subj_maskname,subj_maskfile);

        %% build pattern
        fprintf('\n');
        fprintf('scan_mvpa: build pattern ---------------------------------\n');
        
        i_run = 1;
        subj_rawfile = cellstr(strcat(dir_nii3{i_run},spm_select('List', dir_nii3{i_run}, '^sw4uimages.*\.nii$')));
        subj_condruns = [];
        subj_condruns(1:length(subj_rawfile)) = i_run;
        for i_run = 2:nb_runs
            subj_rawfile = tools_cellcat(subj_rawfile , cellstr(strcat(dir_nii3{i_run},spm_select('List',dir_nii3{i_run},'^sw4uimages.*\.nii$'))));
            subj_condruns(end+1:length(subj_rawfile)) = i_run;
        end
%         subj_rawfile  = fil_nii4;
%         subj_condruns  = [];
%         for i_run = 1:nb_runs
%             subj_condruns(end+1 : end+get_nii_frame(fil_nii4{i_run})) = i_run;
%         end
        subj_pattname = pars_patt;
        subj = load_spm_pattern(subj,subj_pattname,subj_maskname,subj_rawfile);

        %% build regressors
        fprintf('\n');
        fprintf('scan_mvpa: build regressors ------------------------------\n');
        
        % variables
        subj_condtype   = 'regressors';
        subj_condname   = 'conds';
        subj_condfields = {'screen_block','screen_rew','avatar_regular','avatar_exchange'};
        
        % regressor
        tools_workspace;
        save('workspace','workspace');
        subj_condregs = scan_mvpa_regressors(workspace);
        %subj_condregs = scan_mvpa_randomregressors(workspace);
        clear('workspace');
        
        % set the mvpa toolbox
        subj = init_object(subj,subj_condtype,subj_condname);
        subj = set_mat(subj,subj_condtype,subj_condname,subj_condregs);
        subj = set_objfield(subj,'regressors','conds','condnames',subj_condfields);
        subj = init_object(subj,'selector','runs');
        subj = set_mat(subj,'selector','runs',subj_condruns);

        %% preprocessing
        fprintf('\n');
        fprintf('scan_mvpa: preprocessing ---------------------------------\n');
        
        % set the mvpa toolbox
        subj = zscore_runs(subj,pars_patt,'runs');
        subj = create_xvalid_indices(subj,'runs');
        subj = feature_select(subj,[pars_patt,'_z'],'conds','runs_xval');

        %% classification
        fprintf('\n');
        fprintf('scan_mvpa: classification --------------------------------\n');

        % arguments (backpropagation classifier)
        class_args.train_funct_name = 'train_bp';
        class_args.test_funct_name  = 'test_bp';
        class_args.nHidden = 0;

        % arguments (linear SMV classifier)
        %class_args.train_funct_name = 'train_svm';
        %class_args.test_funct_name  = 'test_svm';
        %class_args.kernel_type      = 0;

        % cross validation
        [subj,results] = cross_validation(subj,[pars_patt,'_z'],'conds','runs_xval',[pars_patt,'_z_thresh0.05'],class_args);

        %% save
        save(sprintf('save_mvpa_sub%02i.mat',i_sub),'subj','results')
    end

end


