
function cats = scan3_dprime_regressors(time,pars_tr,pars_bold,nb_scans)
    u_field   = fieldnames(time);
    nb_fields = length(u_field);
    
    %% build regressor
    sec  = pars_bold;
    cats = zeros(1,nb_scans);
    for i_scan = 1:nb_scans
        sec = sec + pars_tr;
        % find minimum distance to each event
        dsecs = nan(1,nb_fields);
        for i_field = 1:nb_fields
            cond           = time.(u_field{i_field});
            dsec           = sec-cond;
            dsec(dsec<0)   = nan;
            dsecs(i_field) = nanmin(dsec);
        end
        % pick the closest event
        [~,i_field] = min(dsecs);
        cats(i_scan) = i_field;
    end
end
