
function scan3_mvpa_crossvalidation()
    %% SCAN3_MVPA_CROSSVALIDATION()
    % runs the cross-validation for the multi-voxel pattern analysis
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
    global mvpa_partition mvpa_shift mvpa_nnhidden;
    
    %% CLASSIFIER
    class_args.train_funct_name = 'train_bp_netlab';
    class_args.test_funct_name  = 'test_bp_netlab';
    class_args.nHidden          = mvpa_nnhidden;
    
    %% RUN
    mvpa_result = struct('header',{},'iterations',{},'total_perf',{});
    for i_subject = 1:n_subject
        
        % indices
        mvpa_subject(i_subject) = create_xvalid_indices(mvpa_subject(i_subject),'runs');                                  
        
        % anova
        mvpa_subject(i_subject) = feature_select(mvpa_subject(i_subject),'epi_z','conds','runs_xval');

        % classification
        [mvpa_subject(i_subject), mvpa_result(i_subject)] = cross_validation(mvpa_subject(i_subject),'epi_z','conds','runs_xval','epi_z_thresh0.05',class_args);
        
    end

end
