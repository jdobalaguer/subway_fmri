
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
        rt   = (allresults.trial_data.resp_rt * 1000);
        par  = (allresults.trial_data.exp_sub == u_par(i_par));
        
        exchange =        (allresults.trial_data.resp_nboptions > 2);
        elbow    = logical([allresults.map{i_par}.stations(allresults.trial_data.avatar_instation).elbow]);
        regular  =        (~exchange & ~elbow);
        
        start = logical(allresults.trial_data.exp_starttrial);
        inertia = (allresults.trial_data.resp_keycode(1:end-1)==allresults.trial_data.resp_keycode(2:end));
        inertia(isnan(inertia)) = 0;
        inertia = [0,inertia];
        inertia =  inertia & ~start;
        exertia = ~inertia & ~start;
                
        t_reg_in(i_par)  = nanmean(rt(par & regular  & inertia));
        t_exc_in(i_par)  = nanmean(rt(par & exchange & inertia));
        t_elb_in(i_par)  = nanmean(rt(par & elbow    & inertia));
        t_reg_ex(i_par)  = nanmean(rt(par & regular  & exertia));
        t_exc_ex(i_par)  = nanmean(rt(par & exchange & exertia));
        t_elb_ex(i_par)  = nanmean(rt(par & elbow    & exertia));
        
%         fprintf('par %02i, reg_in = %d\n',i_par,sum(par & regular  & inertia))
%         fprintf('par %02i, exc_in = %d\n',i_par,sum(par & exchange & inertia))
%         fprintf('par %02i, reg_ex = %d\n',i_par,sum(par & regular  & exertia))
%         fprintf('par %02i, exc_ex = %d\n',i_par,sum(par & exchange & exertia))
%         fprintf('par %02i, elb_ex = %d\n',i_par,sum(par & elbow    & exertia))
%         fprintf('\n')

        t_in(i_par)      = nanmean(rt(par & inertia));
        t_ex(i_par)      = nanmean(rt(par & exertia));
        
        t_reg(i_par)     = nanmean(rt(par & regular));
        t_exc(i_par)     = nanmean(rt(par & exchange));
        t_elb(i_par)     = nanmean(rt(par & elbow));
    end
    
    % fix means
    t_reg_in(isnan(t_reg_in)) = nanmean(t_reg_in);
    t_exc_in(isnan(t_exc_in)) = nanmean(t_exc_in);
    t_elb_in(isnan(t_elb_in)) = nanmean(t_elb_in);
    t_reg_ex(isnan(t_reg_ex)) = nanmean(t_reg_ex);
    t_exc_ex(isnan(t_exc_ex)) = nanmean(t_exc_ex);
    t_elb_ex(isnan(t_elb_ex)) = nanmean(t_elb_ex);
    
    % anova
    fprintf('ANOVA over exchange/regular and inertia/exertia\n');
    tools_repanova([t_reg_in',t_exc_in',t_reg_ex',t_exc_ex'],[2,2]);
    fprintf('ANOVA over exchange/other and inertia/exertia\n');
    tools_repanova([t_reg_in',t_elb_ex',t_exc_in',t_exc_ex'],[2,2]);
    
    fprintf('t-test over exchange/regular (inertia)\n');
    [~,P,~,STATS] = ttest2(t_reg_in',t_exc_in','tail','both');
    fprintf('Effect   :                    t(%.2f)=%.3f,\tp=%.3f \n\n',STATS.df,abs(STATS.tstat),P);
    
    fprintf('t-test over exchange/regular (exertia)\n');
    [~,P,~,STATS] = ttest2(t_reg_ex',t_exc_ex');
    fprintf('Effect   :                    t(%.2f)=%.3f,\tp=%.3f \n\n',STATS.df,abs(STATS.tstat),P);
    
    fprintf('t-test over exchange/elbow   (exertia)\n');
    [~,P,~,STATS] = ttest2(t_elb_ex',t_exc_ex');
    fprintf('Effect   :                    t(%.2f)=%.3f,\tp=%.3f \n\n',STATS.df,abs(STATS.tstat),P);
    
    % plot
    t = [t_reg_in',t_exc_in',t_elb_in',t_reg_ex',t_exc_ex',t_elb_ex'];
    m = mean(t);                m = reshape(m,[3,2])';
    e = std( t)./sqrt(nb_pars); e = reshape(e,[3,2])';
    f = figure();
    fig_barweb(m,e,...
                        [],...                                                 width
                        {'inertia','exertia'},...                              group names
                        '',...                                                 title
                        'response',...                                         xlabel
                        'reaction time (ms)',...                               ylabel
                        fig_color('work')./255,...                           colour
                        'y',...                                                grid
                        {'regular','exchange','elbow'},...                             legend
                        1,...                                                  error sides (1, 2)
                        'plot'...                                              legend ('plot','axis')
                        );
    sa.ytick   = 600:200:1400;
    sa.ylim    = [sa.ytick(1),sa.ytick(end)];
    fig_axis(sa);
    fig_figure(f);
    
end
