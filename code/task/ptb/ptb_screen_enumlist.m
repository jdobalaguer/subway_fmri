function [br_names] = ptb_screen_enumlist(ptb,plot_struct,stations_names,i_trial,resp_istation,in_istation)
    
    %% set values
    % text
    fontsize        = plot_struct.fontsize;
    fontname        = plot_struct.fontname;
    fontcolor_last  = plot_struct.fontcolor_last;
    fontcolor_next  = plot_struct.fontcolor_next;
    fontcolor_cor   = plot_struct.fontcolor_cor;
    fontcolor_bad   = plot_struct.fontcolor_bad;
    fontbgcolor     = plot_struct.fontbgcolor;
    
    % screen
    screen_w        = ptb.screen_w;
    screen_rect     = ptb.screen_rect;
    screen_dx       = screen_rect(3)-screen_rect(1);
    screen_dy       = screen_rect(4)-screen_rect(2);
    screen_mx       = ptb.screen_center(1);
    screen_my       = ptb.screen_center(2);
    
    % box
    box_thick       = plot_struct.boxthick;
    box_ppx         = plot_struct.box_prx * screen_dx + screen_rect(1);
    box_ppy         = plot_struct.box_pry * screen_dy + screen_rect(2);
    box_dpx         = plot_struct.box_drx * screen_dx;
    box_dpy         = plot_struct.box_dry * screen_dy;
    nx1_box         = box_ppx - .5*box_dpx;
    ny1_box         = box_ppy - .5*box_dpy;
    nx2_box         = box_ppx + .5*box_dpx;
    ny2_box         = box_ppy + .5*box_dpy;
    rect_box   = [nx1_box,ny1_box,nx2_box,ny2_box];
    box_colorin     = plot_struct.boxcolorin;
    box_colorout    = plot_struct.boxcolorout;
    
    if plot_struct.boxround
        dx_round = .5 * plot_struct.boxround * (nx2_box - nx1_box);
        nx1_round = nx1_box + dx_round;
        ny1_round = ny1_box + dx_round;
        nx2_round = nx2_box - dx_round;
        ny2_round = ny2_box - dx_round;
        
        nx1_disk = nx1_box + 2*dx_round;
        ny1_disk = ny1_box + 2*dx_round;
        nx2_disk = nx2_box - 2*dx_round;
        ny2_disk = ny2_box - 2*dx_round;
    end
        
    %% draw box
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
    
    %% station
    nb_names = length(stations_names);
    % boundaries
    bd_names = nan(nb_names,2);
    Screen(screen_w, 'TextFont', fontname);
    Screen(screen_w, 'TextSize', fontsize);
    Screen(screen_w, 'TextBackgroundColor', fontbgcolor);
    for i_names = 1:length(stations_names)
        bd_name = Screen('TextBounds',screen_w,stations_names{i_names});
        bd_names(i_names,:) = [bd_name(3)-bd_name(1),bd_name(4)-bd_name(2)];
    end
    % regions and drawing
    br_names = nan(nb_names,4);
    for i_names = 1:length(stations_names)
        % region
        x1 = nx1_box;
        x2 = nx2_box;
        y1 = ny1_box + (i_names-1)*(ny2_box-ny1_box)/nb_names;
        y2 = ny1_box + (i_names  )*(ny2_box-ny1_box)/nb_names;
        r = [x1,y1,x2,y2];
        br_names(i_names,:) = r;
        % color
        if i_names == in_istation
            Screen(ptb.screen_w, 'TextColor', fontcolor_cor);
        elseif i_names == resp_istation
            Screen(ptb.screen_w, 'TextColor', fontcolor_bad);
        elseif i_names < i_trial
            Screen(ptb.screen_w, 'TextColor', fontcolor_last);
        else
            Screen(ptb.screen_w, 'TextColor', fontcolor_next);
        end
        % draw name
        nx_name = mean([x1,x2]) - .5*bd_names(i_names,1);
        ny_name = mean([y1,y2]) - .5*bd_names(i_names,2);
        DrawFormattedText(screen_w,stations_names{i_names},nx_name,ny_name);
    end
end
