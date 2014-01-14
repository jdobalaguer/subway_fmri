
function plot_data_exchrt(session)
    % load results
    allresults = load_results(session);
    
    u_par   = unique(allresults.trial_data.exp_sub);
    nb_pars = length(u_par);
    
    for i_par = 1:nb_pars
        rt   = (allresults.trial_data.resp_rt * 1000);
        par  = (allresults.trial_data.exp_sub == u_par(i_par));
        
        regular = (allresults.trial_data.resp_nboptions < 3);
        inertia = (allresults.trial_data.resp_keycode(1:end-1)==allresults.trial_data.resp_keycode(2:end));
        inertia(isnan(inertia)) = 0;
        inertia = [inertia,0];
        inertia = inertia & ~logical(allresults.trial_data.exp_stoptrial);
                
        t_reg_in(i_par)  = nanmean(rt(par &  regular &  inertia));
        t_exc_in(i_par)  = nanmean(rt(par & ~regular &  inertia));
        t_reg_ex(i_par)  = nanmean(rt(par &  regular & ~inertia));
        t_exc_ex(i_par)  = nanmean(rt(par & ~regular & ~inertia));
        
        t_in(i_par)      =  nanmean(rt(par &  inertia));
        t_ex(i_par)      =  nanmean(rt(par & ~inertia));
        
        t_reg(i_par)     =  nanmean(rt(par &  regular));
        t_exc(i_par)     =  nanmean(rt(par & ~regular));

    end
    
    t = [t_reg_in',t_exc_in',t_reg_ex',t_exc_ex'];
    ta = [t_in',t_ex'];
    tb = [t_reg',t_exc'];
    
    % anova
    % tools_repanova(ta,2);
    % tools_repanova(tb,2);
    tools_repanova(t,[2,2]);
    
    % mean and std
    m = mean(t);                m = [m(1),m(2);m(3),m(4)];
    e = std( t)./sqrt(nb_pars); e = [e(1),e(2);e(3),e(4)];

    % plot
    f = figure();
    fig_barweb(m,e,...
                        [],...                                                 width
                        {'inertia','exertia'},...                              group names
                        '',...                                                 title
                        'response',...                                         xlabel
                        'reaction time (ms)',...                               ylabel
                        fig_color('summer')./255,...                           colour
                        'y',...                                                grid
                        {'regular','exchange'},...                             legend
                        1,...                                                  error sides (1, 2)
                        'plot'...                                              legend ('plot','axis')
                        );
    sa.ytick   = 600:200:1200;
    sa.ylim    = [sa.ytick(1),sa.ytick(end)];
    fig_axis(sa);
    fig_figure(f);
    
end
