
function plot_data_rtvs(session)
    % load results
    try
        allresults = load_results(session);
    catch
        set_results(session);
        allresults = load_results(session);
    end
    
    data = allresults.trial_data;
    map  = allresults.map;
    
    % set mean rts for each participant
    u_par   = unique(data.exp_sub);
    nb_pars = length(u_par);
    n_par   = [17,18,19]; %[6,10];
    u_par(n_par) = [];
    
    % values
    t_exchyes  = nan(1,nb_pars);
    t_exchno   = nan(1,nb_pars);
    t_elbow    = nan(1,nb_pars);
    t_regular  = nan(1,nb_pars);
    t_backward = nan(1,nb_pars);
    for i_par = u_par
        rt   = (data.resp_rt * 1000);
        par  = (data.exp_sub == i_par);

        ii_start     = data.exp_starttrial();
        ii_forwline  = logical(data.resp_subline ==                     data.avatar_insubline) ;
        ii_backline  =        (data.resp_subline == tools_backwardsline(data.avatar_insubline));
        ii_backline(isnan(ii_backline)) = 0;
        ii_backline  = logical(ii_backline);
        ii_backward  = ii_backline                 & ~ii_start;
        ii_change    = ~ii_forwline & ~ii_backline & ~ii_start;
        ii_exchange = logical([map{i_par}.stations(data.avatar_instation).exchange]);
        ii_exchyes  = ~ii_backward & ii_exchange &  ii_change;
        ii_exchno   = ~ii_backward & ii_exchange & ~ii_change;
        ii_elbow    = ~ii_backward & logical([map{i_par}.stations(data.avatar_instation).elbow]);
        ii_regular  = ~ii_backward & ~ii_exchange & ~ii_elbow;
        
        t_exchyes(i_par)  = nanmean(rt(par & ii_exchyes));
        t_exchno(i_par)   = nanmean(rt(par & ii_exchno));
        t_elbow(i_par)    = nanmean(rt(par & ii_elbow));
        t_regular(i_par)  = nanmean(rt(par & ii_regular));
        t_backward(i_par) = nanmean(rt(par & ii_backward));
    end
    

    %% plot
    t = [t_regular',t_elbow',t_exchno',t_exchyes'];
    t(n_par,:) = [];
    m = reshape( mean(t), ...
                [2,2]);
    e = reshape( nanstd( t)./sqrt(size(t,1)), ...
                [2,2]);
    sum(~isnan(t));
    f = figure();
    set(gca,'position',get(gca,'position')+[0,+.05,0,-.1])
    fig_barweb(m - 600,e,...
                        [],...                                                 width
                        {'same','switch'},...                                  group names
                        '',...                                                 title
                        [],...                                                 xlabel
                        'reaction time (ms)',...                               ylabel
                        [1,1,1;.8,.8,.8],...                                   colour
                        'y',...                                                grid
                        {'regular','exchange'},...                             legend
                        2,...                                                  error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    sa.ytick      = (600:200:1400) - 600;
    sa.yticklabel = 600:200:1400;
    sa.ylim       = [sa.ytick(1),sa.ytick(end)];
    fig_axis(sa);
    fig_figure(f);
    
    %% anova
    fprintf('ANOVA: exchange & switch\n');
    tools_repanova(t,[2,2]);
    
    %% ttest2
    [~,p] = ttest(t_regular-t_exchno);
    fprintf('ttest: p(regular - exchno) = %f \n',p);
    [~,p] = ttest(t_regular-t_elbow);
    fprintf('ttest: p(regular - elbow)  = %f \n',p);
    [~,p] = ttest(t_elbow-t_exchyes);
    fprintf('ttest: p(elbow - exchyes)  = %f \n',p);
    [~,p] = ttest(t_exchno-t_exchyes);
    fprintf('ttest: p(exchno - exchyes) = %f \n',p);
    
end
