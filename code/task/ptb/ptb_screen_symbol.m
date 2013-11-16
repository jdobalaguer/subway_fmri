function ptb_screen_symbol(w,symbol,color,nx,sx,ny,arrow_thick)
    
    switch symbol
        case 'O'
            %% CIRCLE
            nx1 = nx - .5*sx;
            nx2 = nx + .5*sx;
            ny1 = ny - .5*sx;
            ny2 = ny + .5*sx;
            Screen(w, 'FillOval',color,[nx1,ny1,nx2,ny2]);
        case '*'
            %% STAR
            nb_spikes = 5;
            spiky = 0.333;
            % create star
            nb_spikes = nb_spikes+1;
            t_out = linspace(0,2*pi,nb_spikes);
            x_out = nx + .5 * sx * cos(-.5*pi + t_out);
            y_out = ny + .5 * sx * sin(-.5*pi + t_out);
            t_in  = .5*t_out(2) + t_out;
            x_in  = nx + .5 * sx * cos(-.5*pi + t_in) * (1-spiky);
            y_in  = ny + .5 * sx * sin(-.5*pi + t_in) * (1-spiky);
            x = nan(1,2*nb_spikes);
            x(1:2:(2*nb_spikes)) = x_out;
            x(2:2:(2*nb_spikes)) = x_in;
            y = nan(1,2*nb_spikes);
            y(1:2:(2*nb_spikes)) = y_out;
            y(2:2:(2*nb_spikes)) = y_in;
            % draw star
            Screen(w, 'FillPoly', color,[x;y]');
        case 'W'
            %% LEFT ARROW
            % create arrow points
            t = - pi/6 + linspace(0,2*pi,4) + pi;
            t(end) = [];
            x = nx + .5 * sx * cos(-.5*pi + t);
            y = ny + .5 * sx * sin(-.5*pi + t);
            % create arrow lines
            [dx,dy] = dangle(x(1),x(2),y(1),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(1)-dx,y(1)+dy;...
                                         x(1)+dx,y(1)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            [dx,dy] = dangle(x(3),x(2),y(3),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(3)-dx,y(3)+dy;...
                                         x(3)+dx,y(3)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            % round ends
            for i_t = 1:length(t)
                tmp_x1 = x(i_t) - .5*arrow_thick;
                tmp_y1 = y(i_t) - .5*arrow_thick;
                tmp_x2 = x(i_t) + .5*arrow_thick;
                tmp_y2 = y(i_t) + .5*arrow_thick;
                Screen(w, 'FillOval', color,[tmp_x1,tmp_y1,tmp_x2,tmp_y2]);
            end
        case 'E'
            %% RIGHT ARROW
            % create arrow points
            t = - pi/6 + linspace(0,2*pi,4);
            t(end) = [];
            x = nx + .5 * sx * cos(-.5*pi + t);
            y = ny + .5 * sx * sin(-.5*pi + t);
            % create arrow lines
            [dx,dy] = dangle(x(1),x(2),y(1),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(1)-dx,y(1)+dy;...
                                         x(1)+dx,y(1)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            [dx,dy] = dangle(x(3),x(2),y(3),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(3)-dx,y(3)+dy;...
                                         x(3)+dx,y(3)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            % round ends
            for i_t = 1:length(t)
                tmp_x1 = x(i_t) - .5*arrow_thick;
                tmp_y1 = y(i_t) - .5*arrow_thick;
                tmp_x2 = x(i_t) + .5*arrow_thick;
                tmp_y2 = y(i_t) + .5*arrow_thick;
                Screen(w, 'FillOval', color,[tmp_x1,tmp_y1,tmp_x2,tmp_y2]);
            end
        case 'N'
            %% UP ARROW
            % create arrow points
            t = - pi/6 + linspace(0,2*pi,4) - pi/2;
            t(end) = [];
            x = nx + .5 * sx * cos(-.5*pi + t);
            y = ny + .5 * sx * sin(-.5*pi + t);
            % create arrow lines
            [dx,dy] = dangle(x(1),x(2),y(1),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(1)-dx,y(1)+dy;...
                                         x(1)+dx,y(1)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            [dx,dy] = dangle(x(3),x(2),y(3),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(3)-dx,y(3)+dy;...
                                         x(3)+dx,y(3)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            % round ends
            for i_t = 1:length(t)
                tmp_x1 = x(i_t) - .5*arrow_thick;
                tmp_y1 = y(i_t) - .5*arrow_thick;
                tmp_x2 = x(i_t) + .5*arrow_thick;
                tmp_y2 = y(i_t) + .5*arrow_thick;
                Screen(w, 'FillOval', color,[tmp_x1,tmp_y1,tmp_x2,tmp_y2]);
            end
        case 'S'
            %% DOWN ARROW
            % create arrow points
            t = - pi/6 + linspace(0,2*pi,4) + pi/2;
            t(end) = [];
            x = nx + .5 * sx * cos(-.5*pi + t);
            y = ny + .5 * sx * sin(-.5*pi + t);
            % create arrow lines
            [dx,dy] = dangle(x(1),x(2),y(1),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(1)-dx,y(1)+dy;...
                                         x(1)+dx,y(1)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            [dx,dy] = dangle(x(3),x(2),y(3),y(2),arrow_thick);
            Screen(w, 'FillPoly', color,[x(3)-dx,y(3)+dy;...
                                         x(3)+dx,y(3)-dy;...
                                         x(2)+dx,y(2)-dy;...
                                         x(2)-dx,y(2)+dy]);
            % round ends
            for i_t = 1:length(t)
                tmp_x1 = x(i_t) - .5*arrow_thick;
                tmp_y1 = y(i_t) - .5*arrow_thick;
                tmp_x2 = x(i_t) + .5*arrow_thick;
                tmp_y2 = y(i_t) + .5*arrow_thick;
                Screen(w, 'FillOval', color,[tmp_x1,tmp_y1,tmp_x2,tmp_y2]);
            end
        otherwise
            error('ptb_screen_symbol: error. symbol doesn''t exist');
    end
end


function [dx,dy] = dangle(x1,x2,y1,y2,d)
    theta = atan2(y2-y1,x2-x1);
    dx = .5 * d * sin(theta);
    dy = .5 * d * cos(theta);
end