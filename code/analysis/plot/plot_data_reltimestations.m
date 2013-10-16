function plot_data_reltimestations()
    % load results
    allresults = load_results();
    
    % numbers
    u_participant  = unique(allresults.block_data.exp_sub);
    nb_participants = length(u_participant);
    max_block       = max(allresults.block_data.exp_block);
    
    % values
    stations = nan(nb_participants,max_block);
    for i_participant = 1:nb_participants
        u_block         = unique(allresults.block_data.exp_block(u_participant(i_participant)==allresults.block_data.exp_sub));
        nb_blocks        = length(u_block);
        for i_block = 1:nb_blocks
            j_block =  (u_participant(i_participant) == allresults.block_data.exp_sub) & ...
                       (u_block(i_block)              == allresults.block_data.exp_block);
            stations(i_participant,i_block) = allresults.block_data.rel_time_stations(j_block);
        end
    end
    
    % figure
    figure('color',[1,1,1]);
    
    % plot
    tools_dotplot(stations);
    
    % label
    xlabel = 'block';
    set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
    ylabel = 'ratio of length of journey';
    set(get(gca,'ylabel'),'string',ylabel,'fontsize',16,'fontname','Arial');
    
    % ticks
    set(gca,'xtick',1:20:120);
    set(gca,'ytick',1:6);
    ylim([1,6]);
%}
end