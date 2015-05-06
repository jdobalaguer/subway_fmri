
function figure_ROI()
    %% FIGURE_ROI
    % display average b_hat for each ROI
    
    %% warnings
    
    %% function
    
    % subject
    u_subject = [1:5,7:9,11:22];
    n_subject = length(u_subject);

    % mask
    p_mask = 'data/mask/';
    p_roi  = 'ROI_gnone/mask/';
    u_roi  = {'dlPFC','PostC','rAmyg','rAngG','rCaud','sParC2','vmPFC'};
    u_roi  = {'dlPFC','PostC','rCaud2'};
    u_mask = strcat(p_mask,p_roi,u_roi,'.img');
    l_mask = u_roi;
    n_mask = length(u_mask);
        
    % conditions
    u_cond = {'CE','LE','IE','RE';'CH','LH','IH','RH';'CE(Dgoal)','LE(Dgoal)','IE(Dgoal)','RE(Dgoal)';'CH(Dgoal)','LH(Dgoal)','IH(Dgoal)','RH(Dgoal)'};
    l_cond1 = {'C','L','I','R'};
    l_cond2 = {'Easy','Hard','Easy(Dgoal)','Hard(Dgoal)'};
    n_cond = numel(u_cond);
    s_cond = size(u_cond);
    p_cond = 'data/glm/weird_gnone_spmt_outside_1/copy/contrast_1/%s_001/*_sub%02i_*.img';
    
    % values
    v = nan(n_mask,n_cond,n_subject);
    jb_parallel_progress(numel(v));
    for i_mask = 1:n_mask
        for i_cond = 1:n_cond
            for i_subject = 1:n_subject
                spmt = sprintf(p_cond,u_cond{i_cond},u_subject(i_subject));
                spmt_path = fileparts(spmt);
                spmt_name = dir(spmt);
                spmt_name = spmt_name.name;
                spmt = [spmt_path,filesep,spmt_name];

                mask = scan_nifti_load(u_mask{i_mask});
                v(i_mask,i_cond,i_subject) = nanmean(scan_nifti_load(spmt,mask));

                jb_parallel_progress();

            end
        end
    end
    jb_parallel_progress(0);
    m = meeze(v,3);
    e = steeze(v,3);
    assignbase v m e;
    
    % figure vertical
    fig_figure();
    j_subplot = 0;
    for i_mask = 1:n_mask
        j_subplot = j_subplot + 1;
        subplot(n_mask,1,j_subplot);
        this_m = reshape(m(i_mask,:),s_cond);
        this_e = reshape(e(i_mask,:),s_cond);
        fig_bare(this_m,this_e,'hsv',l_cond2,{'C','L','I','R'});
        sa = struct();
        sa.title  = l_mask{i_mask};
        sa.ytick  = -1.0 : 0.5 : +3.0;
        sa.ylim   = ranger(sa.ytick);
        sa.xlabel = 'regressor';
        sa.ylabel = 'beta value';
        fig_axis(sa);
        set(gca(),'Visible','off');
    end
    
%     % figure horizontal
%     fig_figure();
%     mm = reshape(m,[n_mask,s_cond]);
%     me = reshape(e,[n_mask,s_cond]);
%     ytick = {-1.0 : 1.0 : +2.0, -1.0 : 1.0 : +3.0, -1.0 : 0.5 : +1.0, -1.5 : 0.5 : +1.0};
%     ylim  = {[-1.2 , +2.7]    , [-1.0 , +3.0]    , [-1.0 , +1.2]    , [-1.5 , +1.3]    };
%     for i_cond2 = 1:s_cond(1)
%         subplot(s_cond(1),1,i_cond2);
%         this_m = squeeze(mm(:,i_cond2,:));
%         this_e = squeeze(me(:,i_cond2,:));
%         fig_bare(this_m,this_e,'hsv',l_mask,l_cond1);
%         sa = struct();
%         sa.title  = l_cond2{i_cond2};
%         sa.ytick  = ytick{i_cond2};
%         sa.ylim   = ylim{i_cond2};
%         sa.xlabel = 'mask';
%         sa.ylabel = 'beta value';
%         fig_axis(sa);
%     end
end
