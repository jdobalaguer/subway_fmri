
function figure_1b()
    %% parameters
    r_subject = [6,10];
    ytick     = 400:200:1600;
    
    %% load
    data = load_data_ext('scanner');
    
    %% values
    ii_bool = logical( data.resp_bool);
    ii_forw = logical(~data.resp_direction_back);
    ii_corr = logical( data.resp_correct_all);
    ii_subj = ~jb_anyof(data.expt_subject,r_subject);
    ii_hard = logical( data.optm_dist_subline_journey > 1);
    ii_nsta = logical( data.expt_trial > 0);
    ii = (ii_bool & ii_forw & ii_subj & ii_corr & ii_hard & ii_nsta);
    
    s  = data.expt_subject(ii)';
    y{1} = get_zscore( data.resp_direction_switch(ii) &  data.vbxi_exchange_in(ii), data.expt_subject(ii))';
    y{2} = get_zscore(~data.resp_direction_switch(ii) &  data.vbxi_exchange_in(ii), data.expt_subject(ii))';
    y{3} = get_zscore( data.resp_direction_switch(ii) & ~data.vbxi_exchange_in(ii), data.expt_subject(ii))';
    y{4} = get_zscore(~data.resp_direction_switch(ii) & ~data.vbxi_exchange_in(ii), data.expt_subject(ii))';
    x{1} = get_zscore(data.expt_trial(ii),                                          data.expt_subject(ii))';
    x{2} = get_zscore(data.optm_dist_station_goal(ii),                              data.expt_subject(ii))';
    
    [u_s,n_s] = numbers(s);
    n_y = length(y);
    
    b = [];
    for i_s = 1:n_s
            ii_s = (s == u_s(i_s));
            
            X = [x{1}(ii_s),x{2}(ii_s)];
            for i_y = 1:n_y
                Y = y{i_y}(ii_s);
                b(i_s,i_y,:) = glmfit(X,Y);
            end
            
    end
    
    m = meeze(b);
    e = steeze(b);
    f = fig_figure();
    
    fig_barweb(m,e,...
            [],...                                                  width
            {'C','L','I','R'},...                                   group names
            '',...                                                  title
            '',...                                                  xlabel
            '\beta',...                                             ylabel
            fig_color('gray')./255,...                              colour
            'y',...                                                 grid
            {'o','t','d'},...                                           legend
            2,...                                                   error sides (1, 2)
            'axis'...                                               legend ('plot','axis')
            );
    fig_axis();
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end