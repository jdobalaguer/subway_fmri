function plot_data_maptime(session)
    % load results
    allresults = load_results(session);
    
    % numbers
    u_participants  = unique(allresults.block_quiz.exp_sub);
    nb_participants = length(u_participants);
    nb_bins         = 5;
    u_bins          = linspace(0,1,nb_bins+1);
    
    % values
    values  = nan(nb_participants,nb_bins);
    for i_participant = 1:nb_participants
        ii_participant = (u_participants(i_participant)  == allresults.trial_data.exp_sub);
        u_blocks       = unique(allresults.trial_data.exp_block(ii_participant));
        nb_blocks      = length(u_blocks);
        
        for i_bin = 1:nb_bins
            min_block = nb_blocks * u_bins(i_bin);
            max_block = nb_blocks * u_bins(i_bin+1);
            ii_minblock  = (allresults.trial_data.exp_block >= min_block);
            ii_maxblock  = (allresults.trial_data.exp_block <= max_block);
            ii_trial = ( ...
                            ii_participant & ...
                            ii_minblock    & ...
                            ii_maxblock      ...
                        );

            maptime = allresults.trial_data.resp_maptime(ii_trial);
            values(i_participant, i_bin) = nanmean(maptime);
        end
    end

    % figure
    f = figure();
    
    % plot
    m = mean(values)-4;
    e = std( values)./sqrt(nb_participants);
    fig_barweb(m,e,...
                        [],...                                                 width
                        [],...                                                 group names
                        '',...                                                 title
                        '',...                                                 xlabel
                        '',...                                                 ylabel
                        fig_color('jet')./255,...                              colour
                        [],...                                                 grid
                        {'bin 1','bin 2','bin 3','bin 4','bin 5'},...          legend
                        2,...                                                  error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    % pretty figures
    sa_plot.title   = 'Time looking at the map';
    sa_plot.ylabel  = 'time (s)';
    sa_plot.xtick   = [];
    sa_plot.ytick   = 0:2:6;
    sa_plot.yticklabel = {'4','6','8','10'};
    sa_plot.ylim    = [0,6];
    fig_axis(sa_plot);
    fig_figure(f);
end