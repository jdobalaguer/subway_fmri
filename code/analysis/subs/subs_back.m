
function tmp_back()
    block = load_block_ext('scanner');

    %% values
    m = jb_getvector(block.resp_direction_back_any,block.expt_subject);

    %% figure
    fig_figure;             % new figure
    fig_plot(1:22,m);       % plot
    fig_figure(gcf);

    sa.title = ''; %'performance';
    sa.xlim = [0.5,22.5];
    sa.ylim = [0,1];
    sa.xlabel = '';%'participant ';
    sa.ylabel = '';%'optimal length ratio ';
    sa.xtick  = 1:22;
    sa.xticklabel = {''};%num2leg(1:22);
    sa.ytick  = linspace(0,1,5);
    sa.yticklabel = num2leg(sa.ytick);
    fig_axis(sa);
    fig_axis(sa);

    fig_fontname();
    fig_fontsize();
end
