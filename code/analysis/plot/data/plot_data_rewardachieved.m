function plot_data_rewardachieved(session)
    % load results
    try
        allresults = load_results(session);
    catch
        set_results(session);
        allresults = load_results(session);
    end
    data = allresults.trial_data;
    
    % set mean rts for each participant
    u_par   = unique(data.exp_sub);
    n_par   = [6,10];
    u_par(n_par) = [];
    u_rew = unique(allresults.block_data.avatar_reward);
    nb_pars = length(u_par);
    nb_rews = length(u_rew);
    
    % values
    achieved = zeros(nb_pars,nb_rews);
    total    = zeros(nb_pars,nb_rews);
    for i_par = 1:nb_pars
        ii_par = (u_par(i_par)==allresults.block_data.exp_sub);
        u_block   = unique(allresults.block_data.exp_block(ii_par));
        nb_blocks = length(u_block);
        for i_block = 1:nb_blocks
            ii_block = (u_block(i_block) == allresults.block_data.exp_block);
            ii_bailout = (allresults.block_data.rel_time_stations<1);
            % store reward
            reward = allresults.block_data.avatar_reward(ii_par & ii_block & ~ii_bailout);
            if ~isnan(reward)
                i_reward = find(u_rew==reward);
                achieved(i_par,i_reward) = achieved(i_par,i_reward) + allresults.block_data.avatar_achieved(ii_par & ii_block & ~ii_bailout);
                total(i_par,i_reward)    = total(i_par,i_reward)    + 1;
            end
        end
    end
        
    %% plot
    t = achieved./total;
    m = nanmean(t);
    e = nanstd( t)./sqrt(sum(~isnan(t)));
    f = figure();
    set(gca,'position',get(gca,'position')+[0,+.05,0,-.1])
    fig_barweb(m,e,...
                        [],...                                                 width
                        [],...                                                 group names
                        '',...                                                 title
                        'reward',...                                           xlabel
                        'probability (achieved)',...                           ylabel
                        fig_color('gray')./255,...                              colour
                        'y',...                                                grid
                        {'low','high'},...                                     legend
                        2,...                                                  error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    sa.xticklabel = [];
    sa.ytick      = 0:.25:1;
    sa.ylim       = [sa.ytick(1),sa.ytick(end)];
    fig_axis(sa);
    fig_figure(f);
end