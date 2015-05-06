
function figure_PPI()
    %% FIGURE_PPI()
    % display average b_hat for each ROI/seed.

    %% warnings
    
    %% function
    
    % subject
    u_subject = [1:5,7:9,11:22];
    n_subject = length(u_subject);

    % seeds
    u_seed = {'dlPFC','PostC','rAmyg','rAngG','rCaud','sParC2','vmPFC'};
%     u_seed  = {'dlPFC','PostC','rCaud2'};
    u_seed  = {'dlPFC','PostC','rCaud'};
    n_seed = length(u_seed);
    u_mask = u_seed;
%     u_mask  = {'dlPFC','PostC','rCaud2'};
%     u_mask  = {'PostC'};
    n_mask = length(u_mask);

    % conditions
    u_cond = {  'data/ppi/roi_%s/copy/statistic_1/PPI(C)/spmT_sub%02i*.img',...
                'data/ppi/roi_%s/copy/statistic_1/PPI(L)/spmT_sub%02i*.img',...
                'data/ppi/roi_%s/copy/statistic_1/PPI(I)/spmT_sub%02i*.img',...
                'data/ppi/roi_%s/copy/statistic_1/PPI(R)/spmT_sub%02i*.img',...
             };
    n_cond = length(u_cond);
    
    % tests
%     u_test = {  [+1,-1,+1,-1],...
%                 [+1,+1,-1,-1],...
%                 [+1,-1,-1,+1],...
%                 [+1, 0,-1, 0],...
%                 [-1,-1,-1,+3],...
%                 [+3,-1,-1,-1]};
%     n_test = length(u_test);
%     l_test = {  'X     ',...
%                 'S     ',...
%                 'XS    ',...
%                 'C!=I  ',...
%                 'R!=CLI',...
%                 'C!=LIR',...
%                 };
    u_test = {[+3,-1,-1,-1]};
    n_test = length(u_test);
    l_test = {'C!=LIR'};
    
    u_test = {[+1, 0, 0, 0]};
    n_test = length(u_test);
    l_test = {'C'};
    
%     u_test = {[0,+1, 0, 0],[0, 0,+1, 0],[0, 0, 0,+1]};
%     n_test = length(u_test);
%     l_test = {'L','I','R'};
            
    
    % values
    v = nan(n_seed,n_mask,n_cond,n_subject);
    jb_parallel_progress(numel(v));
    for i_seed = 1:n_seed
        for i_mask = 1:n_mask
            for i_cond = 1:n_cond
                for i_subject = 1:n_subject
                    spmt = sprintf(u_cond{i_cond},u_seed{i_seed},u_subject(i_subject));
                    spmt_path = fileparts(spmt);
                    spmt_name = dir(spmt);
                    spmt_name = spmt_name.name;
                    spmt = [spmt_path,filesep,spmt_name];
                    mask = scan_nifti_load(['data/mask/ROI_gnone/mask/',u_mask{i_mask},'.img']);
                    v(i_seed,i_mask,i_cond,i_subject) = mean(scan_nifti_load(spmt,mask));
                    jb_parallel_progress();
                end
            end
        end
    end
    jb_parallel_progress(0);
    m = mean(v,4);
    e = ste(v,4);
        
    % figure
    fig_figure();
    j_subplot = 0;
    for i_seed = 1:n_seed
        for i_mask = 1:n_mask
            
            % statistic
            s = struct('tstat',{},'df',{},'sd',{},'h',{},'ci',{},'p',{});
            for i_test = 1:n_test
                t = squeeze(v(i_seed,i_mask,:,:))';
                t = t .* repmat(u_test{i_test},n_subject,1);
                t = sum(t,2);
                [h,p,ci,stats] = ttest(t,0,'tail','right');
                if p < 0.01
                    cprintf('*black','seed:  %s \n',u_seed{i_seed});
                    cprintf('*black','mask:  %s \n',u_mask{i_mask});
                    fprintf('%s = ',l_test{i_test});
                    cprintf('red','t(%d) = %+.2f, p = %.3f ',stats.df,stats.tstat,p);
                    fprintf('\n');
                elseif p < 0.05
                    cprintf('*black','seed:  %s \n',u_seed{i_seed});
                    cprintf('*black','mask:  %s \n',u_mask{i_mask});
                    fprintf('%s = ',l_test{i_test});
                    cprintf('blue','t(%d) = %+.2f, p = %.3f ',stats.df,stats.tstat,p);
                    fprintf('\n');
                elseif p < 0.10
                    cprintf('*black','seed:  %s \n',u_seed{i_seed});
                    cprintf('*black','mask:  %s \n',u_mask{i_mask});
                    fprintf('%s = ',l_test{i_test});
                    cprintf(repmat(.5,1,3),'t(%d) = %+.2f, p = %.3f ',stats.df,stats.tstat,p);
                    fprintf('\n');
                end
                stats.h  = h; stats.ci = ci; stats.p  = p;
                s(i_test) = stats;
            end
            
            % plot
            j_subplot = j_subplot + 1;
            subplot(n_seed,n_mask,j_subplot);
            this_m = squeeze(m(i_seed,i_mask,:))';
            this_e = squeeze(e(i_seed,i_mask,:))';
            fig_bare(this_m,this_e,'hsv','',{'C','L','I','R'});
            sa = struct();
            sa.title = {['seed: ',u_seed{i_seed}] ; ['mask: ',u_mask{i_mask}]};
            sa.ylim  = [-1.5,+2.5];
            sa.ytick = -1:+2;
            fig_axis(sa);
            set(gca(),'Visible','off');
        end
    end
    fig_rmtext();
    
end
