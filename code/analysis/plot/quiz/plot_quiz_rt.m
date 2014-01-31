
function plot_quiz_rt(session)
    % load results
    allresults = load_results(session);
    
    % numbers
    u_participants = unique(allresults.block_quiz.exp_sub);
    u_quiz         = unique(allresults.block_quiz.exp_quiz);
    nb_participants = length(u_participants);
    nb_quiz         = length(u_quiz);
    
    % values
    values  = nan(nb_participants,2);
    for i_participant = 1:nb_participants
        for i_quiz = 1:nb_quiz
            ii_trial = ( ...
                            (u_participants(i_participant)  == allresults.trial_quiz.exp_sub) & ...
                            (u_quiz(i_quiz)                 == allresults.trial_quiz.exp_quiz)  ...
                        );

            rt = allresults.trial_quiz.resp_rt(ii_trial);
            values(i_participant, i_quiz) = 1000*nanmean(rt);
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
    sa_plot.ytick   = 0:2000:8000;
    sa_plot.ylim    = [0,8000];
    fig_axis(sa_plot);
    fig_figure(f);
end