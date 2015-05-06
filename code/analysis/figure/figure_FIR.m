

function figure_FIR()
    %% FIGURE_FIR()
    % plot the figure with the FIR signal
    
    %% warnings
    %#ok<*AGROW>
    
    %% function
    % mask
    p_roi  = 'ROI_gnone/mask/';
    u_roi  = {'dlPFC','PostC','rAmyg','rAngG','rCaud2','sParC2','vmPFC'};
    u_roi  = {'dlPFC','PostC','rCaud2'};
    u_roi  = {'rCaud'};
    
    u_mask = strcat(p_roi,u_roi,'.img');
    l_mask = u_roi;
    n_mask = length(u_mask);
        
    % figure
    for i_mask = 1:n_mask
        scan_plot_peristimulus('cont_1','data/glm/new_FIR4/',u_mask{i_mask},{'C_','L_','I_','R_'});
        title(l_mask{i_mask});
        sa.ytick      = {};
        sa.yticklabel = {};
        sa.title = '';
        fig_axis(sa);
        legend('off');
        set(gca,'YColor','w');
        fig_rmtext();
    end
    
end