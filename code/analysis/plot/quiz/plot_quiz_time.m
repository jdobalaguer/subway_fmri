function plot_quiz_time(session)
    % load results
    allresults = load_results(session);
    
    % numbers
    u_participants = unique(allresults.block_quiz.exp_sub);
    u_quiz         = unique(allresults.block_quiz.exp_quiz);
    nb_participants = length(u_participants);
    nb_quiz         = length(u_quiz);
    
    % values
    values  = nan(nb_participants,nb_quiz);
    for i_participant = 1:nb_participants
        for i_quiz = 1:nb_quiz
            ii_trial = find( ...
                            (u_participants(i_participant)  == allresults.trial_quiz.exp_sub) & ...
                            (u_quiz(i_quiz)                 == allresults.trial_quiz.exp_quiz)  ...
                        );

            perfo = allresults.trial_quiz.resp_cor(ii_trial);
            randv = [];
            for i_trial = ii_trial
                randv(end+1) = sum(allresults.trial_quiz.resp_optionsdists(:,i_trial)==nanmin(allresults.trial_quiz.resp_optionsdists(:,i_trial))); % good options
                randv(end)   = randv(end) / allresults.trial_quiz.resp_nboptions(i_trial);                                                          % over total options
            end
            values(i_participant, i_quiz) = nanmean((perfo-randv)./(1-randv));
        end
    end

    % figure
    f = figure();
    
    % plot
    m = mean(values);
    e = std( values)./sqrt(nb_participants);
    fig_barweb(m,e,...
                        [],...                                                 width
                        [],...                                                 group names
                        '',...                                                 title
                        '',...                                                 xlabel
                        '',...                                                 ylabel
                        fig_color('jet')./255,...                              colour
                        [],...                                                 grid
                        {'quiz 1','quiz 2','quiz 3','quiz 4','quiz 5',  ...
                         'quiz 6','quiz 7','quiz 8','quiz 9','quiz 10'},...    legend
                        2,...                                                  error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    % pretty figures
    sa_plot.title   = 'Quiz performance';
    sa_plot.ylabel  = 'normalised score';
    sa_plot.xtick   = [];
    sa_plot.ytick   = 0:0.2:1;
    sa_plot.ylim    = [0,1];
    fig_axis(sa_plot);
    fig_figure(f);
end