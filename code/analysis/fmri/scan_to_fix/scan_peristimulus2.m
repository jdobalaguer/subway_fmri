
function scan_peristimulus2()
    % Plot peristimulus BOLD signal
    % (after running scan_glm(); with glm_function = 'fir')
    
    %% WARNINGS
    %#ok<*NOPRT,*FPARK,*AGROW>

    %% PARAMETERS
    name_gsm        = 'GLMM_fir8&0_Cues_Fill_Easy_Hard(X+S+XS+Z)_Feed';
    name_mask       = 'X_vmpfc'; ... examples: 'v1' 'right' 'vmpfc' 'insula' 'ba32'
    contrast        = 'Hard(XS)_';
    extension       = 'img';    ... examples: 'nii', 'img'
    u_time          = 0:+1:+7;

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    % data
    dir_glm                         = [pwd(),filesep,'data',filesep,'glm',filesep,name_gsm,filesep];
    dir_contrast                    = [dir_glm,'contrasts',filesep];
    % masks
    dir_mask                        = [pwd(),filesep,'data',filesep,'mask',filesep];
    file_mask                       = [dir_mask,name_mask,'.img'];
    
    %% load mask
    mask = spm_vol(file_mask);
    mask = double(mask.private.dat);
    mask = logical(mask(:));
    
    %% values
    values = [];
    fils_contrast = dir([dir_contrast,'con_',contrast,'*.',extension]);
    fils_contrast = strcat(dir_contrast,strvcat(fils_contrast.name));
    for i_contrast = 1:size(fils_contrast,1)
        file_contrast = strtrim(fils_contrast(i_contrast,:));
        nii = spm_vol(file_contrast);
        nii = double(nii.private.dat);
        nii = nii(mask);
        values(i_contrast) = nanmean(nii(:));
    end
    
    %% plot
    n_time  = length(u_time);
    n_order = size(fils_contrast,1);
    u_order = 1:n_order;
    assert(n_order == n_time,sprintf('scan_peristimulus2: error. n_order(%d) and n_time(%d) not consistent',n_order,n_time));
    
    fig_figure();
    hold on;
    
    plot([0,u_order],zeros(size(u_order)+1),'--k');
    fig_plot(u_order(u_time< 0),values(u_time< 0),'Color',fig_color('wong',   1)/255);
    fig_plot(u_order(u_time>=0),values(u_time>=0),'Color',fig_color('clovers',1)/255);

    sa.title  = sprintf('peristimulus time statistics (%s)',name_mask);
    sa.xlim   = [0,n_order];
    sa.xtick  = u_order;
    sa.xticklabel = num2leg(u_time);
    sa.xlabel = 'time (sec)';
    sa.ylim   = [-8,+8];
    sa.ylabel = sprintf('T statistic (con = %s)',contrast);
    
    fig_axis(sa);

end
