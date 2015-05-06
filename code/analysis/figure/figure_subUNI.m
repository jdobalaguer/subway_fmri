
function d = figure_subUNI(roi)
    %% FIGURE_subUNI()
    % plot the average b_hat around conditions
    % roi = 'dlPFC';
    % roi = 'PostC';
    % roi = 'rAmyg';
    % roi = 'rAngG';
    % roi = 'rCaud';
    % roi = 'sParC2';
    % roi = 'vmPFC';
    
    %% warnings
    %#ok<*AGROW>
    
    %% function
    
    % preload file
    f = sprintf('.subUNI/figure_subUNI_%s.mat',roi);
    if exist(f,'file')
        load(f,'data');
    else
        % load data
        data = load_data_ext('scanner');
        data = rmfield(data,{'resp_dist_station_diff','resp_dist_station_goal','resp_dist_station_start','resp_dist_subline_goal'});
        ii_subject = ~jb_anyof(data.expt_subject,[6,10]);
        data = struct_filter(data,ii_subject);

        % add beta
        load('data/mvpa/glm/normalisation4/image_Trial_1_2_3_4_5_7_8_9_11_12_13_14_15_16_17_18_19_20_21_22.mat');
        beta = scan.mvpa.variable.beta;
        beta = cell2mat(beta')';
        mask = logical(scan_nifti_load(sprintf('data/mask/ROI_gnone/mask/%s.img',roi)));
        data.beta = nanmean(beta(:,mask),2);
        save(f,'data');
    end
    
    % filter data
    ii_away    = (~data.resp_away_any);
    ii_bool    = data.resp_bool;
    ii_line    = (data.optm_dist_subline_journey < 3);
    ii = (ii_away & ii_bool & ii_line);
    data = struct_filter(data,ii);
    
    % convolve
    d    = get_values(data);
    ii = (d.onset==0 | d.subcond==4);
    ii = ii & jb_anyof(d.onset,-3:3);
    d = struct_transpose(struct_filter(struct_transpose(d),ii));
    
    % get values
    x    = unique(d.onset);
    z    = getm_mean(d.beta,d.subject,d.onset,d.condition);
    m    = meeze(z,1);
    e    = steeze(z,1);
    
    %% errplot
    fig_figure();
    hold('on');
    c = fig_color('hsv',4);
    l = {'C','L','I','R'};
    h = [];
    for i = 1:size(m,2)
        h{i} = fig_errplot(x,m(:,i)',e(:,i)',c(i,:));
        h{i} = h{i}.errbar;
    end
    fig_axis(struct('ilegend',{[h{:}]},'tlegend',{l}));
    fig_figure(gcf());
    
    %% axis
    sa.tlegend = {'C','L','I','R'};
    sa.ilegend = [h{:}];
    sa.title   = roi;
%     sa.ytick   = -1:+2;
%     sa.ylim    = [-1.5,+2.5];
    fig_axis(sa);
    plot([0,0],get(gca(),'ylim'),'k--');
    legend('off');
    set(gca,'YColor','w');
    fig_rmtext();

    %% stats
%     cprintf('*black','%s [t+1]-[t-1]: \n',roi);
%     rmz = squeeze(z(:,x==+1,:) - z(:,x==-1,:));
%     fprintf('C : '); jb_ttest(rmz(:,1));
%     fprintf('L : '); jb_ttest(rmz(:,2));
%     fprintf('I : '); jb_ttest(rmz(:,3));
%     fprintf('R : '); jb_ttest(rmz(:,4));
%     fprintf('C>LIR : '); jb_ttest(rmz(:,1) - mean(rmz(:,2:4),2));
%     rmz = reshape(rmz,[size(rmz,1),2,2]);
%     jb_anova(rmz,{'RT','Exchange','Switch'});
%     fig_figure(); fig_bare(meeze(rmz),steeze(rmz),'hsv',[],sa.tlegend,0.8);

%     cprintf('*black','%s [t-1]: \n',roi);
%     rmz = squeeze(z(:,x==-1,:));
%     fprintf('C : '); jb_ttest(rmz(:,1));
%     fprintf('L : '); jb_ttest(rmz(:,2));
%     fprintf('I : '); jb_ttest(rmz(:,3));
%     fprintf('R : '); jb_ttest(rmz(:,4));
%     fprintf('C>LIR : '); jb_ttest(rmz(:,1) - mean(rmz(:,2:4),2));
%     rmz = reshape(rmz,[size(rmz,1),2,2]);
%     jb_anova(rmz,{'RT','Exchange','Switch'});

%     cprintf('*black','%s [t+1]: \n',roi);
%     rmz = squeeze(z(:,x==+1,:));
%     fprintf('C : '); jb_ttest(rmz(:,1));
%     fprintf('L : '); jb_ttest(rmz(:,2));
%     fprintf('I : '); jb_ttest(rmz(:,3));
%     fprintf('R : '); jb_ttest(rmz(:,4));
%     fprintf('C>LIR : '); jb_ttest(rmz(:,1) - mean(rmz(:,2:4),2));
%     rmz = reshape(rmz,[size(rmz,1),2,2]);
%     jb_anova(rmz,{'RT','Exchange','Switch'});
end

%% auxiliar
function d = get_values(data)
    % experiment
    e.subject   = data.expt_subject;
    e.session   = data.expt_session;
    e.block     = data.expt_block;
    e.trial     = data.expt_trial;
    e.condition = 4 - ((2 .* data.resp_direction_switch) + data.vbxi_exchange_in);
    e.station   = data.vbxi_station_in;
    e.beta      = data.beta;
    
    % discard
    ii.discard  = (data.resp_away_any | ~data.resp_bool);
    ii.discard  = (~data.resp_correct_all);
    ii.discard  = zeros(size(data.expt_subject));
    e = struct_filter(e,~ii.discard);
    
    % result
    d = struct();
    d.subject   = [];
    d.session   = [];
    d.block     = [];
    d.trial     = [];
    d.onset     = [];
    d.condition = [];
    d.subcond   = [];
    d.station   = [];
    d.beta      = [];
    
    % subject loop
    [u.subject,n.subject] = numbers(e.subject);
    for i_subject = 1:n.subject
        subject = u.subject(i_subject);
        ii.subject = (e.subject == subject);
        
        % session loop
        [u.session,n.session] = numbers(e.session(ii.subject));
        for i_session = 1:n.session
            session = u.session(i_session);
            ii.session = (e.session == session);
            
            % block loop
            [u.block,n.block] = numbers(e.block(ii.subject & ii.session));
            for i_block = 1:n.block
                block = u.block(i_block);
                ii.block = (e.block == block);
                ii.journey = (ii.subject & ii.session & ii.block);
                n.journey  = sum(ii.journey);

                % trial loop
                [u.trial,n.trial] = numbers(e.trial(ii.subject & ii.session & ii.block));
                for i_trial = 1:n.trial
                    trial = u.trial(i_trial);
                    ii.trial = (e.trial == trial);

                    % get values
                    condition = e.condition(ii.subject & ii.session & ii.block & ii.trial);
                    station   = e.station(ii.subject & ii.session & ii.block & ii.trial);
                    
                    
                    d.subject   (end+1:end+n.journey) = repmat(subject,   1,n.journey);
                    d.session   (end+1:end+n.journey) = repmat(session,   1,n.journey);
                    d.block     (end+1:end+n.journey) = repmat(block,     1,n.journey);
                    d.trial     (end+1:end+n.journey) = repmat(trial,     1,n.journey);
                    d.onset     (end+1:end+n.journey) = e.trial(ii.journey) - trial;
                    d.condition (end+1:end+n.journey) = repmat(condition, 1,n.journey);
                    d.subcond   (end+1:end+n.journey) = e.condition(ii.journey);
                    d.station   (end+1:end+n.journey) = repmat(station,   1,n.journey);
                    d.beta      (end+1:end+n.journey) = e.beta(ii.journey);

                end
            end
        end
    end
end