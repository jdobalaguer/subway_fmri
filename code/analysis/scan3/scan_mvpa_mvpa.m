
function scan_mvpa_mvpa(tmp_workspace)
    tools_setworkspace;
    
    fprintf('\n\n');
    fprintf('scan_mvpa: participant %02i ================================\n',i_sub);

    %% set paths
    dir_sub  = strtrim(dir_subs(i_sub,:));
    dir_nii3 = cell(1,nb_runs);
    for i_run = 1:nb_runs
        dir_nii3{i_run} = sprintf('%sepi3/run%d/images/',dir_sub,i_run);
    end

    %% build subject
    fprintf('scan_mvpa: build subject ---------------------------------\n');

    % set the mvpa toolbox
    subj_id   = sprintf('sub%02i',i_sub);
    subj_exp  = 'subway';
    subj = init_subj(subj_id,subj_exp);

    %% build mask
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
    fprintf('scan_mvpa: build pattern ---------------------------------\n');

    i_run = 1;
    subj_rawfile = cellstr(strcat(dir_nii3{i_run},spm_select('List', dir_nii3{i_run}, '^sw4uimages.*\.nii$')));
    subj_condruns = [];
    subj_condruns(1:length(subj_rawfile)) = i_run;
    for i_run = 2:nb_runs
        subj_rawfile = tools_cellcat(subj_rawfile , cellstr(strcat(dir_nii3{i_run},spm_select('List',dir_nii3{i_run},'^sw4uimages.*\.nii$'))));
        subj_condruns(end+1:length(subj_rawfile)) = i_run;
    end
    %subj_rawfile  = fil_nii4;
    %subj_condruns  = [];
    %for i_run = 1:nb_runs
    %    subj_condruns(end+1 : end+get_nii_frame(fil_nii4{i_run})) = i_run;
    %end
    subj_pattname = 'betas';
    subj = load_spm_pattern(subj,subj_pattname,subj_maskname,subj_rawfile);

    %% build regressors
    fprintf('scan_mvpa: build regressors ------------------------------\n');

    % variables
    subj_condtype   = 'regressors';
    subj_condname   = 'conds';
    subj_condfields = {'screen_block','screen_rew','avatar_regular','avatar_exchange'};

    % regressor
    tools_getworkspace;
    subj_condregs = scan_mvpa_regressors(tmp_workspace);
    %subj_condregs = scan_mvpa_randomregressors(tmp_workspace);
    clear('tmp_workspace');

    % set the mvpa toolbox
    subj = init_object(subj,subj_condtype,subj_condname);
    subj = set_mat(subj,subj_condtype,subj_condname,subj_condregs);
    subj = set_objfield(subj,'regressors','conds','condnames',subj_condfields);
    subj = init_object(subj,'selector','runs');
    subj = set_mat(subj,'selector','runs',subj_condruns);

    %% preprocessing
    fprintf('scan_mvpa: preprocessing ---------------------------------\n');

    % set the mvpa toolbox
    subj = zscore_runs(subj,subj_pattname,'runs');
    subj = create_xvalid_indices(subj,'runs');
    subj = feature_select(subj,[subj_pattname,'_z'],'conds','runs_xval');

    %% classification
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
    [subj,results] = cross_validation(subj,['betas','_z'],'conds','runs_xval',['betas','_z_thresh0.05'],class_args);

    %% save
    save(sprintf('save_mvpa_sub%02i.mat',i_sub),'subj','results')
end
