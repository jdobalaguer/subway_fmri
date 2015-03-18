
function figure_1b()
    %% parameters
    r_subject = [6,10];
    ytick     = 250:500:1750;
    
    %% load
    data = load_data_ext('scanner');
    %data.expt_trial = -data.optm_dist_station_goal;
    
    %% values
    ii_bool = logical( data.resp_bool);
    ii_forw = logical(~data.resp_direction_back);
    ii_corr = logical(~data.resp_away_any);
    ii_subj = ~jb_anyof(data.expt_subject,r_subject);
    ii_hard = logical( data.optm_dist_subline_journey > 1);
    ii = (ii_bool & ii_forw & ii_subj & ii_corr & ii_hard);
   
    x = 1000 * getm_mean(data.resp_reactiontime(ii),data.expt_subject(ii),data.expt_trial(ii),data.resp_direction_switch(ii),data.vbxi_exchange_in(ii));
    t = getm_mean(data.expt_trial(ii),data.expt_subject(ii),data.expt_trial(ii));
    t = meeze(t)';
    m = meeze(x);
    e = steeze(x);
        
    %% anova
    if ~anynan(x), 
        jb_anova(x,{'RT','Time','Switch','Exchange'});
    end
    
    %% figure
    
    f = fig_figure();
    c = ['rg';'by'];
    hold('on');
    j_subplot = 0;
    h = nan(2,2);
    l = {'R','L';'I','C'};
    for i_exchange = 1:2
        for i_switch = 1:2
            j_subplot = j_subplot + 1;
            handle = fig_errplot(t,m(:,i_exchange,i_switch),e(:,i_exchange,i_switch),c(i_exchange,i_switch));
            h(i_exchange,i_switch) = handle.errbar;
        end
    end
    
    sa = struct();
    sa.ytick        = ytick;
    sa.ylim         = [ytick(1),ytick(end)];
    sa.ygrid        = 'on';
    sa.ilegend = h(:);
    sa.tlegend = l(:);
    fig_axis(sa);
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end