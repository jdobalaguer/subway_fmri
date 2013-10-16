if ~parameters.flag_timechange; return; end
if end_of_trial; return; end

init_gs = GetSecs;
this_gs = init_gs;
end_gs = init_gs + parameters.time_exchange;

ptb.screen_time_this = init_gs;
ptb.screen_time_next = end_gs;

while this_gs < end_gs
    %% draw
    % background
    Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
    % cercle out
    d = parameters.screen_wait.rayon_circle + .5*parameters.screen_wait.thick_circle;
    c = ptb.screen_center;
    r = [c(1)-d,c(2)-d,c(1)+d,c(2)+d];
    Screen(ptb.screen_w, 'FillOval',  parameters.screen_wait.color,r);
    % cercle out
    d = parameters.screen_wait.rayon_circle - .5*parameters.screen_wait.thick_circle;
    c = ptb.screen_center;
    r = [c(1)-d,c(2)-d,c(1)+d,c(2)+d];
    Screen(ptb.screen_w, 'FillOval',  ptb.screen_bg_color,r);
    % hand bar
    theta = -.5*pi + 2*pi*(this_gs-init_gs)/(end_gs-init_gs);
    x = ptb.screen_center(1) + [0 , parameters.screen_wait.rayon_hand * cos(theta)];
    y = ptb.screen_center(2) + [0 , parameters.screen_wait.rayon_hand * sin(theta)];
    dx = .5 * parameters.screen_wait.thick_hand * sin(theta);
    dy = .5 * parameters.screen_wait.thick_hand * cos(theta);
    Screen(ptb.screen_w, 'FillPoly', parameters.screen_wait.color,[x(1)-dx,y(1)+dy;...
                                 x(1)+dx,y(1)-dy;...
                                 x(2)+dx,y(2)-dy;...
                                 x(2)-dx,y(2)+dy]);
    % hand rounds
    r = [   x(1) - .5*parameters.screen_wait.thick_hand,...
            y(1) - .5*parameters.screen_wait.thick_hand,...
            x(1) + .5*parameters.screen_wait.thick_hand,...
            y(1) + .5*parameters.screen_wait.thick_hand ...
        ];
    Screen(ptb.screen_w, 'FillOval', parameters.screen_wait.color, r);
    r = [   x(2) - .5*parameters.screen_wait.thick_hand,...
            y(2) - .5*parameters.screen_wait.thick_hand,...
            x(2) + .5*parameters.screen_wait.thick_hand,...
            y(2) + .5*parameters.screen_wait.thick_hand ...
        ];
    Screen(ptb.screen_w, 'FillOval', parameters.screen_wait.color, r);
    %% Flip
    [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');
    this_gs = tmp_stimulusonset;
end

clear init_gs this_gs end_gs;
clear d c r theta x y dx dy;
clear tmp_vbltimestamp tmp_stimulusonset;
