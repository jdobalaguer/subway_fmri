
function scan3_mvpa_run()
    %% SCAN3_MVPA_RUN()
    % set the runs for the multi-voxel pattern analysis
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
    
    %% RUN
    for i_subject = 1:n_subject
        runs = sort(randi(mvpa_partition,1,mvpa_nscans(i_subject)));
        
        mvpa_subject(i_subject) = init_object(      mvpa_subject(i_subject) ,'selector','runs');                % selector
        mvpa_subject(i_subject) = set_mat(          mvpa_subject(i_subject) ,'selector','runs', runs);
        mvpa_subject(i_subject) = shift_regressors( mvpa_subject(i_subject) ,'conds',   'runs', mvpa_shift);    % shifting
        mvpa_subject(i_subject) = zscore_runs(      mvpa_subject(i_subject) ,'epi',     'runs');                % normalization
    end

end
