
function plot_data_rtpostexch(session)
    
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
    t_early_exchno_pre = nan(1,nb_pars);
    t_early_exchno_pos = nan(1,nb_pars);
    t_early_regula_pre    = nan(1,nb_pars);
    t_early_regula_pos    = nan(1,nb_pars);
    t_later_exchno_pre = nan(1,nb_pars);
    t_later_exchno_pos = nan(1,nb_pars);
    t_later_regula_pre    = nan(1,nb_pars);
    t_later_regula_pos    = nan(1,nb_pars);
    for i_par = u_par
        rt   = (data.resp_rt * 1000);
        par  = (data.exp_sub == i_par);

        ii_lastgoal = (data.avatar_goalstation==data.avatar_subgoal);

        t_early_exchno_pre(i_par) = nanmean(rt(par & data.avatar_exchno  & ~ii_lastgoal & data.exp_trial<=3));
        t_early_exchno_pos(i_par) = nanmean(rt(par & data.avatar_exchno  &  ii_lastgoal & data.exp_trial<=3));
        t_early_regula_pre(i_par) = nanmean(rt(par & data.avatar_regular & ~ii_lastgoal & data.exp_trial<=3));
        t_early_regula_pos(i_par) = nanmean(rt(par & data.avatar_regular &  ii_lastgoal & data.exp_trial<=3));
        t_later_exchno_pre(i_par) = nanmean(rt(par & data.avatar_exchno  & ~ii_lastgoal & data.exp_trial> 3));
        t_later_exchno_pos(i_par) = nanmean(rt(par & data.avatar_exchno  &  ii_lastgoal & data.exp_trial> 3));
        t_later_regula_pre(i_par) = nanmean(rt(par & data.avatar_regular & ~ii_lastgoal & data.exp_trial> 3));
        t_later_regula_pos(i_par) = nanmean(rt(par & data.avatar_regular &  ii_lastgoal & data.exp_trial> 3));
    end

    %% plot
    t = [t_early_exchno_pre',t_early_exchno_pos',t_early_regula_pre',t_early_regula_pos',...
         t_later_exchno_pre',t_later_exchno_pos',t_later_regula_pre',t_later_regula_pos'];
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
                        {'ex early pre','ex early pos','re early pre','re early pos',...
                         'ex later pre','ex later pos','re later pre','re later pos'},...    legend
                        2,...                                                  error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    sa.ytick      = (600:200:1400) - 600;
    sa.yticklabel = 600:200:1400;
    sa.ylim       = [sa.ytick(1),sa.ytick(end)];
    fig_axis(sa);
    fig_figure(f);

    %% anova
    fprintf('ANOVA: \n');
    fprintf('       effect 1 - early      vs late.        \n');
    fprintf('       effect 2 - exchange   vs regular.     \n');
    fprintf('       effect 3 - presubgoal vs postsubgoal. \n');
    tools_repanova(t,[2,2,2]);
    
end