function [subj results] = scan_mvpa(i_sub)

    %% check

    % mvpa path
    paths     = strsplit(path(),':');
    mvpa_path = fileparts(which('mvpa_add_paths'));
    if ~any(strcmp(mvpa_path,paths))
        mvpa_add_paths();
    end

    % neural networking toolbox
    if ~exist('newff')
        error('This tutorial requires the neural networking toolbox, if it is unavailable this will not execute');
    end

    %% prepare

    % subject
    subj_id   = sprintf('sub%02i',i_sub);
    subj_exp  = 'subway';
    subj_path = '';
    subj = init_subj(subj_id,subj_exp,subj_path,subj_id);

    % mask
    subj_maskname = 'mask';
    subj_maskfile = '';
    subj = load_afni_mask(subj,subj_maskname,subj_maskfile);

    % pattern
    subj_rawfile  = {''};
    subj_pattname = 'epi';
    subj = load_afni_pattern(subj,subj_patname,subj_maskname,subj_rawfile);

    % conditions

    %%% object
    subj_condtype = 'regressors';
    subj_condname = 'conds';
    subj_condregs = load('');
    subj = init_object(subj,subj_condtype,subj_condname);
    subj = set_mat(subj,subj_condtype,subj_condname,subj_condregs);

    %%% fields
    subj_condfields = {'face','house','cat','bottle','scissors','shoe','chair','scramble'};
    subj = set_objfield(subj,'regressors','conds','condnames',condnames);

    %%% runs
    subj = init_object(subj,'selector','runs');
    subj_condruns = load('');
    subj = set_mat(subj,'selector','runs',subj_condruns);

    %% preprocessing

    subj = zscore_runs(subj,'epi','runs');
    subj = create_xvalid_indices(subj,'runs');
    subj = feature_select(subj,'epi_z','conds','runs_xval');


    %% classification

    % arguments (backpropagation classifier)
    class_args.train_funct_name = 'train_bp';
    class_args.test_funct_name  = 'test_bp';
    class_args.nHidden = 0;

    % cross validation
    [subj results] = cross_validation(subj,'epi_z','conds','runs_xval','epi_z_thresh0.05',class_args);
    
    %% save
    save_path = sprintf('save_mvpa_sub%02i.mat',i_sub);
    save(subj,results)
end








