function plot_data_subreltimestations()
    % load results
    allresults = load_results();
    
    % numbers
    u_participant  = unique(allresults.block_data.exp_sub);
    nb_participants = length(u_participant);
    max_block       = max(allresults.block_data.exp_block);
    
    % figure
    figure('color',[1,1,1]);
    
    for i_participant = 1:nb_participants
        % values
        stations = nan(1,max_block);
        u_block         = unique(allresults.block_data.exp_block(u_participant(i_participant)==allresults.block_data.exp_sub));
        nb_blocks        = length(u_block);
        for i_block = 1:nb_blocks
            j_block =  (u_participant(i_participant) == allresults.block_data.exp_sub) & ...
                       (u_block(i_block)              == allresults.block_data.exp_block);
            stations(i_block) = allresults.block_data.rel_time_stations(j_block);
        end
        
        % plot
        subplot(1,nb_participants,i_participant);
        hold on;
        plot(stations);

        % label
        xlabel = 'stations';
        set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
        ylabel = 'performance';
        set(get(gca,'ylabel'),'string',ylabel,'fontsize',16,'fontname','Arial');

        % ticks
        set(gca,'xtick',1:2);
        set(gca,'xticklabel',{'regular','exchange'});
        ymax = 5;
        set(gca,'ytick',0:1:ymax);
        ylim([0,ymax]);
    end
end