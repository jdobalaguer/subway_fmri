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
        %error('This tutorial requires the neural networking toolbox, if it is unavailable this will not execute');
    end

    %% static variables
    nb_runs = 4;
    dir_sub = sprintf('data/nii/sub_%02i/',i_sub);
    dir_img = cell(1,nb_runs);
    for i_run = 1:nb_runs
        dir_img{i_run} = sprintf('%sepi3/run%d/images/',dir_sub,i_run);
    end
    
    %% prepare

    % subject
    subj_id   = sprintf('sub%02i_run%02i',i_sub,i_run);
    subj_exp  = 'subway';
    subj = init_subj(subj_id,subj_exp);

    % mask
    subj_maskname = 'maskname';
    subj_maskfile = 'maskfile';
    subj = load_afni_mask(subj,subj_maskname,subj_maskfile);

    % pattern
    subj_rawfile  = cellstr(spm_select('List', dir_img{1}, '^images.*\.nii$'));
    for i_run = 2:nb_runs
        subj_rawfile = cellcat(subj_rawfile , cellstr(spm_select('List',dir_img{i_run},'^images.*\.nii$')));
    end
    subj_pattname = 'epi';
    subj = load_afni_pattern(subj,subj_pattname,subj_maskname,subj_rawfile);

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
    [subj,results] = cross_validation(subj,'epi_z','conds','runs_xval','epi_z_thresh0.05',class_args);
    
    %% save
    save_path = sprintf('save_mvpa_sub%02i_run%02i.mat',i_sub,i_run);
    save(save_path,subj,results)
end

function c = cellcat(varargin)
    assert(~isempty(varargin),'scan_mvpa: cellcat: error. empty varargin');
    c = varargin{1};
    for i = 2:length(varargin)
        c = {c{:},varargin{i}{:}};
    end
end







