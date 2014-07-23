% change it, use "spm_file_split" instead!

function scan_expand(paths)
    for i_sub = 1:length(paths.subs)
        for i_run = 1:4
            path_epi4   = [paths.nii,paths.subs{i_sub},'/',paths.epi4];
            rexp_epi4   = sprintf('images*%d.nii',i_run);
            dirs_epi4   = dir([path_epi4,rexp_epi4]);
            file_epi4   = [path_epi4,dirs_epi4.name];
            assert(logical(exist(file_epi4,'file')),'file_epi4 does not exist!');
            
            path_images = [paths.nii,paths.subs{i_sub},'/',paths.epi3,sprintf(paths.run,i_run),paths.images];
            dirs_images = dir(path_images);
            file_images = {dirs_images.name};
            file_images = tools_undot(file_images);
            if isempty(file_images)
                fprintf('expand\n');
                fprintf('  subject     = %d / %d\n',i_sub,length(paths.subs));
                fprintf('  run         = %d / %d\n',i_run,4);
                fprintf('  file_epi4   = %s\n',file_epi4);
                fprintf('  path_images = %s\n',path_images);
                fprintf('\n');
                % expand epi
                copyfile(file_epi4,dirs_epi4.name);
                expand_nii_scan(dirs_epi4.name,[],path_images);
                delete(dirs_epi4.name);
            end
        end
    end    
end

