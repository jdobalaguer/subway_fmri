
function scan_preprocess4()
    
    %% WARNING
    fprintf('\ndont forget to check results of each processing step!\n\n')

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                     = [fileparts(which('spm.m')),filesep];
    dir_study                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_study,'sub_*']); dir_subs = strcat(dir_study,strvcat(dir_subs.name),'/');
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis4                   = strcat(dir_subs,'epi4',filesep);
    file_T1                     = [dir_spm,'templates/T1.nii,1'];
    
    % PARAMETERS
    pars_voxs    = 4;
    
    % VARIABLES
    nb_subjects = size(dir_subs, 1);
    u_subject   = set_subjects(sprintf('sw%dr',pars_voxs));
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    realignment('');                        % realign (estimate)
    coregistration_str_meanepi('r')         % coregistration (anatomical T1 to mean EPI)
    normalisation_str_mni('c');             % normalisation  (estimate anatomical T1 to MNI template)
    normalisation_epi_mni('r','c');         % normalisation  (write EPI to MNI template)
    smoothing(sprintf('w%dr',pars_voxs));   % smoothing
    cleanfiles('r');
    toc();
    
    %% SET SUBJECTS
    function u_subject = set_subjects(prefix)
        u_subject = nan(1,nb_subjects);
        for i_sub = 1:nb_subjects
            dir_epi4  = strtrim(dir_epis4(i_sub,:));
            fil_epi4  = dir([dir_epi4,prefix,'images_*.nii']);
            fil_epi4  = strcat(dir_epi4,strvcat(fil_epi4.name));
            nb_runs   = size(fil_epi4, 1);
            this_done = (nb_runs>1);
            u_subject(i_sub) = ~this_done;
        end
        u_subject = find(u_subject);
    end

    %% REALIGNMENT: Estimate and Write
    function realignment(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi4  = strtrim(dir_epis4(i_sub,:));
            fil_epi4  = dir([dir_epi4,prefix,'images_*.nii']);
            fil_epi4  = strcat(dir_epi4,strvcat(fil_epi4.name));
            nb_runs   = size(fil_epi4, 1);
            u_run     = 1:nb_runs;
            fprintf('Realignment for: %s\n',dir_sub);
            job = struct();
            job.spm.spatial.realign.estwrite.eoptions.quality = 0.9;  % Quality (Default: 0.9)
            job.spm.spatial.realign.estwrite.eoptions.sep = 4;        % Separation (Default: 4) 
            job.spm.spatial.realign.estwrite.eoptions.fwhm = 5;       % Smoothing (FWHM) (Default: 5)
            job.spm.spatial.realign.estwrite.eoptions.rtm = 0;        % Num Passes (Default: Register to mean) 
            job.spm.spatial.realign.estwrite.eoptions.interp = 2;     % Interpolation (Default: 2nd Degree B-Spline)
            job.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realign.estwrite.eoptions.weight = '' ;   % Weighting (Default: None) (vorher {} )
            job.spm.spatial.realign.estwrite.roptions.which = [2 1];  % Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image) 
            job.spm.spatial.realign.estwrite.roptions.interp = 4;     % Interpolation (Default: 4th Degree B-Spline) 
            job.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realign.estwrite.roptions.mask = 1;       % Masking (Default: Mask images)
            job.spm.spatial.realign.estwrite.roptions.prefix = 'r';   % Realigned files prefix
            for i_run = u_run
                if isempty(dir([dir_epi4,'rp_',prefix,'images*.txt']))
                    filenames_for_realign{i_run} = strtrim(fil_epi4(i_run,:));
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
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi4  = strtrim(dir_epis4(i_sub,:));
            fil_epi4  = dir([dir_epi4,prefix,'images_*.nii']);
            fil_epi4  = strcat(dir_epi4,strvcat(fil_epi4.name));
            nb_runs   = size(fil_epi4, 1);
            u_run     = 1:nb_runs;
            fprintf('Realign and Unwarp for: %s\n',dir_sub);
            job = struct();
            job.spm.spatial.realignunwarp.eoptions.quality = 0.9;     % Quality (Default: 0.9)
            job.spm.spatial.realignunwarp.eoptions.sep = 4;           % Separation (Default: 4) 
            job.spm.spatial.realignunwarp.eoptions.fwhm = 5;          % Smoothing (FWHM) (Default: 5)
            job.spm.spatial.realignunwarp.eoptions.rtm = 0;           % Num Passes (Default: Register to mean) 
            job.spm.spatial.realignunwarp.eoptions.einterp = 2;       % Interpolation (Default: 2nd Degree B-Spline)
            job.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];   % Wrapping (Default: No wrap) 
            job.spm.spatial.realignunwarp.eoptions.weight = '' ;      % Weighting (Default: None) (vorher {} )
            job.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1]; % Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image) 
            job.spm.spatial.realignunwarp.uwroptions.rinterp = 4;     % Interpolation (Default: 4th Degree B-Spline) 
            job.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];  % Wrapping (Default: No wrap) 
            job.spm.spatial.realignunwarp.uwroptions.mask = 1;        % Masking (Default: Mask images)
            job.spm.spatial.realignunwarp.uwroptions.prefix = 'u';    % Realigned files prefix
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
                if isempty(dir([dir_epi4,'u',prefix,'images*.nii']))
                    filenames_for_realign{i_run} = strtrim(fil_epi4(i_run,:));
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
    function coregistration_str_meanepi(prefix)
        jobs = {};
        for i_sub = u_subject
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi4  = strtrim(dir_epis4(i_sub,:));
            fil_epi4  = dir([dir_epi4,prefix,'images_*.nii']);
            fil_epi4  = strcat(dir_epi4,strvcat(fil_epi4.name));
            nb_runs   = size(fil_epi4, 1);
            u_run       = 1:nb_runs;
            file_mean = dir(strcat(dir_epi4,'meanimages*'));
            dir_str   = strtrim(dir_strs(i_sub,:));
            file_str  = dir(strcat(dir_str,'images*'));
            fprintf('Coregistration for: %s\n',dir_sub);
            if isempty(dir([dir_str,'cimages*.mat']))
                job = struct();
                copyfile([dir_str,file_str.name],[dir_str,'c',file_str.name]);
                job.spm.spatial.coreg.estimate.ref    = {[dir_epi4,file_mean.name,',1']};
                job.spm.spatial.coreg.estimate.source = {[dir_str,'c',file_str.name,',1']};
                job.spm.spatial.coreg.estimate.other  =  {''};
                job.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
                job.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                job.spm.spatial.coreg.estimate.eoptions.tol = [0.0200 0.0200 0.0200 0.0010 0.0010 0.0010 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010];
                job.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
                jobs{end+1} = job;
            end
        end
        save
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
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi4  = strtrim(dir_epis4(i_sub,:));
            fil_epi4  = dir([dir_epi4,prefix_epi,'images_*.nii']);
            fil_epi4  = strcat(dir_epi4,strvcat(fil_epi4.name));
            nb_runs   = size(fil_epi4, 1);
            u_run       = 1:nb_runs;
            dir_str   = strtrim(dir_strs(i_sub,:));
            fprintf('Normalise EPIs for: %s\n',dir_sub);
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
                if isempty(dir([dir_epi4,sprintf('w%d',pars_voxs),prefix_epi,'images*.nii']))
                    filenames_for_normalise{end+1} = strtrim(fil_epi4(i_run,:));
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
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi4  = strtrim(dir_epis4(i_sub,:));
            fil_epi4  = dir([dir_epi4,prefix,'images_*.nii']);
            fil_epi4  = strcat(dir_epi4,strvcat(fil_epi4.name));
            nb_runs   = size(fil_epi4, 1);
            u_run       = 1:nb_runs;
            fprintf('Smoothing for: %s\n',dir_sub);
            job = struct();
            job.spm.spatial.smooth.fwhm = [8 8 8];
            job.spm.spatial.smooth.dtype = 0;
            job.spm.spatial.smooth.im = 0;
            job.spm.spatial.smooth.prefix = 's';
            filenames_for_smooth = {};
            for i_run = u_run
                if isempty(dir([dir_epi4,'s',prefix,'images*.nii']))
                    filenames_for_smooth{end+1} = strtrim(fil_epi4(i_run,:));
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
        for i_sub = u_subject
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi4  = strtrim(dir_epis4(i_sub,:));
            fprintf('Cleaning files for: %s\n',dir_sub);
            for i_varargin = 1:length(varargin)
                delete([dir_epi4,varargin{i_varargin},'images*.nii']);
            end
        end
    end
end
