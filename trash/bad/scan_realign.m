
function scan_realign(paths)
    for i_sub = 1:length(paths.subs)
        for i_run = 1:4

            path_realigned = [pwd(),'/',paths.nii,paths.subs{i_sub},'/',paths.epi3,sprintf(paths.run,i_run),paths.realigned];
            dirs_realigned = dir(path_realigned);
            file_realigned = {dirs_realigned.name};
            file_realigned = tools_undot(file_realigned);

            fprintf('\n');
            fprintf('scanrealign\n');
            fprintf('  subject     = %d / %d\n',i_sub,length(paths.subs));
            fprintf('  run         = %d / %d\n',i_run,4);
            if ~isempty(file_realigned)
                fprintf('  (skip)\n');
            else
            
                % set filenames
                path = [pwd(),'/',paths.nii,paths.subs{i_sub},'/',paths.epi3,sprintf(paths.run,i_run),paths.images];
                rexp = [path,'*.nii'];
                dirs = dir(rexp);
                file = tools_strcatcell(path,{dirs.name});
                fext = ['../',paths.realigned,'u'];

                % set batch
                batch = scan_genbatch(file,fext);

                % run batch
                fprintf('  initcfg\n');
                spm_jobman('initcfg');
                fprintf('  init job');
                job_id = cfg_util('initjob', batch);
                fprintf(' %d\n',job_id);
                try
                    fprintf('  run\n');
                    cfg_util('run', job_id);
                    fprintf('  deljob %d\n',job_id);
                    cfg_util('deljob', job_id);
                catch err
                    fprintf('  deljob %d\n',job_id);
                    cfg_util('deljob', job_id);
                    rethrow(err)
                end
            end
    
        end
    end
end

