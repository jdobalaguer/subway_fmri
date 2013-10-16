function plot_quiz_time
    % load results
    allresults = load_results();
    
    % numbers
    u_participants = unique(allresults.block_quiz.exp_sub);
    u_quiz         = unique(allresults.block_quiz.exp_quiz);
    nb_participants = length(u_participants);
    nb_quiz         = length(u_quiz);
    
    % values
    cors = nan(nb_participants,nb_quiz);
    for i_participant = 1:nb_participants
        for i_quiz = 1:nb_quiz
            i_trial =   (u_participants(i_participant) == allresults.block_quiz.exp_sub) & ...
                        (u_quiz(i_quiz)                == allresults.block_quiz.exp_quiz);
            cors(i_participant,i_quiz) = allresults.block_quiz.cor(i_trial);
        end
    end
    
    % figure
    figure('color',[1,1,1]);
    % plot
    tools_dotplot(cors);
    plot(1:nb_quiz,.5*ones(1,nb_quiz),'k--'); % random
    
    % label
    xlabel = 'quiz';
    set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
    ylabel = 'performance';
    set(get(gca,'ylabel'),'string',ylabel,'fontsize',16,'fontname','Arial');
    
    % ticks
    set(gca,'xtick',1:nb_quiz);
    ymin = 0;
    set(gca,'ytick',ymin:.1:1);
    ylim([ymin,1]);

end