
function figure_1b()
    %% parameters
    r_subject = [6,10];
    ytick     = 700:200:1300;
    
    %% load
    data = load_data_ext('scanner');
    
    %% values
    n_trial = 2;
    ii_bool = logical( data.resp_bool);
    ii_forw = logical(~data.resp_direction_back);
    ii_corr = logical( data.resp_correct_all);
    ii_subj = ~jb_anyof(data.expt_subject,r_subject);
    ii = (ii_bool & ii_forw & ii_subj & ii_corr);
%     data.expt_trial = get_discrete(data.expt_trial,data.expt_subject,n_trial);
    data.expt_trial = ceil(n_trial * data.expt_trial ./ data.optm_dist_station_journey);
   
    x = 1000 * getm_mean(data.resp_reactiontime(ii),data.expt_subject(ii),data.resp_direction_switch(ii),data.vbxi_exchange_in(ii),data.expt_trial(ii));
    m = meeze(x);
    e = steeze(x);
    
    %% anova
    jb_anova(x,{'RT','Switch','Exchange','Trial'});
    
    %% figure
    mc = nan(n_trial,4);
    ec = nan(n_trial,4);
    for i_trial = 1:n_trial
        mc(i_trial,:) = mat2vec(m(:,:,i_trial)');
        ec(i_trial,:) = mat2vec(e(:,:,i_trial)');
    end
    mc = mc - ytick(1);
    
    f = fig_figure();
    
    sa = struct();
    sa.ytick        = ytick - ytick(1);
    sa.yticklabel   = ytick;
    sa.ylim         = [0 , ytick(end)-ytick(1)];
    
    fig_barweb(mc,ec,...
            [],...                                                  width
            {'First half','Second half','',''},...                                       group names
            '',...                                                  title
            '',...                                                  xlabel
            '',...                                                  ylabel
            fig_color('gray')./255,...                              colour
            'y',...                                                 grid
            {'R','I','L','C'},...                                   legend
            2,...                                                   error sides (1, 2)
            'axis'...                                               legend ('plot','axis')
            );
    fig_axis(sa);
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end