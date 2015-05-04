
% function roi_region_dist()
    %% ROI_REGION_DIST
    % comparing Dgoal and Dline for different regions/stations
    % path: data/glm/new_GLM7/copy/contrast_1/
    
    %% warnings
    
    %% values
    % subject
    u_subject = [1:5,7:9,11:22];
    n_subject = length(u_subject);

    % mask
    p_mask = 'data/mask/';
    p_roi  = 'ROI_gnone/mask/';
%     u_roi  = roi_get([p_mask,p_roi]);
%     u_roi  = {'dlPFC','PostC','rAmyg','rAngG','rCaud','sParC2'};
    u_roi  = {'dlPFC','PostC','rAmyg','rCaud','sParC2','vmPFC'};
    u_roi = {'rAngG'};
    n_roi  = length(u_roi);
    p_eps  = 'dist/';
    
    u_mask = strcat(p_mask,p_roi,u_roi,'.img');
    l_mask = u_roi;
    n_mask = length(u_mask);
        
%     % regions
%     p_mask = 'data/mask/ROI/mask/';
%     u_mask = dir([p_mask,'*.img']);
%     u_mask = {u_mask.name};
%     n_mask = length(u_mask);
%     l_mask = {'Amygd','Crblm','Thalm','dlPFC','pCenS','rAngG','rHipc','vmPFC'};

    % conditions
    u_cond = {'C','L','I','R';'C(Dgoal)','L(Dgoal)','I(Dgoal)','R(Dgoal)';'C(Dline)','L(Dline)','I(Dline)','R(Dline)'};
    u_cond = {'CE','LE','IE','RE';'CH','LH','IH','RH';'CE(Dgoal)','LE(Dgoal)','IE(Dgoal)','RE(Dgoal)';'CH(Dgoal)','LH(Dgoal)','IH(Dgoal)','RH(Dgoal)'};
    n_cond = numel(u_cond);
    s_cond = size(u_cond);
    p_cond = 'data/glm/ROI_gnone_spmt_outside/copy/contrast_1/%s_001/*_sub%02i_*.img';
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

    % means
    m = meeze(v,3);
    e = steeze(v,3);
    
        
    %% figure vertical
    
    fig_figure();
    j_subplot = 0;
    mkdirp(p_eps);
    for i_mask = 1:n_mask

        c = fig_color('hsv',4)./255;

        % figure
        j_subplot = j_subplot + 1;
        subplot(n_mask,1,j_subplot);
        this_m = reshape(m(i_mask,:),s_cond);
        this_e = reshape(e(i_mask,:),s_cond);
%         fig_barweb(this_m,this_e,[],{'main','# stations','# lines'},[],[],[],c,[],{'C','L','I','R'},[],'axis');
        fig_barweb(this_m,this_e,[],{'Easy','Hard','Easy(Dgoal)','Hard(Dgoal)'},[],[],[],c,[],{'C','L','I','R'},[],'axis');
%         fig_barweb(this_m,this_e,[],{'','',''},[],[],[],c,[],{'','','',''},[],'axis');
        sa = struct();
        sa.title = {l_mask{i_mask}};
        sa.ytick = -1.0 : 0.5 : +3.0;
        sa.ylim  = ranger(sa.ytick);
        sa.ylabel = 'beta value';
        sa.xlabel = '';
        sa.ylabel = '';
        sa.title  = '';
        fig_axis(sa);
        set(gca(),'XMinorTick','off');
        set(gca(),'YMinorTick','off');
        fig_fontsize([],14);
        fig_fontname([],'Arial');
%         print('-depsc',[p_eps,l_mask{i_mask},'.eps']);
%         close(gcf());

    end
    return;
    
    %% figure horizontal
    
    fig_figure();
    c = fig_color('hsv',4)./255;
    i_dist = 0;
    mm = reshape(m,[n_mask,s_cond]);
    me = reshape(e,[n_mask,s_cond]);

    i_dist = i_dist + 1;
    subplot(s_cond(1),1,i_dist);
    this_m = squeeze(mm(:,i_dist,:));
    this_e = squeeze(me(:,i_dist,:));
    fig_barweb(this_m,this_e,[],{'','',''},[],[],[],c,[],{'','','',''},[],'axis');
    sa = struct();
    sa.title = {l_mask{i_mask}};
    sa.ytick = -1.0 : 1.0 : +2.0;
    sa.ylim  = [-1.2 , +2.7];
    sa.xlabel = '';
    sa.ylabel = '';
    sa.yticklabel = {};
    sa.title  = '';
    fig_axis(sa);
    set(gca(),'XMinorTick','off');
    set(gca(),'YMinorTick','off');
    
    i_dist = i_dist + 1;
    subplot(s_cond(1),1,i_dist);
    this_m = squeeze(mm(:,i_dist,:));
    this_e = squeeze(me(:,i_dist,:));
    fig_barweb(this_m,this_e,[],{'','',''},[],[],[],c,[],{'','','',''},[],'axis');
    sa = struct();
    sa.title = {l_mask{i_mask}};
    sa.ytick = -1.0 : 1.0 : +3.0;
    sa.ylim  = [-1.0 , +3.0];
    sa.xlabel = '';
    sa.ylabel = '';
    sa.yticklabel = {};
    sa.title  = '';
    fig_axis(sa);
    set(gca(),'XMinorTick','off');
    set(gca(),'YMinorTick','off');
    
    i_dist = i_dist + 1;
    subplot(s_cond(1),1,i_dist);
    this_m = squeeze(mm(:,i_dist,:));
    this_e = squeeze(me(:,i_dist,:));
    fig_barweb(this_m,this_e,[],{'','',''},[],[],[],c,[],{'','','',''},[],'axis');
    sa = struct();
    sa.title = {l_mask{i_mask}};
    sa.ytick = -1.0 : 0.5 : +1.0;
    sa.ylim  = [-1.0 , +1.2];
    sa.xlabel = '';
    sa.ylabel = '';
    sa.yticklabel = {};
    sa.title  = '';
    fig_axis(sa);
    set(gca(),'XMinorTick','off');
    set(gca(),'YMinorTick','off');
    
    i_dist = i_dist + 1;
    subplot(s_cond(1),1,i_dist);
    this_m = squeeze(mm(:,i_dist,:));
    this_e = squeeze(me(:,i_dist,:));
    fig_barweb(this_m,this_e,[],{'','',''},[],[],[],c,[],{'','','',''},[],'axis');
    sa = struct();
    sa.title = {l_mask{i_mask}};
    sa.ytick = -1.5 : 0.5 : +1.0;
    sa.ylim  = [-1.5 , +1.3];
    sa.xlabel = '';
    sa.ylabel = '';
    sa.yticklabel = {};
    sa.title  = '';
    fig_axis(sa);
    set(gca(),'XMinorTick','off');
    set(gca(),'YMinorTick','off');
    
    fig_fontsize([],14);
    fig_fontname([],'Arial');


% end
