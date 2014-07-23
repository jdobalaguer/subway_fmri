
function scan_peristimulus1_betas()
    % Plot peristimulus BOLD signal
    % (after running scan_glm(); with basis_function = 'fir')
    
    %% WARNINGS
    %#ok<*NOPRT,*FPARK,*AGROW,*FNDSB>

    %% PARAMETERS
    gsm_name        = 'fir_T3T_55_55_15';
    mask_name       = 'v1'; ... examples: 'v1' 'right' 'vmpfc' 'insula' 'ba32'
    extension       = 'nii';    ... examples: 'nii', 'img'

    u_subject       = 1:20;
    u_subject([1,2,3]) = [];
    remove_sub      = find(jb_anyof(u_subject,[]));
    
    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    % data
    dir_gsm                         = [pwd(),filesep,'data',filesep,'gsm3',filesep,gsm_name,filesep];
    dir_datgsm2s                    = [dir_gsm,'firstlevel',filesep];
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
    dirs_subject = dir([dir_datgsm2s,'sub_*']);
    dirs_subject = strcat(dir_datgsm2s,strvcat(dirs_subject.name),filesep);
    for i_contrast = 1:size(dirs_subject,1)
        dir_subject = strtrim(dirs_subject(i_contrast,:));
        fils_betas = dir([dir_subject,'beta_*.',extension]);
        fils_betas = strcat(dir_subject,strvcat(fils_betas.name));
        value = nan(size(fils_betas,1),1);
        for i_subject = 1:size(fils_betas,1)
            fil_beta = strtrim(fils_betas(i_subject,:));
            nii = spm_vol(fil_beta);
            nii = double(nii.private.dat);
            nii = nii(mask);
            value(i_subject) = nanmean(nii(:));
        end
        value(remove_sub) = [];
        values = [values , value];
    end
    save;
    return;
        
%     %% plot
%     n_order = size(values,1);
%     u_order = 1:n_order;
%     
%     fig_figure();
%     hold on;
%     
%     plot([0,u_order],zeros(size(u_order)+1),'--k');
%     fig_steplot(u_order,meeze(values,2)',steeze(values,2)',fig_color('wong',   1)/255);
%     sa.title  = sprintf('peristimulus time statistics (%s)',mask_name);
%     sa.xlabel = 'time (sec)';
%     sa.ylabel = sprintf('T statistic');
%     sa.ylim   = [-0.1,+0.1];
%     fig_axis(sa);

end