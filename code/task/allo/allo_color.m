function allo = allo_color(allo)
    
    % numbers
    nb_sublines = length(allo.main_sublines);
    
    % random colors
    ok = 0;
    steps = 0.001;
    max_dist = 1;
    while ~ok
        colors_hsv = ones(.5*nb_sublines,3) - ...
            [   1.00*rand(.5*nb_sublines,1) , ... % hue (color)
                0.50*ones(.5*nb_sublines,1) , ... % saturation
                0.00*ones(.5*nb_sublines,1) ...   % value (brightness)
            ];
        dists = pdist(colors_hsv);
        if all(dists>max_dist)
            ok = 1;
        end
        max_dist = max_dist + steps * (min(dists) - max_dist);
    end
    
    colors_rgb = 255*hsv2rgb(colors_hsv);
    
    % set color
    for i_sublines = 1:(.5*nb_sublines)
        % allo
        allo.main_sublines(2*i_sublines - 1).draw_color = colors_rgb(i_sublines,:);
        allo.main_sublines(2*i_sublines    ).draw_color = colors_rgb(i_sublines,:);
    end
    
    % view
    allo_view(allo.duplicate());
end

function dists = pdist(vecs)
    dists = [];
    for i_vec = 1:size(vecs,1)
        for j_vec = (i_vec+1):size(vecs,1)
            dists(end+1) = sqrt(sum(power(vecs(i_vec,:) - vecs(j_vec,:),2)));
        end
    end
end