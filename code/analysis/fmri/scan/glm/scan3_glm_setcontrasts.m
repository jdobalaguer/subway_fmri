
function scan = scan3_glm_setcontrasts(scan)
    %% SCAN3_GLM_SETCONTRASTS()
    % set contrasts for GLM
    % see also scan3_glm

    %%  WARNINGS
    %#ok<*NUSED,*AGROW>
    
    %% SET CONTRASTS
    scan.glm.contrast  = {};
    % set names
    tmp = load(sprintf('%scondition_sub_%02i_run_%02i.mat',scan.dire.glm_condition,scan.subject.u(1),1),'cond');
    u_name = {};
    for i = 1:length(tmp.cond)
        u_name = [u_name, {tmp.cond{i}.name}, tmp.cond{i}.subname];
    end
    n_name = length(u_name);
    % set order
    switch(scan.glm.function)
        case 'hrf', n_order = 1+sum(scan.glm.hrf.ord);
        case 'fir', n_order = scan.glm.fir.ord;
    end
    % set contrasts
    j_name = 0;
    for i_name = 1:n_name
        for i_order = 1:n_order
            j_name = j_name + 1;
            name_contrast = sprintf('%s_%03i',u_name{i_name},i_order);
            conv_contrast = zeros(1,n_name*n_order);
            conv_contrast(j_name) = 1;
            scan.glm.contrast{j_name} = struct('name',name_contrast, 'convec',conv_contrast);
        end
    end
    
end