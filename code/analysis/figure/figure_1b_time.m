
function figure_1b()
    %% parameters
    r_subject = [6,10];
    ytick     = 400:200:1600;
    
    %% load
    data = load_data_ext('scanner');
    
    %% values
    n_trial = 5;
    ii_bool = logical( data.resp_bool);
    ii_forw = logical(~data.resp_direction_back);
    ii_corr = logical( data.resp_correct_all);
    ii_subj = ~jb_anyof(data.expt_subject,r_subject);
    ii_nsta = logical( data.expt_trial > 1);
    ii_hard = logical( data.optm_dist_subline_journey > 1);
    ii_lost = logical( data.expt_trial < data.optm_dist_station_journey);
    ii = (ii_bool & ii_forw & ii_subj & ii_corr & ii_hard);
    data.optm_trial_dist_relative = ((data.expt_trial - 1)./ data.optm_dist_station_journey);
   
    x = 1000 * getm_mean(data.resp_reactiontime(ii),data.expt_subject(ii),ceil(n_trial * data.optm_trial_dist_relative(ii)),data.resp_direction_switch(ii),data.vbxi_exchange_in(ii));
    t = getm_mean(data.optm_trial_dist_relative(ii),data.expt_subject(ii),ceil(n_trial * data.optm_trial_dist_relative(ii)));
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
    l = {'R','I';'L','C'};
    for i_exchange = 1:2
        for i_switch = 1:2
            j_subplot = j_subplot + 1;
            handle = fig_errplot(t,m(:,i_exchange,i_switch),e(:,i_exchange,i_switch),c(i_exchange,i_switch));
            h(i_exchange,i_switch) = handle.errbar;
        end
    end
    
    sa = struct();
    sa.xlim         = [0,1];
    sa.ytick        = ytick;
    sa.ylim         = [ytick(1),ytick(end)];
    sa.ilegend = h(:);
    sa.tlegend = l(:);
    fig_axis(sa);
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end