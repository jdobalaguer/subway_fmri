
function scan3_preprocess()
    %% SCAN3_PREPROCESS()
    % pre-processing pipeline (3d format)
    % see also scan3_expand
    %          scan3_glm
    %          scan3_mvpa
    
    %% WARNINGS
    %#ok<*AGROW>
    %#ok<*DEFNU>
    %#ok<*FPARK>
    %#ok<*NBRAK>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                     = [fileparts(which('spm.m')),filesep];
    dir_study                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_study,'sub_*']); dir_subs = strcat(dir_study,strvcat(dir_subs.name),'/');
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    file_T1                     = [dir_spm,'templates/T1.nii,1'];
    
    % PARAMETERS
    pars_nslices = 32;
    pars_tr      = 2;
    pars_refsl   = [];
    pars_ordsl   = [];
    pars_reft0   = 0;
    pars_voxs    = 4;
    
    % VARIABLES
    nb_subjects = size(dir_subs, 1); 
    u_subject   = set_subjects();
    
    %% SPM
    if ~exist('spm.m','file'), spm8_add_paths(); end
    spm_jobman('initcfg');
    
    %% JOBS
%     tic();
%     spm_jobman('initcfg');
%     despike(                    'images',       'spikes',           '','g'                      );  % despike
%     despike_move(               'images',       'spikes',           '','g'                      );  % despike           (move)
%     image_compression(                                                                          );  % image             (compression)
%     realignment_unwarp(         'spikes',       'realignment',      'g','u'                     );  % realignment
%     realignment_move(           'spikes',       'realignment',      'g','u'                     );  % realignment       (move)
%     despike_compression(                                                                        );  % despike           (compression)
%     coregistration_str_meanepi( 'realignment',                      'ug','c'                    );  % coregistration    (anatomical T1 to mean EPI)
%     normalisation_str_mni(                                          'c'                         );  % normalisation     (anatomical T1 to MNI template)
%     normalisation_epi_mni(      'realignment',  'normalisation',    'ug',   'c'                 );  % normalisation     (EPI to MNI template)
%     normalisation_move(         'realignment',  'normalisation',    'ug'                        );  % normalisation     (move files)
%     realignment_compression(                                                                    );  % realignment       (compression)
%     smoothing(                  'normalisation','smooth'            ,sprintf('w%dug',pars_voxs) );  % smoothing
%     smoothing_move(             'normalisation','smooth'            ,sprintf('w%dug',pars_voxs) );  % smoothing         (move files)
%     normalisation_compression(                                                                  );  % normalisation     (compression)
%     toc();
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    
    realignment_unwarp(         'images',       'realignment',      '', 'u'                     );  % realignment
    move(                       'images',       'realignment',      'u'                         );  % realignment       (move)
    
    compression(                'images'                                                        );  % image             (compression)
    remove(                     'images'                                                        );  % image             (remove)
    
    coregistration_str_meanepi( 'realignment',                      'u', 'c'                    );  % coregistration    (anatomical T1 to mean EPI)
    normalisation_str_mni(                                          'c'                         );  % normalisation     (anatomical T1 to MNI template)
    normalisation_epi_mni(      'realignment',  'normalisation',    'u', 'c'                    );  % normalisation     (EPI to MNI template)
    move(                       'realignment',  'normalisation',    'u'                         );  % normalisation     (move files)
    
    compression(                'realignment'                                                   );  % realignment       (compression)
    scan_clean(                 'nii3rea'                                                       );  % realignment       (clean)
    
    smoothing(                  'normalisation','smooth'            ,sprintf('w%du',pars_voxs)  );  % smoothing
    move(                       'normalisation','smooth'            ,sprintf('w%du',pars_voxs)  );  % smoothing         (move files)
    
    remove(                     'normalisation'                                                 );  % normalisation     (remove)
    
    toc();
    
    %% SET SUBJECTS
    function u_subject = set_subjects()
        u_subject = nan(1,nb_subjects);
        for i_sub = 1:nb_subjects
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Checking for:                    %s\n',dir_sub);
            this_done = 1;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_smt = strcat(dir_run,'smooth',filesep);
                if ~exist(dir_smt,'dir') || isempty(dir(sprintf('%ssw%duagimages*.nii',dir_smt,pars_voxs)))
                    this_done = 0;
                end
            end
            u_subject(i_sub) = ~this_done;
        end
        u_subject = find(u_subject);
    end

    %% SPIKE CORRECTION
    function despike(df,dt,pf,pt)
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),filesep);
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Spike correction for:            %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_frm = strcat(dir_run,df,filesep);
                dir_too = strcat(dir_run,dt,filesep);
                if ~exist(dir_too,'dir') || isempty(dir([dir_too,pt,pf,'images*.nii']))
                    spm_select('clearvfiles');
                    run_images = spm_select('List', dir_img, ['^',pf,'images.*\.nii$']);
                    filenames   = strcat(dir_frm,run_images);
                    art_slice(filenames);
                end
            end
       end
    end
    
    %% REALIGN : UNWARP
    function realignment_unwarp(df,dt,pf,pt)
        jobs = {};
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Realign and Unwarp for:          %s\n',dir_sub);
            job = struct();
            job.spm.spatial.realignunwarp.eoptions.quality = 0.9;  % Quality (Default: 0.9)
            job.spm.spatial.realignunwarp.eoptions.sep = 4;        % Separation (Default: 4) 
            job.spm.spatial.realignunwarp.eoptions.fwhm = 5;       % Smoothing (FWHM) (Default: 5)
            job.spm.spatial.realignunwarp.eoptions.rtm = 0;        % Num Passes (Default: Register to mean) 
            job.spm.spatial.realignunwarp.eoptions.einterp = 2;     % Interpolation (Default: 2nd Degree B-Spline)
            job.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realignunwarp.eoptions.weight = '' ;   % Weighting (Default: None) (vorher {} )
            job.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];  % Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image) 
            job.spm.spatial.realignunwarp.uwroptions.rinterp = 4;     % Interpolation (Default: 4th Degree B-Spline) 
            job.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realignunwarp.uwroptions.mask = 1;       % Masking (Default: Mask images)
            job.spm.spatial.realignunwarp.uwroptions.prefix = pt;   % Realigned files prefix
            job.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
            job.spm.spatial.realignunwarp.uweoptions.regorder = 1;
            job.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
            job.spm.spatial.realignunwarp.uweoptions.jm = 0;
            job.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
            job.spm.spatial.realignunwarp.uweoptions.sot = [];
            job.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
            job.spm.spatial.realignunwarp.uweoptions.rem = 1;
            job.spm.spatial.realignunwarp.uweoptions.noi = 5;
            job.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_frm = strcat(dir_run,df,filesep);
                dir_too = strcat(dir_run,dt,filesep);
                if ~exist(dir_too,'dir') || isempty(dir([dir_too,pt,pf,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run}    = spm_select('List', dir_frm,['^',pf,'images.*\.nii$']);
                    filenames_for_realign{i_run} = strcat(dir_frm,raw_func_filenames{i_run}); 
                    job.spm.spatial.realignunwarp.data(i_run).scans = cellstr(filenames_for_realign{i_run});
                    job.spm.spatial.realignunwarp.data(i_run).pmscan = [];
                end
            end
            if isfield(job.spm.spatial.realignunwarp,'data'); jobs{end+1} = job; end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end
    
    %% COREGISTRATION: Anatomical T1 to mean EPI
    function coregistration_str_meanepi(dr,pf,pt)
        jobs = {};
        for i_sub = u_subject
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi3  = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            dir_run   = strcat(dir_epi3,strtrim(dir_runs(1,:)));
            dir_rea   = strcat(dir_run,dr,filesep);
            file_mean = dir(strcat(dir_rea,'mean',pf,'images*'));
            dir_str   = strtrim(dir_strs(i_sub,:));
            file_str  = dir(strcat(dir_str,'images*'));
            fprintf('Coregistration for:              %s\n',dir_sub);
            if isempty(dir([dir_str,'cimages*']))
                job = struct();
                copyfile([dir_str,file_str.name],[dir_str,pt,file_str.name]);
                job.spm.spatial.coreg.estimate.ref    = {[dir_rea,file_mean.name,',1']};
                job.spm.spatial.coreg.estimate.source = {[dir_str,'c',file_str.name,',1']};
                job.spm.spatial.coreg.estimate.other  =  {''};
                job.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
                job.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                job.spm.spatial.coreg.estimate.eoptions.tol = [0.0200 0.0200 0.0200 0.0010 0.0010 0.0010 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010];
                job.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end

    %% NORMALISATION (Estimate and Write for Anatomical T1)
    function normalisation_str_mni(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_str   = strtrim(dir_strs(i_sub,:));
            file_str  = dir(strcat(dir_str,prefix,'images*.nii'));
            fprintf('Normalise Anatomy for:           %s\n',dir_sub);
            if isempty(dir([dir_str,sprintf('w%d%simages*',pars_voxs,prefix)]))
                job = struct();
                job.spm.spatial.normalise.estwrite.subj.source = {[dir_str,file_str.name]};% Image to estimate warping parameters: HIGHRES
                job.spm.spatial.normalise.estwrite.subj.wtsrc = {};        % Source Weighting Image: None
                job.spm.spatial.normalise.estwrite.subj.resample = {[dir_str,file_str.name]};% Images to write according to warping parameters: HIGHRES 
                job.spm.spatial.normalise.estwrite.eoptions.template = {file_T1};% Template Image
                job.spm.spatial.normalise.estwrite.eoptions.weight = {};   % Template Weighting Imaging, Default: None
                job.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;    % Source Image Smoothing, Default: 8
                job.spm.spatial.normalise.estwrite.eoptions.smoref = 0;    % Template Image Smoothing, Default: 0
                job.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni'; % Affine Regularisation, Default: ICBM/MNI Space Template
                job.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;   % Nonlinear Frequency Cutoff, Default: 25
                job.spm.spatial.normalise.estwrite.eoptions.nits = 16;     % Nonlinear Iterations, Default: 16
                job.spm.spatial.normalise.estwrite.eoptions.reg = 1;       % Nonlinear Regularisation, Default: 1
                job.spm.spatial.normalise.estwrite.roptions.preserve = 0;  % Default: 0 = Preserve Concentrations
                job.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -70;78 76 85]; % Bounding Box
                job.spm.spatial.normalise.estwrite.roptions.vox = [pars_voxs pars_voxs pars_voxs]; % Voxel Sizes [2 2 2] is default
                job.spm.spatial.normalise.estwrite.roptions.interp = 1;    % Interpolation (Default: 1)
                job.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];% Wrapping, 0: No
                job.spm.spatial.normalise.estwrite.roptions.prefix = sprintf('w%d',pars_voxs); % Prefix
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end

    %% NORMALISATION (Write EPIs)
    function normalisation_epi_mni(df,dt,prefix_epi,prefix_str)
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_str   = strtrim(dir_strs(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Writing normalized epis for:     %s\n',dir_sub);
            param_for_normalise_file = dir([dir_str,prefix_str,'*_sn.mat']);
            job = struct();
            job.spm.spatial.normalise.write.roptions.preserve = 0;
            job.spm.spatial.normalise.write.roptions.bb = [-78 -112 -50; 78 76 85];
            job.spm.spatial.normalise.write.roptions.vox = [pars_voxs pars_voxs pars_voxs];
            job.spm.spatial.normalise.write.roptions.interp = 1;
            job.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
            job.spm.spatial.normalise.write.roptions.prefix = sprintf('w%d',pars_voxs);
            filenames_for_normalise = {};
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_frm = strcat(dir_run,df,filesep);
                dir_too = strcat(dir_run,dt,filesep);
                if ~exist(dir_too,'dir') || isempty(dir([dir_too,sprintf('w%d',pars_voxs),prefix_epi,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run} = spm_select('List', dir_frm, ['^',prefix_epi,'images.*\.nii$']);
                    filenames_for_normalise{end+1} = strcat(dir_frm,raw_func_filenames{i_run});
                end
            end
            if ~isempty(filenames_for_normalise)
                job.spm.spatial.normalise.write.subj.resample = cellstr(strvcat(filenames_for_normalise));
                job.spm.spatial.normalise.write.subj.matname = {[dir_str,param_for_normalise_file.name]};
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end
    
    %% SMOOTH
    function smoothing(df,dt,prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Smoothing for:                   %s\n',dir_sub);
            job = struct();
            job.spm.spatial.smooth.fwhm = [8 8 8];
            job.spm.spatial.smooth.dtype = 0;
            job.spm.spatial.smooth.im = 0;
            job.spm.spatial.smooth.prefix = 's';
            filenames_for_smooth = {};
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_frm = strcat(dir_run,df,filesep);
                dir_too = strcat(dir_run,dt,filesep);
                if ~exist(dir_too,'dir') || isempty(dir([dir_too,'s',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run}    = spm_select('List', dir_frm, ['^',prefix,'images.*\.nii$']);
                    filenames_for_smooth{end+1} = strcat(dir_frm,raw_func_filenames{i_run});
                end
            end
            if ~isempty(filenames_for_smooth)
                job.spm.spatial.smooth.data = cellstr(strvcat(filenames_for_smooth));
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end
    
    %% AUXILIAR

    % Move
    function move(df,dt,prefix)
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Move files for:          %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_frm = strcat(dir_run,df,filesep);
                dir_too = strcat(dir_run,dt,filesep);
                mkdirp(dir_too);
                if ~isempty(dir([dir_frm,prefix,'image*'])), movefile([dir_frm,prefix,'image*'],dir_too); end
            end
        end
    end
    
    % Compression
    function compression(df)
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Compression files for:    %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_frm = strcat(dir_run,df,filesep);
                zip_too = strcat(dir_run,df,'.zip');
                zip(zip_too,dir_frm);
            end
        end
    end

    % Clean
    function remove(df)
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Remove files for:    %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_frm = strcat(dir_run,df,filesep);
                rmdir(dir_frm,'s');
            end
        end
    end
end

