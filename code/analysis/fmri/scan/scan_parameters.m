
function scan = scan_parameters(scan)
    %% SCAN_PARAMETERS()
    %set struct shared across scan_() and scan3_() functions
    % see also scan3_preprocess
    %          scan3_glm
    %          scan3_mvpa
    
    %% WARNING
    %#ok<*NBRAK,*FPARK>
    
    %% SCANNER
    scan.pars.nslices = 32;                                                                             ... number of slices
    scan.pars.tr      = 2;                                                                              ... repetition time
    scan.pars.ordsl   = [scan.pars.nslices:-1:+1];                                                      ... slices scanning order
    scan.pars.refsl   = scan.pars.ordsl(1);                                                             ... reference slice index
    scan.pars.reft0   = (find(scan.pars.ordsl==scan.pars.refsl)-1) * (scan.pars.tr/scan.pars.nslices);  ... scan time for reference slice
    scan.pars.voxs    = 4;                                                                              ... sub-sampling
    
    %% GLM
    if ~isfield(scan,'glm')
        scan.glm.name       = 'unnamed'; ... identifier
        scan.glm.image      = 'smooth';  ... "image" "normalization" "smooth"
        scan.glm.function   = 'hrf';     ... "hrf" "fir"
        scan.glm.fir.ord    = 8;         ... order of FIR
        scan.glm.fir.len    = 14;        ... time length of FIR
        scan.glm.hrf.ord    = [0 0];     ... temporal derivative and sparsity
        scan.glm.delay      = 0;         ... delay shift for onsets
        scan.glm.marge      = 5;         ... marge between onsets and last scan
        scan.glm.regressor  = struct('subject',{},'session',{},'onset',{},'discard',{},'name',{},'subname',{},'level',{});
        scan.glm.contrast   = struct('name',{},'convec',{});
        scan.glm.peri.mask  = '';
        scan.glm.peri.contrast  = '';
        scan.glm.peri.extension = 'img';
    end
    
    %% MVPA
    if ~isfield(scan,'mvpa')
        scan.mvpa.name = '';
        scan.mvpa.mask = '';
        scan.mvpa.partition = 4;         ... number of partitions for cross-validation (>1)
        scan.mvpa.shift     = 0;         ... shift regressors aiming for the HRF peak (only if not convolved)  
        scan.mvpa.nn.hidden = 50;        ... hidden neurons for the nn-classifier
    end
    
    %% DIRECTORIES
    scan.dire.root                       = pwd();
    scan.dire.spm                        = [fileparts(which('spm.m')),filesep];
    scan.dire.mask                       = [scan.dire.root,filesep,'data',filesep,'mask',filesep];
    scan.dire.nii                        = [scan.dire.root,filesep,'data',filesep,'nii',filesep];
    scan.dire.nii_subs                   = dir([scan.dire.nii,'sub_*']); scan.dire.nii_subs = strcat(scan.dire.nii,strvcat(scan.dire.nii_subs.name),'/');
    scan.dire.nii_epi4                   = strcat(scan.dire.nii_subs,'epi4',filesep);
    scan.dire.nii_epi3                   = strcat(scan.dire.nii_subs,'epi3',filesep);
    scan.dire.nii_str                    = strcat(scan.dire.nii_subs,'str',filesep);
    scan.dire.glm                        = [scan.dire.root,filesep,'data',filesep,'glm',filesep,scan.glm.name,filesep];
    scan.dire.glm_condition              = [scan.dire.glm,'conditions',filesep];
    scan.dire.glm_firstlevel             = [scan.dire.glm,'firstlevel',filesep];
    scan.dire.glm_secondlevel            = [scan.dire.glm,'secondlevel',filesep];
    scan.dire.glm_beta                   = [scan.dire.glm,'betas',filesep];
    scan.dire.glm_contrast               = [scan.dire.glm,'contrasts',filesep];
    scan.dire.mvpa                       = [scan.dire.root,filesep,'data',filesep,'mvpa',filesep,scan.mvpa.name,filesep];
    
    %% FILES
    if isempty(scan.mvpa.mask), scan.file.mvpa_mask = ''; else scan.file.mvpa_mask = [scan.dire.mask,scan.mvpa.mask,'.img,1']; end
    scan.file.T1 = [scan.dire.spm,'templates/T1.nii,1'];
    
    %% SUBJECT variables
    if ~isfield(scan,'subject'), scan.subject.r = []; end
    if ~isfield(scan.subject,'u'),
        scan.subject.u   = 1:size(scan.dire.nii_subs, 1);
        scan.subject.u(jb_anyof(scan.subject.u,scan.subject.r)) = [];
    end
    scan.subject.n   = length(scan.subject.u);
    
end