
function plot_data_exchrt(session)
    % load results
    try
        allresults = load_results(session);
    catch
        set_results(session);
        allresults = load_results(session);
    end
    
    % set mean rts for each participant
    u_par   = unique(allresults.trial_data.exp_sub);
    nb_pars = length(u_par);
    
    for i_par = 1:nb_pars
        rt    = (allresults.trial_data.resp_rt * 1000);
        par   = (allresults.trial_data.exp_sub == u_par(i_par));
        
        high  = (allresults.trial_data.avatar_reward==5);
        low   = (allresults.trial_data.avatar_reward==1);
        
        dist1 = (allresults.trial_data.dists_steptimes_stations==1);
        dist2 = (allresults.trial_data.dists_steptimes_stations==2);
        dist3 = (allresults.trial_data.dists_steptimes_stations==3);
        distN = (allresults.trial_data.dists_steptimes_stations>=4);
        
        t_low_1(i_par)  = nanmean(rt(par & low  & dist1));
        t_low_2(i_par)  = nanmean(rt(par & low  & dist2));
        t_low_3(i_par)  = nanmean(rt(par & low  & dist3));
        t_low_N(i_par)  = nanmean(rt(par & low  & distN));
        t_high1(i_par)  = nanmean(rt(par & high & dist1));
        t_high2(i_par)  = nanmean(rt(par & high & dist2));
        t_high3(i_par)  = nanmean(rt(par & high & dist3));
        t_highN(i_par)  = nanmean(rt(par & high & distN));
        
    end
    
    % fix means
    t_high1(isnan(t_high1)) = nanmean(t_high1);
    t_high2(isnan(t_high2)) = nanmean(t_high2);
    t_high3(isnan(t_high3)) = nanmean(t_high3);
    t_highN(isnan(t_highN)) = nanmean(t_highN);
    t_low_1(isnan(t_low_1)) = nanmean(t_low_1);
    t_low_2(isnan(t_low_2)) = nanmean(t_low_2);
    t_low_3(isnan(t_low_3)) = nanmean(t_low_3);
    t_low_N(isnan(t_low_N)) = nanmean(t_low_N);
    
    % anova
    fprintf('ANOVA over exchange/regular and inertia/exertia\n');
    tools_repanova([t_low_1',t_low_2',t_low_3',t_low_N',...
                    t_high1',t_high2',t_high3',t_highN'    ],[2,4]);
    
    % plot
    t = [t_low_1',t_low_2',t_low_3',t_low_N',...
         t_high1',t_high2',t_high3',t_highN'];
    m = mean(t);                m = reshape(m,[4,2])';
    e = std( t)./sqrt(nb_pars); e = reshape(e,[4,2])';
    f = figure();
    fig_barweb(m,e,...
                        [],...                                                 width
                        {'low','high'},...                                     group names
                        '',...                                                 title
                        'response',...                                         xlabel
                        'reaction time (ms)',...                               ylabel
                        fig_color('work')./255,...                             colour
                        'y',...                                                grid
                        {'1','2','3','4'},...                                  legend
                        1,...                                                  error sides (1, 2)
                        'plot'...                                              legend ('plot','axis')
                        );
    sa.ytick   = 600:200:1400;
    sa.ylim    = [sa.ytick(1),sa.ytick(end)];
    fig_axis(sa);
    fig_figure(f);
    
end
