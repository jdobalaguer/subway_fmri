
function scan3_mvpa_regressor()
    %% SCAN3_MVPA_REGRESSOR()
    % set the regressors for the multi-voxel pattern analysis
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
    
    %% REGRESSOR
    for i_subject = 1:n_subject
        subject  = u_subject(i_subject);
        
        % get values
        SPM = load(sprintf('data/glm/%s/firstlevel/sub_%02i/SPM.mat',name_glm,subject));
        value_regressor = ([SPM.SPM.Sess.U(1).P(:).P]' > 0);
        onset_regressor = SPM.SPM.Sess.U(1).ons';
        onset_scan      = SPM.SPM.xY.RT * (0 : mvpa_nscans(i_subject) - 1);
        value_scan      = nan(size(onset_scan));
        
        % calculate regressor
        for i_scan = 1:length(onset_scan)
            [~,i_regressor] = min(abs(onset_regressor - onset_scan(i_scan)));
            tmp_v = value_regressor(:,i_regressor);
            switch(sum(tmp_v))
                case 0
                    value_scan(i_scan) = 0;
                case 1
                    value_scan(i_scan) = find(tmp_v);
                otherwise
                    error('scan3_mvpa_regressors: error. two (or more) regressors are active simultaneously');
            end
        end
        names_regs = [{'default'},SPM.SPM.Sess.U(1).name(2:end)];
        value_regs = double(jb_binarymatrix(value_scan + 1));
        
        % set values
        mvpa_subject(i_subject) = init_object(  mvpa_subject(i_subject),'regressors','conds');
        mvpa_subject(i_subject) = set_mat(      mvpa_subject(i_subject),'regressors','conds',value_regs);
        mvpa_subject(i_subject) = set_objfield( mvpa_subject(i_subject),'regressors','conds','condnames',names_regs);
    end

end
