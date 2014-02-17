
function subj_condregs = scan_mvpa_regressors(tmp_workspace)
    %% variables
    i_sub           = tmp_workspace.i_sub;
    subj_condfields = tmp_workspace.subj_condfields;
    subj_condruns   = tmp_workspace.subj_condruns;
    nb_runs         = tmp_workspace.nb_runs;
    nb_scans        = length(subj_condruns);
    nb_fields       = length(subj_condfields);
    pars_TR         = tmp_workspace.pars_TR;

    %% load times (for this participant)
    times  = scan_glm_loadregressors('scanner');
    ii_sub = nb_runs*(i_sub-1) + (1:nb_runs);
    times  = times(ii_sub);
    for i_run = 1:nb_runs
        time = struct();
        for i_field = 1:nb_fields
            time.(subj_condfields{i_field}) = times{i_run}.(subj_condfields{i_field});
        end
        times{i_run} = time;
    end

    %% scan_TR (set each scan's TR by run)
    % onset of each run
    run_TR = [];
    for i_run = 1:nb_runs
        run_TR(i_run) = find((subj_condruns==i_run),1,'first');
    end

    % onset of each scan
    scan_TR = nan(1,nb_scans);
    u_scan  = 1:nb_scans;
    for i_run = 1:nb_runs
        ii_scan             = (subj_condruns == i_run);
        scan_TR(ii_scan)    = u_scan(ii_scan) - run_TR(i_run);
    end
    scan_sec = pars_TR * (scan_TR + 0.5);

    %% build regressor
    regressors = zeros(nb_fields,nb_scans);
    for i_scan = 1:nb_scans
        i_run = subj_condruns(i_scan);
        % find minimum distance to each event
        dsecs = nan(1,nb_fields);
        for i_field = 1:nb_fields
            sec  = scan_sec(i_scan);
            cond = times{i_run}.(subj_condfields{i_field});
            dsec = sec-cond;
            dsec(dsec<0)   = nan;
            dsecs(i_field) = nanmin(dsec,2);
        end
        % pick the closest event
        [~,i_field] = min(dsecs);
        regressors(i_field,i_scan) = 1;
    end

    %% return
    subj_condregs = regressors;
end
