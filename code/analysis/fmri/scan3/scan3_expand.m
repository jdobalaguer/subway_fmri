
function scan3_expand()
    %% WARNINGS
    %#ok<*AGROW>
    %#ok<*DEFNU>
    %#ok<*FPARK>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_study                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_study,'sub_*']); dir_subs = strcat(dir_study,strvcat(dir_subs.name),'/');
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    dir_epis4                   = strcat(dir_subs,'epi4',filesep);
    
    %% EXPAND: nii4 to nii3
    for i_sub = 1:size(dir_subs, 1); 
        dir_sub  = strtrim(dir_subs(i_sub,:));
        dir_epi3 = strtrim(dir_epis3(i_sub,:));
        dir_epi4 = strtrim(dir_epis4(i_sub,:));
        file_epis4 = dir([dir_epi4,'images*.nii']);
        fprintf('Expand for:                      %s\n',dir_sub);
        for i_run = 1:length(file_epis4)
            dir_run   = sprintf('%srun%d/',dir_epi3,i_run);
            mkdirp(dir_run);
            dir_img   = strcat(dir_run,'images',filesep);
            mkdirp(dir_img);
            file_epi4 = strcat(dir_epi4,file_epis4(i_run).name);
            if isempty(dir([dir_img,'images*.nii']))
                spm_file_split(file_epi4,dir_img);
            end
        end
    end
end