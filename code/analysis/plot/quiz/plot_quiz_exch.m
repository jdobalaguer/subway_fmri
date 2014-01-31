function values = plot_quiz_exch(session)
    % load results
    allresults = load_results(session);
    
    % numbers
    u_participants = unique(allresults.trial_quiz.exp_sub);
    nb_participants = length(u_participants);
    
    % figure
    figure('color',[1,1,1]);
    hold on;
    
    i_subplot = 0;
    values = {};
    for inexchange = 0:1
        i_subplot = i_subplot+1;
    
        % values
        value  = zeros(nb_participants,2);
        for i_participant = 1:nb_participants
            for toexchange = [0,1]
                ii_trial = find( ...
                                (u_participants(i_participant)  == allresults.trial_quiz.exp_sub) & ...
                                (inexchange                     == allresults.trial_quiz.avatar_inexchange) & ...
                                (toexchange                     == allresults.trial_quiz.avatar_toexchange)   ...
                            );
                        
                perfo = allresults.trial_quiz.resp_cor(ii_trial);
                randv = [];
                for i_trial = ii_trial
                    randv(end+1) = sum(allresults.trial_quiz.resp_optionsdists(:,i_trial)==nanmin(allresults.trial_quiz.resp_optionsdists(:,i_trial))); % good options
                    randv(end)   = randv(end) / allresults.trial_quiz.resp_nboptions(i_trial);                                                          % over total options
                end
                value(i_participant, toexchange+1) = mean(perfo./randv);
            end
        end
        values{i_subplot} = value;

        % plot
        subplot(1,2,i_subplot);
        hold on;
        tools_dotplot(values{i_subplot});
        plot(1:2,[1,1],'k--'); % random

        % label
        xlabel = ['stations (inexchange = ',num2str(inexchange),')'];
        set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
        ylabel = 'performance';
        set(get(gca,'ylabel'),'string',ylabel,'fontsize',16,'fontname','Arial');

        % ticks
        set(gca,'xtick',1:2);
        set(gca,'xticklabel',{'regular','exchange'});
        ymin = 0;
        ymax = 2;
        set(gca,'ytick',ymin:.2:ymax);
        ylim([ymin,ymax]);
    end
end