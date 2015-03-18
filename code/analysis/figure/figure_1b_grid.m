
function figure_1b()
    %% parameters
    r_subject = [6,10];
    n_div = 3;
    
    %% load
    data = load_data_ext('scanner');
    data = struct_fun(data,@(x)double(x));
    
    data.condition  = 2 * data.resp_direction_switch + data.vbxi_exchange_in;
    data.expt_trial = ceil((data.expt_trial - 1) / n_div);
    data.optm_dist_station_goal = ceil((data.optm_dist_station_goal - 1) / n_div);
    
    %% values
    ii_bool = logical( data.resp_bool);
    ii_forw = logical(~data.resp_direction_back);
    ii_corr = logical(~data.resp_away_any);
    ii_subj = ~jb_anyof(data.expt_subject,r_subject);
    ii_nsta = logical( data.expt_trial > 0);
    ii_hard = logical( data.optm_dist_subline_journey > 1);
    ii = (ii_bool & ii_forw & ii_subj & ii_corr);
   
    x = getm_mean(data.resp_reactiontime(ii),data.expt_subject(ii),data.expt_trial(ii),data.optm_dist_station_goal(ii),data.condition(ii));
    h = getm_hist(data.expt_subject(ii),data.expt_trial(ii),data.optm_dist_station_goal(ii),data.condition(ii));
%     x(h(:) < 5) = nan;
    mx = meeze(x);
    
    %% figure
    
    l_plot = {'R','I','L','C'};
    u_plot = eye(4);
    sa.clim = [0,1.600];

%     l_plot = {'C>LIR','X','S'};
%     u_plot(1,:) = [-1,-1,-1,+1];
%     u_plot(2,:) = [-1,+1,-1,+1];
%     u_plot(3,:) = [-1,-1,+1,+1];
%     sa.clim = [-0.1,+0.6];
    
    n_plot = size(u_plot,1);
    
    f = fig_figure();
    for i_plot = 1:n_plot
        subplot(1,n_plot,i_plot);
        px = nan([size(mx,1),size(mx,2),0]);
        nx = nan([size(mx,1),size(mx,2),0]);
        for i_condition = 1:4
            switch u_plot(i_plot,i_condition)
                case +1
                    px(:,:,end+1) = mx(:,:,i_condition);
                case -1
                    nx(:,:,end+1) = mx(:,:,i_condition);
                case 0
                otherwise
                    error('?');
            end
        end
        px = nanmean(px,3);
        nx = nanmean(nx,3);
        if ~any(u_plot(i_plot,:)>0), px = zeros(sizep(mx,1:2)); end
        if ~any(u_plot(i_plot,:)<0), nx = zeros(sizep(mx,1:2)); end
        tx = px - nx;
        fig_pimage(tx);
        colorbar();
        
        sa.title = l_plot{i_plot};
        sa.xlabel = 'distance to goal';
        sa.ylabel = 'trial';
        fig_axis(sa);
    end
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
    
end