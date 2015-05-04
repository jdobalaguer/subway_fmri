
function roi_peristimulus()
    %% ROI_PERISTIMULUS()
    
    %% warning
    
    %% function
    
    % mask
    p_mask = 'data/mask/';
    p_roi  = 'ROI_gnone/mask/';
    u_roi  = roi_get([p_mask,p_roi]);
%     u_roi  = {'dlPFC','PostC','rAmyg','rAngG','rCaud','sParC2'};
    u_roi  = {'dlPFC','PostC','rAmyg','rCaud','sParC2','vmPFC'};
    u_roi  = {'vmPFC'};
    n_roi  = length(u_roi);
    p_eps  = 'peristimulus/';
    
    u_mask = strcat(p_roi,u_roi,'.img');
    l_mask = u_roi;
    n_mask = length(u_mask);
        
    %%
    % figure
    mkdirp(p_eps);
    jb_parallel_progress(n_mask);
    for i_mask = 1:n_mask
        scan_plot_peristimulus('cont_1','data/glm/new_FIR4/',u_mask{i_mask},{'C_','L_','I_','R_'});
%         scan_plot_peristimulus('spmt_2','data/glm/new_FIR4/',u_mask{i_mask},{'C_','L_','I_','R_'});
        title(l_mask{i_mask});
        set(gcf(),'Visible','off')
        sa.xlabel = '';
        sa.ylabel = '';
        sa.xticklabel = {};
%         sa.yticklabel = {};
        sa.title = '';
        sa.ytick = -0.05:0.01:+0.07;
        sa.ylim = ranger(sa.ytick);
        fig_axis(sa);
        legend('off');
        set(gca(),'XMinorTick','off');
        set(gca(),'YMinorTick','off');
        fig_fontsize([],14);
        fig_fontname([],'Arial');
        print('-depsc',[p_eps,l_mask{i_mask},'.eps']);
        close(gcf());
        jb_parallel_progress();
    end
    jb_parallel_progress(0);
    return;
    
    %%
    for i_mask = 1:n_mask
        sa.title = l_mask{i_mask};
        fig_axis(sa);
    end
    
    %%
    fig_fontname([],'Arial');
    fig_fontsize([],16);
    
end