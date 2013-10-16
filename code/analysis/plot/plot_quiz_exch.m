function plot_quiz_exch()
    % load results
    allresults = load_results();
    
    % numbers
    u_participants = unique(allresults.trial_quiz.exp_sub);
    nb_participants = length(u_participants);
    
    % values
    cors  = zeros(nb_participants,2);
    total = zeros(nb_participants,2);
    for i_participant = 1:nb_participants
        for i_exchange = [0,1]
            ii_trial =  find( ...
                            (u_participants(i_participant)  == allresults.trial_quiz.exp_sub) & ...
                            (i_exchange                     == allresults.trial_quiz.avatar_inexchange) & ...
                            (allresults.trial_quiz.exp_quiz == 2) ... 
                        );
            cors(i_participant, i_exchange+1) = sum(allresults.trial_quiz.resp_cor(ii_trial));
            total(i_participant,i_exchange+1) = length(ii_trial);
        end
        
    end
    
    % figure
    figure('color',[1,1,1]);
    hold on;
    
    % plot
    tools_dotplot(cors./total);
    plot(1:2,[.5,.5],'k--'); % random

    % label
    xlabel = 'stations';
    set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
    ylabel = 'performance';
    set(get(gca,'ylabel'),'string',ylabel,'fontsize',16,'fontname','Arial');

    % ticks
    set(gca,'xtick',1:2);
    set(gca,'xticklabel',{'regular','exchange'});
    ymin = 0;
    set(gca,'ytick',ymin:.1:1);
    ylim([ymin,1]);
end