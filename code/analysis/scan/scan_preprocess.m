
function scan_preprocess()
    
    %% WARNING
    fprintf('\ndont forget to check results of each processing step!\n\n')

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                     = [fileparts(which('spm.m')),filesep];
    dir_study                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = strcat(dir_study,strvcat(strsplit(ls(dir_study),{'\n','\t'})),filesep);
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    dir_epis4                   = strcat(dir_subs,'epi4',filesep);
    expand(); % expand 4D nii to 3D nii
    dir_runs                    = strcat(strvcat(strsplit(ls([strtrim(dir_subs(1,:)),filesep,'epi3']),{'\n','\t'})),filesep);
    file_T1                     = [dir_spm,'templates/T1.nii,1'];
    
    % PARAMETERS
    pars_nslices = 36;
    pars_tr      = 2;
    pars_refsl   = ceil(.5*pars_nslices);
    pars_ordsl   = [1:2:pars_nslices,2:2:pars_nslices];
    pars_voxs    = 4;
    
    % VARIABLES
    nb_runs     = size(dir_runs, 1);
    u_run       = 1:nb_runs;
    nb_subjects = size(dir_subs, 1); 
    u_subject   = set_subjects(sprintf('sw%du',pars_voxs));
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    realignment('');                        % realign (estimate)
    realign_unwarp('');                     % realign (unwarp)
    coregistration_str_meanepi('u')         % coregistration (anatomical T1 to mean EPI)
    normalisation_str_mni('c');             % normalisation  (estimate: anatomical T1 to MNI template)
    normalisation_epi_mni('u','c');         % normalisation  (write:    EPI to MNI template)
    smoothing(sprintf('w%du',pars_voxs));   % smoothing
    cleanfiles('u',sprintf('w%du',pars_voxs));
    toc();
        
%     tic();
%     spm_jobman('initcfg');
%     realignment('');                        % realign (estimate)
%     realign_unwarp('');                     % realign (unwarp)
%     slice_timing('u');                      % slice timing -- why after realignment?
%     coregistration_str_meanepi('u')         % coregistration (anatomical T1 to mean EPI)
%     normalisation_str_mni('c');             % normalisation  (estimate: anatomical T1 to MNI template)
%     normalisation_epi_mni('au','c');        % normalisation  (write:    EPI to MNI template)
%     smoothing(sprintf('w%dau',pars_voxs));  % smoothing
%     cleanfiles('u','au',sprintf('w%dau',pars_voxs));
%     toc();
    
    %% EXPAND: nii4 to nii3
    function expand()
        for i_sub = 1:size(dir_subs, 1); 
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_epi4 = strtrim(dir_epis4(i_sub,:));
            file_epis4 = dir([dir_epi4,'images*.nii']);
            fprintf('Expand for: %s\n',dir_sub);
            for i_run = 1:length(file_epis4)
                dir_run   = sprintf('%srun%d/',dir_epi3,i_run);
                if ~exist(dir_run,'dir'); mkdir(dir_run); end
                dir_img   = strcat(dir_run,'images',filesep);
                if ~exist(dir_img,'dir'); mkdir(dir_img); end
                file_epi4 = strcat(dir_epi4,file_epis4(i_run).name);
                if isempty(dir([dir_img,'images*.nii']))
                    spm_file_split(file_epi4,dir_img);
                end
            end
        end
    end
    
    %% SET SUBJECTS
    function u_subject = set_subjects(prefix)
        u_subject = nan(1,nb_subjects);
        for i_sub = 1:nb_subjects
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            fprintf('Checking for: %s\n',dir_sub);
            this_done = 1;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                if isempty(dir([dir_img,prefix,'images*.nii']))
                    this_done = 0;
                end
            end
            u_subject(i_sub) = ~this_done;
        end
        u_subject = find(u_subject);
    end

    %% REALIGNMENT: Estimate and Write
    function realignment(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            fprintf('Realignment for: %s\n',dir_sub);
            job = struct();
            job.spm.spatial.realign.estwrite.eoptions.quality = 0.9;  % Quality (Default: 0.9)
            job.spm.spatial.realign.estwrite.eoptions.sep = 4;        % Separation (Default: 4) 
            job.spm.spatial.realign.estwrite.eoptions.fwhm = 5;       % Smoothing (FWHM) (Default: 5)
            job.spm.spatial.realign.estwrite.eoptions.rtm = 0;        % Num Passes (Default: Register to mean) 
            job.spm.spatial.realign.estwrite.eoptions.interp = 2;     % Interpolation (Default: 2nd Degree B-Spline)
            job.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realign.estwrite.eoptions.weight = '' ;   % Weighting (Default: None) (vorher {} )
            job.spm.spatial.realign.estwrite.roptions.which = [0 1];  % Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image) 
            job.spm.spatial.realign.estwrite.roptions.interp = 4;     % Interpolation (Default: 4th Degree B-Spline) 
            job.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realign.estwrite.roptions.mask = 1;       % Masking (Default: Mask images)
            job.spm.spatial.realign.estwrite.roptions.prefix = 'r';   % Realigned files prefix
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                if isempty(dir([dir_img,'rp_',prefix,'images*.txt']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run}    = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_realign{i_run} = strcat(dir_img,prefix,raw_func_filenames{i_run}); 
                    job.spm.spatial.realign.estwrite.data{i_run} = cellstr(filenames_for_realign{i_run});
                end
            end
            if isfield(job.spm.spatial.realign.estwrite,'data'); jobs{end+1} = job; end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs
    end

    %% REALIGN & UNWARP
    function realign_unwarp(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            fprintf('Realign and Unwarp for: %s\n',dir_sub);
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
            job.spm.spatial.realignunwarp.uwroptions.prefix = 'u';   % Realigned files prefix
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
                if isempty(dir([dir_img,'u',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run}    = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_realign{i_run} = strcat(dir_img,prefix,raw_func_filenames{i_run}); 
                    job.spm.spatial.realignunwarp.data(i_run).scans = cellstr(filenames_for_realign{i_run});
                    job.spm.spatial.realignunwarp.data(i_run).pmscan = [];
                end
            end
            if isfield(job.spm.spatial.realignunwarp,'data'); jobs{end+1} = job; end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end
    
    %% SLICE TIMING
    function slice_timing(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            fprintf('Slice-Timing for: %s\n',dir_sub);
            job = struct();
            job.spm.temporal.st.nslices = pars_nslices;
            job.spm.temporal.st.tr = pars_tr;
            job.spm.temporal.st.ta = pars_tr- (pars_tr/pars_nslices);
            job.spm.temporal.st.so = pars_ordsl;
            job.spm.temporal.st.refslice = pars_refsl;
            job.spm.temporal.st.prefix = 'a';
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                if isempty(dir([dir_img,'a',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run} = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_st{i_run}   = strcat(dir_img,prefix,raw_func_filenames{i_run});
                    job.spm.temporal.st.scans{i_run} = cellstr(filenames_for_st{i_run});
                end
            end
            if isfield(job.spm.temporal.st,'scans'); jobs{end+1} = job; end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end

    %% COREGISTRATION: Anatomical T1 to mean EPI
    function coregistration_str_meanepi(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi3  = strtrim(dir_epis3(i_sub,:));
            dir_run   = strcat(dir_epi3,strtrim(dir_runs(1,:)));
            dir_img   = strcat(dir_run,'images',filesep);
            file_mean = dir(strcat(dir_img,'mean',prefix,'images*'));
            dir_str   = strtrim(dir_strs(i_sub,:));
            file_str  = dir(strcat(dir_str,'images*'));
            fprintf('Coregistration for: %s\n',dir_sub);
            if isempty(dir([dir_str,'cimages*']))
                job = struct();
                copyfile([dir_str,file_str.name],[dir_str,'c',file_str.name]);
                job.spm.spatial.coreg.estimate.ref    = {[dir_img,file_mean.name,',1']};
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
            fprintf('Normalise Anatomy for: %s\n',dir_sub);
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
    function normalisation_epi_mni(prefix_epi,prefix_str)
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_str   = strtrim(dir_strs(i_sub,:));
            fprintf('Writing the normalized epis for: %s\n',dir_sub);
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
                if isempty(dir([dir_img,sprintf('w%d',pars_voxs),prefix_epi,'images*.nii']))
                    dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                    dir_img = strcat(dir_run,'images',filesep);
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run} = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_normalise{end+1} = strcat(dir_img,prefix_epi,raw_func_filenames{i_run});
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
    function smoothing(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            fprintf('Smoothing for: %s\n',dir_sub);
            job = struct();
            job.spm.spatial.smooth.fwhm = [8 8 8];
            job.spm.spatial.smooth.dtype = 0;
            job.spm.spatial.smooth.im = 0;
            job.spm.spatial.smooth.prefix = 's';
            filenames_for_smooth = {};
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                if isempty(dir([dir_img,'s',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run}    = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_smooth{end+1} = strcat(dir_img,prefix,raw_func_filenames{i_run});
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

    %% CLEAN FILES
    function cleanfiles(varargin)
        for i_varargin = 1:length(varargin)
            for i = 1:nb_subjects
                dir_sub = strtrim(dir_subs(i,:));
                dir_epi3 = strtrim(dir_epis3(i,:));
                fprintf('Cleaning files for: %s\n',dir_sub);
                for j = u_run
                    dir_run = strcat(dir_epi3,strtrim(dir_runs(j,:)));
                    dir_img = strcat(dir_run,'images',filesep);
                    delete([dir_img,varargin{i_varargin},'images*.nii']);
                end
            end
        end
    end
end
