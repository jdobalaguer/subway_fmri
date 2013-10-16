function allo_view(allo_map)
    
    if ~exist('allo_map','var')
        allo_map = load('files/allo.mat');
        allo_map = allo_map.allo;
    end
    
    % monitor
    monitor = allo_monitor();

    try
        % set map
        monitor.monitor_open([1,0,0]);
        monitor.map_resize(allo_map);

        % draw map
        monitor.map_simpledraw(allo_map);

        % wait until keyboard
        while KbCheck; end
        while ~KbCheck; end
        
        % save
        imwrite(Screen('GetImage', monitor.screen_window, monitor.screen_rect),['allo_',num2str(randi(10000)),'.png']);

        % close monitor
        monitor.monitor_close();
    catch err
        % close monitor
        monitor.monitor_close();
        rethrow(err);
    end
    
end
