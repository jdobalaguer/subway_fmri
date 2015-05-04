
function figure_RT0()
    %% FIGURE_RT0
    
    %% warnings
    
    %% function
    
    % parameters
    r_subject = [6,10];
    ytick     = 800:100:1200;
    
    % load
    data = load_data_ext('scanner');
    data = rmfield(data,{'resp_dist_station_diff','resp_dist_station_goal','resp_dist_station_start','resp_dist_subline_goal'});
    ii_away    = (~data.resp_away_any);
    ii_subject = ~jb_anyof(data.expt_subject,r_subject);
    ii_bool    = data.resp_bool;
    ii_line    = (data.optm_dist_subline_journey < 3);
    ii = (ii_away & ii_subject & ii_bool & ii_line);
    data = struct_filter(data,ii);
    
    % numbers
    [u_subject,  n_subject ] = numbers(data.expt_subject);
    [u_switch,   n_switch  ] = numbers(data.resp_direction_switch);
    [u_exchange, n_exchange] = numbers(data.vbxi_exchange_in);
    
    % values
    v = nan(n_subject,n_switch,n_exchange);
    for i_subject = 1:n_subject
        for i_switch = 1:n_switch
            for i_exchange = 1:n_exchange
                ii_subject  = (data.expt_subject          == u_subject(i_subject));
                ii_switch   = (data.resp_direction_switch == u_switch(i_switch));
                ii_exchange = (data.vbxi_exchange_in      == u_exchange(i_exchange));
                ii          = (ii_subject & ii_switch & ii_exchange);
                v(i_subject,i_switch,i_exchange) = 1000 .* nanmean(data.resp_reactiontime(ii));
            end
        end
    end
    
    % filter
    m = meeze(v);
    e = steeze(v);
    
    % stats
    jb_anova(v,{'RT','Switch','Exchange'});
    
    % axis
    sa = struct();
    sa.ytick   = ytick - ytick(1);
    sa.ylim    = [0 , ytick(end)-ytick(1)];
    sa.yticklabel = ytick;
    m          = m - ytick(1);
        
    % plot
    f = figure();
    fig_bare(m,e,fig_color('gray',4),{'Same response','Switch response'},{'Exchange','Regular'});
    fig_axis(sa);
    fig_figure(f);
    
end