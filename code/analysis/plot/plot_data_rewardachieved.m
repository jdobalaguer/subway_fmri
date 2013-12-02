function plot_data_rewardachieved(session)
    % load results
    allresults = load_results(session);
    
    % numbers
    u_participant  = unique(allresults.block_data.exp_sub);
    nb_participants = length(u_participant);
    u_reward       = unique(allresults.block_data.avatar_reward);
    u_reward(isnan(u_reward)) = [];
    nb_rewards     = length(u_reward);
    
    % values
    achieved = zeros(nb_participants,nb_rewards);
    total    = zeros(nb_participants,nb_rewards);
    for i_participant = 1:nb_participants
        u_block         = unique(allresults.block_data.exp_block(u_participant(i_participant)==allresults.block_data.exp_sub));
        nb_blocks        = length(u_block);
        for i_block = 1:nb_blocks
            j_block =  (u_participant(i_participant) == allresults.block_data.exp_sub) & ...
                       (u_block(i_block)              == allresults.block_data.exp_block);
            % store reward
            reward = allresults.block_data.avatar_reward(j_block);
            if ~isnan(reward)
                i_reward = find(u_reward==reward);
                achieved(i_participant,i_reward) = achieved(i_participant,i_reward) + allresults.block_data.avatar_achieved(j_block);
                total(i_participant,i_reward)    = total(i_participant,i_reward)    + 1;
            end
        end
    end
    
    rel_achieved = achieved./total;
    
    % figure
    figure('color',[1,1,1]);
    colormap([.5,0,0]);
    hold on;
    
    % plot
    bar(mean(rel_achieved));
    tools_dotplot(rel_achieved);
    
    % label
    xlabel = 'reward';
    set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
    ylabel = 'probability of reaching the goal';
    set(get(gca,'ylabel'),'string',ylabel,'fontsize',16,'fontname','Arial');
    
    % x-ticks
    set(gca,'xtick',1:nb_rewards);
    x_axis = cell(1,nb_rewards);
    for i_xaxis = 1:nb_rewards
        x_axis{i_xaxis} = num2str(u_reward(i_xaxis));
    end
    set(gca,'xticklabel',x_axis);
    
    % y-ticks
    set(gca,'ytick',0:.2:1);
    ylim([0,1]);
end