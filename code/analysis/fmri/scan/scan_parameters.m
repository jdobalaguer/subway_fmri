
function scan_parameters()
    %% SCAN_PARAMETERS()
    % declares global variables shared across scan_() and scan3_() functions
    % see also scan3_preprocess
    %          scan3_glm
    %          scan3_mvpa
    
    %% WARNING
    %#ok<*NBRAK,*FPARK>

    %% DIRECTORIES
    % declaration
    global name_glm name_mvpa;
    global dire_spm dire_mask dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mvpa;
    % values
    dire_spm                        = [fileparts(which('spm.m')),filesep];
    dire_mask                       = [pwd(),filesep,'data',filesep,'mask',filesep];
    dire_nii                        = [pwd(),filesep,'data',filesep,'nii',filesep];
    dire_nii_subs                   = dir([dire_nii,'sub_*']); dire_nii_subs = strcat(dire_nii,strvcat(dire_nii_subs.name),'/');
    dire_nii_epi4                   = strcat(dire_nii_subs,'epi4',filesep);
    dire_nii_epi3                   = strcat(dire_nii_subs,'epi3',filesep);
    dire_nii_str                    = strcat(dire_nii_subs,'str',filesep);
    dire_glm                        = [pwd(),filesep,'data',filesep,'glm',filesep,name_glm,filesep];
    dire_glm_condition              = [dire_glm,'conditions',filesep];
    dire_glm_firstlevel             = [dire_glm,'firstlevel',filesep];
    dire_glm_secondlevel            = [dire_glm,'secondlevel',filesep];
    dire_glm_contrast               = [dire_glm,'contrasts',filesep];
    dire_mvpa                       = [pwd(),filesep,'data',filesep,'mvpa',filesep,name_mvpa,filesep];
    
    %% FILES
    % declaration
    global name_mask;
    global file_mask file_T1;
    % values
    if isempty(name_mask), file_mask = ''; else file_mask = [dire_mask,name_mask,'.img,1']; end
    file_T1                          = [dire_spm,'templates/T1.nii,1'];
    
    %% SCANNER PARAMETERS
    % declaration
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    % values
    pars_nslices = 32;                                                          ... number of slices
    pars_tr      = 2;                                                           ... repetition time
    pars_ordsl   = [pars_nslices:-1:+1];                                        ... slices scanning order
    pars_refsl   = pars_ordsl(1);                                               ... reference slice index
    pars_reft0   = (find(pars_ordsl==pars_refsl)-1) * (pars_tr/pars_nslices);   ... scan time for reference slice
    pars_voxs    = 4;                                                           ... sub-sampling
    
    %% SUBJECT variables
    global r_subject;
    global n_subject u_subject;
    u_subject   = 1:size(dire_nii_subs, 1);
    u_subject(jb_anyof(u_subject,r_subject)) = [];
    n_subject   = length(u_subject);
    
    %% GLM PARAMETERS
    global glm_function glm_ordfir glm_lenfir glm_delay glm_marge glm_regressors;
    glm_function   = 'hrf';     ... "hrf" "fir"
    glm_ordfir     = 12;        ... order of FIR
    glm_lenfir     = 12;        ... time length of FIR
    glm_delay      = 0;         ... delay shift for onsets
    glm_marge      = 5;         ... marge between onsets and last scan
    glm_regressors = struct('subject',{},'session',{},'onset',{},'discard',{},'name',{},'subname',{},'level',{});
    
    %% MVPA PARAMETERS
    global mvpa_partition mvpa_shift mvpa_nnhidden;
    mvpa_partition = 4;         ... number of partitions for cross-validation (>1)
    mvpa_shift     = 0;         ... shift regressors aiming for the HRF peak (only if not convolved)  
    mvpa_nnhidden  = 50;        ... hidden neurons for the nn-classifier
    
end