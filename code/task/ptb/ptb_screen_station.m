function ptb_screen_station(ptb,plot_struct,sublinescolor)
    
    % set values
        % screen
    screen_w        = ptb.screen_w;
    screen_rect     = ptb.screen_rect;
    screen_dx       = screen_rect(3)-screen_rect(1);
    screen_dy       = screen_rect(4)-screen_rect(2);
    screen_mx       = ptb.screen_center(1);
    screen_my       = ptb.screen_center(2);
    nx              = screen_mx;
    ny              = plot_struct.stationry*screen_dy + screen_rect(2);
        % box
    box_thick       = plot_struct.boxthick;
    box_dx          = plot_struct.boxdx;
    box_dy          = plot_struct.boxdy;    
    box_colorin     = plot_struct.boxcolorin;
    box_colorout    = plot_struct.boxcolorout;
        % label
    label_dy        = plot_struct.labeldy;
    label_str       = plot_struct.labelstr;
    label_fontcolor = plot_struct.labelfontcolor;
    label_fontname  = plot_struct.labelfontname;
    label_fontsize  = plot_struct.labelfontsize;
        % station
    station_str         = plot_struct.stationstr;
    station_fontcolor   = plot_struct.stationfontcolor;
    station_fontname    = plot_struct.stationfontname;
    station_fontsize    = plot_struct.stationfontsize;
    
    
    % boundaries
    Screen(screen_w, 'TextSize', station_fontsize);
    nbr_station = Screen('TextBounds',screen_w,station_str);
    Screen(screen_w, 'TextSize', label_fontsize);
    nbr_label   = Screen('TextBounds',screen_w,label_str);
    
    dx_nbr_station = nbr_station(3)-nbr_station(1);
    dy_nbr_station = nbr_station(4)-nbr_station(2);
    
    dx_nbr_label = nbr_label(3)-nbr_label(1);
    dy_nbr_label = nbr_label(4)-nbr_label(2);
    
    % positions
    nx_station  = nx - .5*dx_nbr_station;
    ny_station  = ny - .5*dy_nbr_station;
    
    nx1_box = nx_station - box_dx;
    ny1_box = ny_station - box_dy;
    nx2_box = nx_station + dx_nbr_station + box_dx;
    ny2_box = ny_station + dy_nbr_station + box_dy;
    rect_box   = [nx1_box,ny1_box,nx2_box,ny2_box];
    
    if plot_struct.boxround
        dy_round = .5 * plot_struct.boxround * (ny2_box - ny1_box);
        nx1_round = nx1_box + dy_round;
        ny1_round = ny1_box + dy_round;
        nx2_round = nx2_box - dy_round;
        ny2_round = ny2_box - dy_round;
        
        nx1_disk = nx1_box + 2*dy_round;
        ny1_disk = ny1_box + 2*dy_round;
        nx2_disk = nx2_box - 2*dy_round;
        ny2_disk = ny2_box - 2*dy_round;
    end
    
    nx_label   = nx -.5*dx_nbr_label;
    ny_label   = ny1_box -label_dy -.5*dy_nbr_label;
    
    % draw
        % box
    Screen(screen_w, 'FillRect',  box_colorin , rect_box);
    Screen(screen_w, 'FrameRect', box_colorout, rect_box, box_thick);
        % round
            % corner UL
    Screen(screen_w, 'FillRect', ptb.screen_bg_color,[nx1_box,ny1_box,nx1_round,ny1_round]);
    disk_rect = [nx1_box , ny1_box , nx1_disk , ny1_disk];
    Screen(screen_w, 'FillArc',  box_colorin,disk_rect,-90,90);
    Screen(screen_w, 'FrameArc', box_colorout,disk_rect,-90,90,box_thick);
            % corner UR
    Screen(screen_w, 'FillRect', ptb.screen_bg_color,[nx2_round,ny1_box,nx2_box,ny1_round]);
    disk_rect = [nx2_disk , ny1_box , nx2_box , ny1_disk];
    Screen(screen_w, 'FillArc',  box_colorin,disk_rect,0,90);
    Screen(screen_w, 'FrameArc', box_colorout,disk_rect,0,90,box_thick);
            % corner LL
    Screen(screen_w, 'FillRect', ptb.screen_bg_color,[nx1_box,ny2_round,nx1_round,ny2_box]);
    disk_rect = [nx1_box , ny2_disk , nx1_disk , ny2_box];
    Screen(screen_w, 'FillArc',  box_colorin,disk_rect,180,90);
    Screen(screen_w, 'FrameArc', box_colorout,disk_rect,180,90,box_thick);
            % corner LR
    Screen(screen_w, 'FillRect', ptb.screen_bg_color,[nx2_round,ny2_round,nx2_box,ny2_box]);
    disk_rect = [nx2_disk , ny2_disk , nx2_box , ny2_box];
    Screen(screen_w, 'FillArc',  box_colorin,disk_rect,90,90);
    Screen(screen_w, 'FrameArc', box_colorout,disk_rect,90,90,box_thick);
        % station
    Screen(screen_w, 'TextFont', station_fontname);
    Screen(screen_w, 'TextSize', station_fontsize);
    Screen(screen_w, 'TextColor', station_fontcolor);
    Screen(screen_w, 'TextBackgroundColor', box_colorin);
    DrawFormattedText(screen_w,station_str,nx_station,ny_station);
        % label
    Screen(screen_w, 'TextFont', label_fontname);
    Screen(screen_w, 'TextSize', label_fontsize);
    Screen(screen_w, 'TextColor', label_fontcolor);
    Screen(screen_w, 'TextBackgroundColor', ptb.screen_bg_color);
    DrawFormattedText(screen_w,label_str,nx_label,ny_label);
        %sublines
    tmp_nb  = size(sublinescolor,1);
    tmp_sx  = 20;
    tmp_dx  = 20;
    tmp_nxs = ptb.screen_center(1) + .5 * ((1-tmp_nb):2:(tmp_nb-1))*(tmp_sx+tmp_dx);
    tmp_ny  = ptb.screen_rect(2) + ptb.screen_drect(2)*plot_struct.stationry + 1.5*plot_struct.boxdx;
    for i_sublines =1:tmp_nb
        ptb_screen_symbol(  ptb.screen_w,...
                            'O',...                         symbol
                            sublinescolor(i_sublines,:),... color
                            tmp_nxs(i_sublines),...         x position
                            tmp_sx,...                      x size
                            tmp_ny ...                      y position
                        );
    end
end