
function plot_data_rtpostreg(session)
    
    %% load
    % load results
    allresults = load_results(session);
    allresults = results_adddata(allresults);
    % data
    data = allresults.trial_data;
    % map
    map  = allresults.map;

    %% values
    % set mean rts for each participant
    u_par   = unique(data.exp_sub);
    nb_pars = length(u_par);
    n_par   = [6,10];
    u_par(n_par) = [];

    % values
    t_regularpre= nan(1,nb_pars);
    t_regularpos= nan(1,nb_pars);
    for i_par = u_par
        rt   = (data.resp_rt * 1000);
        par  = (data.exp_sub == i_par);

        ii_lastgoal = (data.avatar_goalstation==data.avatar_subgoal);

        t_regularpre(i_par)  = nanmean(rt(par & data.avatar_regular & ~ii_lastgoal & data.exp_trial>3));
        t_regularpos(i_par)  = nanmean(rt(par & data.avatar_regular &  ii_lastgoal & data.exp_trial>3));
    end

    %% plot
    t = [t_regularpre',t_regularpos'];
    t(n_par,:) = [];
    m = mean(t);
    e = nanstd(t) ./ sqrt(size(t,1));
    f = figure();
    set(gca,'position',get(gca,'position')+[0,+.05,0,-.1])
    fig_barweb(m - 600,e,...
                        [],...                                                 width
                        {},...                                                 group names
                        '',...                                                 title
                        [],...                                                 xlabel
                        'reaction time (ms)',...                               ylabel
                        [1,1,1;.8,.8,.8],...                                   colour
                        'y',...                                                grid
                        {'reg pre','reg pos'},...                              legend
                        2,...                                                  error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    sa.ytick      = (600:200:1400) - 600;
    sa.yticklabel = 600:200:1400;
    sa.ylim       = [sa.ytick(1),sa.ytick(end)];
    fig_axis(sa);
    fig_figure(f);
    
    %% ttest
    [h,p] = ttest2(t_regularpos,t_regularpre);
    fprintf('plot_data_rtpostreg: ttest2: [%d] p = %0.2f \n',h,p);

end