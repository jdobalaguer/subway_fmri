
function scan3_mvpa_initialize()
    %% SCAN3_MVPA_INITIALIZE()
    % initialize variables for the multi-voxel pattern analysis
    % see also scan3_mvpa

    %%  WARNINGS
    %#ok<*NUSED>
    
    %% GLOBAL PARAMETERS
    global name_glm name_mvpa name_mask name_image r_subject do_pooling;
    global n_subject u_subject;
    global mvpa_subject mvpa_nscans mvpa_result;
    
    global dire_spm dire_nii dire_nii_subs dire_nii_epi4 dire_nii_epi3 dire_nii_str dire_glm dire_glm_condition dire_glm_firstlevel dire_glm_secondlevel dire_glm_contrast dire_mask;
    global file_mask file_T1;
    global pars_nslices pars_tr pars_ordsl pars_refsl pars_reft0 pars_voxs;
    global mvpa_partition mvpa_shift;
    
    %% INITIALIZE
    mvpa_subject = init_subj('','');
    mvpa_nscans  = [];
    for i_subject = 1:n_subject
        subject  = u_subject(i_subject);
        mvpa_subject(i_subject) = init_subj(name_mvpa,sprintf('subject_%02i',subject));
    end

end