function scan_mvpa(region,i_sub)

    try
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
        nb_runs  = 4;
        use_epi3 = false;
        dir_sub  = sprintf('data/nii/sub_%02i/',i_sub);
        dir_nii4 = sprintf('%sepi4/', dir_sub);
        fil_nii4 = cellstr(strcat(dir_nii4,spm_select('List',dir_nii4,'^images.*\.nii$')));
        dir_nii3 = cell(1,nb_runs);
        for i_run = 1:nb_runs
            dir_nii3{i_run} = sprintf('%sepi3/run%d/images/',dir_sub,i_run);
        end

        %% static files
        mask_file = sprintf('mask_%s.nii',region);
        mask_var  = mask_resample(mask_load(region),[64,64,36]);
        mask_save(mask_var,mask_file);

        %% prepare
        fprintf('\n\n');
        fprintf('scan_mvpa: prepare\n');

        % subject
        subj_id   = sprintf('sub%02i_run%02i',i_sub,i_run);
        subj_exp  = 'subway';
        subj = init_subj(subj_id,subj_exp);

        % mask
        subj_maskname = region;
        subj_maskfile = mask_file;
        subj = load_spm_mask(subj,subj_maskname,subj_maskfile);

        % pattern
        if use_epi3
            i_run = 1;
            subj_rawfile = cellstr(strcat(dir_nii3{i_run},spm_select('List', dir_nii3{i_run}, '^images.*\.nii$')));
            subj_condruns = [];
            subj_condruns(1:length(subj_rawfile)) = i_run;
            for i_run = 2:nb_runs
                subj_rawfile = cellcat(subj_rawfile , cellstr(strcat(dir_nii3{i_run},spm_select('List',dir_nii3{i_run},'^images.*\.nii$'))));
                subj_condruns(end+1:length(subj_rawfile)) = i_run;
            end
        else
            subj_rawfile  = fil_nii4;
            subj_condruns  = [];
            for i_run = 1:nb_runs
                subj_condruns(end+1 : end+get_nii_frame(fil_nii4{i_run})) = i_run;
            end
        end
        subj_pattname = 'epi';
        subj = load_spm_pattern(subj,subj_pattname,subj_maskname,subj_rawfile);

        % conditions
        subj_condtype = 'regressors';
        subj_condname = 'conds';
        subj_condfields = {'cond1','cond2'};
        subj_condregs = gen_regressors(length(subj_condfields),length(subj_condruns));  % !!! USE REAL REGRESSORS
        subj = init_object(subj,subj_condtype,subj_condname);
        subj = set_mat(subj,subj_condtype,subj_condname,subj_condregs);
        subj = set_objfield(subj,'regressors','conds','condnames',subj_condfields);

        subj = init_object(subj,'selector','runs');
        subj = set_mat(subj,'selector','runs',subj_condruns);

        %% preprocessing
        fprintf('\n\n');
        fprintf('scan_mvpa: preprocessing\n');

        subj = zscore_runs(subj,'epi','runs');
        subj = create_xvalid_indices(subj,'runs');
        [subj] = feature_select(subj,'epi_z','conds','runs_xval');

        %% classification
        fprintf('\n\n');
        fprintf('scan_mvpa: classification\n');

        % arguments (backpropagation classifier)
        %class_args.train_funct_name = 'train_bp';
        %class_args.test_funct_name  = 'test_bp';
        %class_args.nHidden = 0;

        % arguments (linear SMV classifier)
        class_args.train_funct_name = 'train_svm';
        class_args.test_funct_name  = 'test_svm';
        class_args.kernel_type      = 0; % linear

        % cross validation
        [subj,results] = cross_validation(subj,'epi_z','conds','runs_xval','epi_z_thresh0.05',class_args);

        %% save
        save_path = sprintf('save_mvpa_sub%02i.mat',i_sub);
        save(save_path,'subj','results')

    catch err
        %% error
        save('matlab.mat');
        rethrow(err);
    end
end

%% auxiliar
% cell concat
function c = cellcat(varargin)
    assert(~isempty(varargin),'scan_mvpa: cellcat: error. empty varargin');
    c = varargin{1};
    for i = 2:length(varargin)
        c = {c{:},varargin{i}{:}};
    end
end

% generate random regressors
function r = gen_regressors(s_x,s_y)
    r = inf;
    while any(sum(r)>1)
        r   = zeros(s_x,s_y);
        s_1 = floor(s_y / s_x);
        for i_x = 1:s_x
            ii_y1 = (s_1*(i_x-1))+1;
            ii_y2 = s_1*(i_x);
            ii_y  = ii_y1:ii_y2;
            r(i_x,ii_y) = 1;
        end
    end
    r = shuffle(r,2);
end
