
function figure_1b()
    %% parameters
    r_subject = [6,10];
    ytick     = 600:200:1400;
    
    %% load
    data = load_data_ext('scanner');
    
    %% values
    ii_bool = logical( data.resp_bool);
    ii_forw = logical(~data.resp_direction_back);
    ii_subj = ~jb_anyof(data.expt_subject,r_subject);
    ii = (ii_bool & ii_forw & ii_subj);
    
    x = 1000 * getm_mean(data.resp_reactiontime(ii),data.expt_subject(ii),data.resp_direction_switch(ii),data.vbxi_exchange_in(ii));
    m = meeze(x);
    e = steeze(x);
    
    %% anova
    jb_anova(x,{'RT','Switch','Exchange','Trial'});
    
    %% figure
    f = fig_figure();
    
    sa = struct();
    sa.ytick   = ytick - ytick(1);
    sa.ylim    = [0 , ytick(end)-ytick(1)];
    sa.yticklabel = ytick;
%     sa.yticklabel = {''};
    m = m - ytick(1);
    
    fig_barweb(m,e,...
            [],...                                                  width
            {'Stay','Switch'},...                                             group names
            '',...                                                  title
            '',...                                                  xlabel
            '',...                                                  ylabel
            fig_color('gray')./255,...                              colour
            'y',...                                                 grid
            {'Regular','Exchange'},...                              legend
            2,...                                                   error sides (1, 2)
            'axis'...                                               legend ('plot','axis')
            );
    fig_axis(sa);
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end