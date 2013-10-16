function plot_quiz_map()
    % load results
    allresults = load_results();
    
    % numbers
    u_participants = unique(allresults.trial_quiz.exp_sub);
    nb_participants = length(u_participants);
    
    u_map = unique(allresults.trial_quiz.exp_map);
    nb_maps = length(u_map);
    
    % values
    cors  = nan(nb_participants,nb_maps);
    total = nan(nb_participants,nb_maps);
    for i_participant = 1:nb_participants
        for i_map = 1:nb_maps
            ii_trial =  find( ...
                            (u_participants(i_participant)  == allresults.trial_quiz.exp_sub) & ...
                            (u_map(i_map)                   == allresults.trial_quiz.exp_map) & ...
                            (allresults.trial_quiz.exp_quiz > 3) ...
                        );
            cors(i_participant, i_map) = sum(allresults.trial_quiz.resp_cor(ii_trial));
            total(i_participant,i_map) = length(ii_trial);
        end
        
    end
    
    % figure
    figure('color',[1,1,1]);
    hold on;
    
    % plot
    values = cors./total;
    tools_dotplot(values);
    for i_map = 1:nb_maps
        plot(i_map*ones(1,nb_participants),values(:,i_map),'rx');
    end
    plot(1:nb_maps,.5*ones(1,nb_maps),'k--'); % random

    % label
    xlabel = 'maps';
    set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
    ylabel = 'performance';
    set(get(gca,'ylabel'),'string',ylabel,'fontsize',16,'fontname','Arial');

    % ticks
    set(gca,'xtick',1:nb_maps);
    x_label = {};
    for i_map = 1:nb_maps
        x_label{end+1} = ['map_',num2str(u_map(i_map))];
    end
    set(gca,'xticklabel',x_label);
    ymin = 0;
    set(gca,'ytick',ymin:.1:1);
    ylim([ymin,1]);
end