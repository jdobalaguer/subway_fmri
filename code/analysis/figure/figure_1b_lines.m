
function figure_1b()
    %% parameters
    r_subject = [6,10];
    ytick     = 400:200:1600;
    
    %% load
    data = load_data_ext('scanner');
    block = load_block_ext('scanner');
    
    function z = func_numlines(s,r,b)
        ii_s = (data.expt_subject == s);
        ii_r = (data.expt_session == r);
        ii_b = (data.expt_block   == b);
        z = cumsum(logical([0,diff(data.vbxi_subline_in(ii_s & ii_r & ii_b))]));
    end
    data.vbxi_subline_cumsum = jb_applyvector(@func_numlines,data.expt_subject,data.expt_session,data.expt_block);
    function z = func_goal(s,r,b)
        ib_s = (block.expt_subject == s);
        ib_r = (block.expt_session == r);
        ib_b = (block.expt_block   == b);
        ib = (ib_s & ib_r & ib_b);
        id_s = (data.expt_subject == s);
        id_r = (data.expt_session == r);
        id_b = (data.expt_block   == b);
        id = (id_s & id_r & id_b);
        z = repmat(block.resp_goal(ib),[1,sum(id)]);
    end
    data.resp_goal = jb_applyvector(@func_goal,data.expt_subject,data.expt_session,data.expt_block);
    assignbase data;
    
    %% values
    ii_bool = logical( data.resp_bool);
    ii_forw = logical(~data.resp_direction_back);
    ii_corr = logical(~data.resp_away_any);
    ii_subj = ~jb_anyof(data.expt_subject,r_subject);
    ii_nsta = logical( data.expt_trial > 1);
    ii_hard = logical( data.optm_dist_subline_journey > 1);
    ii_lost = logical( data.expt_trial < data.optm_dist_station_journey);
    ii_respdiff = (data.resp_dist_subline_journey == 2);
    ii_optmdiff = (data.optm_dist_subline_journey > 0);
    ii = (ii_bool & ii_forw & ii_subj & ii_corr & ii_optmdiff & ii_respdiff);
   
    x = 1000 * getm_mean(data.resp_reactiontime(ii),data.expt_subject(ii),data.vbxi_subline_cumsum(ii),data.resp_direction_switch(ii),data.vbxi_exchange_in(ii));
    
    t = getm_mean(data.vbxi_subline_cumsum(ii),data.expt_subject(ii),data.vbxi_subline_cumsum(ii));
    t = meeze(t)';
    m = meeze(x);
    e = steeze(x);
        
    %% anova
    if ~anynan(x), 
%         jb_anova(x,{'RT','Time','Switch','Exchange'});
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
%     sa.xlim         = [0,1];
    sa.ytick        = ytick;
    sa.ylim         = [ytick(1),ytick(end)];
    sa.ilegend = h(:);
    sa.tlegend = l(:);
    fig_axis(sa);
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end