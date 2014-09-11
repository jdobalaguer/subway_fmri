
function tools_mapspread(old_allo,times)
    
    % angles
    u_angle = ['000';'090';'180';'270'];
    nb_angles = size(u_angle,1);
    
    for i_angle = 1:nb_angles
        for i_times = 1:times

            angle_str = u_angle(i_angle,:);
            angle_num = str2double(angle_str);
            
            % rotate
            allo = old_allo.duplicate();
            allo.id = old_allo.id;
            allo.rotate(angle_num);

            % translate
            map = allo_translate(allo);
            map.angle = angle_num;

            % save
            i_file = 0;
            filename = ['data',filesep,'maps',filesep,'todo',filesep,'mapfile_',num2str(map.id),'_',angle_str,'_',num2str(i_file),'.mat'];
            while exist(filename,'file')
                i_file = i_file+1;
                filename = ['data',filesep,'maps',filesep,'todo',filesep,'mapfile_',num2str(map.id),'_',angle_str,'_',num2str(i_file),'.mat'];
            end
            fprintf('tools_mapspread: saving map %s\n',filename);
            save(filename,'map','allo');
            
        end
    end
    fprintf('\n');
end