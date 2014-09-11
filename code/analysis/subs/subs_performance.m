
function subs_performance()
    block = load_block_ext('scanner');

    %% values
    optimal = block.resp_dist_station_journey - block.optm_dist_station_journey;    % find how much long participants took, on average
    optimal = optimal ./ block.optm_dist_station_journey;                           % normalise
    optimal(optimal < 0) = nan;                                                     % remove uncompleted journeys
    [m,e] = jb_getvector(optimal,block.expt_subject);                               % get average for each participant

    %% figure
    fig_figure;             % new figure
    fig_steplot(1:22,m,e);  % plot shades
    fig_errplot(1:22,m,e);  % plot bars
    fig_figure(gcf);

    sa.title = ''; %'performance';
    sa.xlim = [0.5,22.5];
    sa.ylim = [0,1];
    sa.xlabel = '';%'participant ';
    sa.ylabel = '';%'optimal length ratio ';
    sa.xtick  = 1:22;
    sa.xticklabel = {''};%num2leg(1:22);
    sa.ytick  = linspace(0,1,3);
    sa.yticklabel = strcat('2^',num2leg(sa.ytick));
    fig_axis(sa);
    fig_axis(sa);

    fig_fontname();
    fig_fontsize();
end
