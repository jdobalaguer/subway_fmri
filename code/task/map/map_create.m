function map_create()
    number_of_rings = 2;
    grid_size       = [10,10];
    nb_stations     = [10,10,10,10];
    min_exchanges   = [1 ,1 ,1 ,1];

    %% Allocentric map

    % create
    ok = 0;
    nb_sublines = length(nb_stations);
    while ~ok
        [ok,allo] = allo_create(number_of_rings,...
                                grid_size,...
                                nb_stations,...
                                min_exchanges,...
                                ones(1,nb_sublines),...
                                zeros(1,nb_sublines),...
                                ones(1,nb_sublines));
    end

    %% Egocentric map

    % translate and change color
    allo = allo_color(allo);
    
    %% Save
    switch input('save? ','s')
        case '0'
        otherwise
            % translate
            map = allo_translate(allo);

            % create folder
            if ~exist('files','dir')
                mkdir('files');
            end
            
            % find filename
            filename = ['files/allmap_',num2str(randi(100)),'.mat'];
            while exist(filename,'file')
                filename = ['files/allmap_',num2str(randi(100)),'.mat'];
            end
            fprintf(['map_create: saving as ''',filename,'''\n']);
            
            % save
            save(filename,'map','allo');
    end
end