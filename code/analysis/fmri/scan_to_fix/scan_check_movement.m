
function scan_check_movement()
    dir_niistudy = [pwd(),filesep,'data',filesep,'nii',filesep];
    
    u_sub = 1:20;
    n_sub = length(u_sub);
    
    u_run = 1:4;
    n_run = length(u_run);
    
    fig_figure();
    j_subplot = 0;
    for i_sub = 1:n_sub
        for i_run = 1:n_run
            j_subplot = j_subplot + 1;
            subplot(n_sub,n_run,j_subplot);
            dir_run  = sprintf('%ssub_%02i/epi3/run%d/realignment/',dir_niistudy,u_sub(i_sub),u_run(i_run));
            file_run = dir(sprintf('%srp_*.txt',dir_run));
            file_run = [dir_run,file_run.name];
            if exist(file_run,'file')
                R = load(file_run);
                plot(R);
            end
            sa = struct();
            sa.ylim = [-5,+5];
            if i_run==1, sa.ylabel = sprintf('%d',i_sub); end
            fig_axis(sa);
        end
    end
end