
function [texture_name,texture_id] = ptb_maketextures(w,alpha)
    
    u_paths = {   ['code',filesep,'task',filesep,'pics',filesep,'coins',filesep ] , ...
                  ['code',filesep,'task',filesep,'pics',filesep,'faces',filesep ] , ...
                  ['code',filesep,'task',filesep,'pics',filesep,'places',filesep]       };
    u_alphas = [1,alpha,alpha];
    
    % initialise
    texture_name = {};
    texture_id   = {};
    
    for i_paths = 1:length(u_paths)
        this_path = u_paths{i_paths};
        this_alpha = u_alphas(i_paths);
        
        % remove system files
        u_files = dir(u_paths{i_paths});
        while u_files(1).name(1)=='.'
            u_files(1) = [];
        end
        
        % make textures
        for i_files = 1:length(u_files)
            this_file = u_files(i_files).name;
            this_filepath = [this_path,this_file];
            this_image = uint8(imread(this_filepath));
            while size(this_image,3)<3
                this_image(:,:,end+1) = this_image(:,:,1);
            end
            this_image(:,:,4) = 255.*this_alpha;
            % name (remove extension)
            this_name = this_file;
            if length(this_name)>4
                this_name(end-3:end) = [];
            end
            % save
            texture_name{end+1} = this_name;
            texture_id{end+1}   = Screen('MakeTexture',w,this_image);
        end
    end
end
