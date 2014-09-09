
function plot_rt()
    %% parameters
    r_subject = [6,10];
    ytick     = 600:200:1400;
    
    %% load
    data = load_data_ext('scanner');
    
    %% numbers
    [u_subject,  n_subject ] = numbers(data.expt_subject);
    [u_switch,   n_switch  ] = numbers(data.resp_direction_switch);
    [u_exchange, n_exchange] = numbers(data.vbxi_exchange_in);
    
    %% values
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
    v(r_subject,:,:) = [];
    m = meeze(v);
    e = steeze(v);
    
    %% axis
    sa = struct();
    sa.ytick   = ytick - ytick(1);
    sa.ylim    = [0 , ytick(end)-ytick(1)];
    sa.yticklabel = {''};
    m          = m - ytick(1);
        
    %% plot
    f = figure();
    fig_barweb(m,e,...
            [],...                                                  width
            {'',''},...                                             group names
            '',...                                                  title
            '',...                                                  xlabel
            '',...                                                  ylabel
            fig_color('gray')./255,...                              colour
            'y',...                                                 grid
            {'',''},...                                             legend
            2,...                                                   error sides (1, 2)
            'axis'...                                               legend ('plot','axis')
            );
    fig_axis(sa);
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end