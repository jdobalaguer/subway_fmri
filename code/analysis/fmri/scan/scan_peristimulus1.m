
function scan_peristimulus1()
    % Plot peristimulus BOLD signal
    % (after running scan_glm(); with basis_function = 'fir')
    
    %% WARNINGS
    %#ok<*NOPRT,*FPARK,*AGROW,*FNDSB>

    %% PARAMETERS
    gsm_name        = 'fir_T_55_55_15';
    mask_name       = 'vmpfc'; ... examples: 'v1' 'right' 'vmpfc' 'insula' 'ba32'
    contrast        = 'T';
    extension       = 'nii';    ... examples: 'nii', 'img'
    u_time          = -15:+1:+39;

    u_subject       = 1:20;
    u_subject([1,2,3]) = [];
    remove_sub      = find(jb_anyof(u_subject,[]));
    
    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    % data
    dir_gsm                         = [pwd(),filesep,'data',filesep,'gsm3',filesep,gsm_name,filesep];
    dir_datgsm2s                    = [dir_gsm,'secondlevel',filesep];
    % masks
    dir_mask                        = [pwd(),filesep,'data',filesep,'mask',filesep];
    file_mask                       = [dir_mask,mask_name,'.img'];
    
    %% load mask
    mask = spm_vol(file_mask);
    mask = double(mask.private.dat);
    mask = logical(mask(:));
    
    %% values
    % values = [nb_subjects,nb_contrasts]
    values = [];
    dirs_contrast = dir([dir_datgsm2s,'con_',contrast,'*']);
    dirs_contrast = strcat(dir_datgsm2s,strvcat(dirs_contrast.name),filesep);
    for i_contrast = 1:size(dirs_contrast,1)
        dir_contrast = strtrim(dirs_contrast(i_contrast,:));
        fils_subject = dir([dir_contrast,'spmT_sub*_con*.',extension]);
        fils_subject = strcat(dir_contrast,strvcat(fils_subject.name));
        value = nan(size(fils_subject,1),1);
        for i_subject = 1:size(fils_subject,1)
            fil_subject = strtrim(fils_subject(i_subject,:));
            nii = spm_vol(fil_subject);
            nii = double(nii.private.dat);
            nii = nii(mask);
            value(i_subject) = nanmean(nii(:));
        end
        value(remove_sub) = [];
        values = [values , value];
    end
        
    %% plot
    n_time  = length(u_time);
    n_order = size(dirs_contrast,1);
    u_order = 1:n_order;
    assert(n_order == n_time,sprintf('scan_peristimulus1: error. n_order(%d) and n_time(%d) not consistent',n_order,n_time));
    
    fig_figure();
    hold on;
    
    plot([0,u_order],zeros(size(u_order)+1),'--k');
    fig_steplot(u_order(u_time< 0),meeze(values(:,u_time< 0)),steeze(values(:,u_time< 0)),fig_color('wong',   1)/255);
    fig_errplot(u_order(u_time< 0),meeze(values(:,u_time< 0)),steeze(values(:,u_time< 0)),fig_color('wong',   1)/255);
    fig_steplot(u_order(u_time>=0),meeze(values(:,u_time>=0)),steeze(values(:,u_time>=0)),fig_color('clovers',1)/255);
    fig_errplot(u_order(u_time>=0),meeze(values(:,u_time>=0)),steeze(values(:,u_time>=0)),fig_color('clovers',1)/255);

    sa.title  = sprintf('peristimulus time statistics (%s)',mask_name);
    sa.xlim   = [0,n_order];
    sa.xtick  = u_order;
    sa.xticklabel = num2leg(u_time);
    sa.xlabel = 'time (sec)';
    sa.ylabel = sprintf('T statistic (con = %s)',contrast);
    
    fig_axis(sa);

end
