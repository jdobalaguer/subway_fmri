if end_of_trial && ~resp.bool; return; end
if end_of_trial && ~parameters.flag_timelimit; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Draw stations
    % goal station
if parameters.flag_showsublines
    tmp_sublines = 2*unique(ceil(.5*map.links(:,map.avatar.to_station)));
    tmp_sublines(~tmp_sublines) = [];
    tmp_nb       = length(tmp_sublines);
    tmp_color    = nan(tmp_nb,3);
    for i_sublines = 1:tmp_nb
        tmp_color(i_sublines,:) = map.sublines(tmp_sublines(i_sublines)).color;
    end
else
    tmp_color = [];
end
parameters.screen_goalstation.stationstr = [map.stations(map.avatar.to_station).name,' Station'];
ptb_screen_station(ptb,parameters.screen_goalstation,tmp_color);
    % in station
tmp_sublines = 2*unique(ceil(.5*map.links(:,map.avatar.in_station)));
tmp_sublines(~tmp_sublines) = [];
tmp_nb       = length(tmp_sublines);
tmp_color    = nan(tmp_nb,3);
for i_sublines = 1:tmp_nb
    tmp_color(i_sublines,:) = map.sublines(tmp_sublines(i_sublines)).color;
end
if parameters.flag_blackandwhite
    tmp_color = [];
end
parameters.screen_instation.labelstr = 'this is';
if ~(exist('do_enum','var') && do_enum && exist('tmp_askstations','var') && tmp_askstations(i_trial))
    parameters.screen_instation.stationstr = [map.stations(map.avatar.in_station).name,' Station'];
end
ptb_screen_station(ptb,parameters.screen_instation,tmp_color);
    % bar
Screen('DrawLine',  ptb.screen_w, ...
                    parameters.screen_bar_color,...
                    ptb.screen_center(1) - .5*parameters.screen_bar_drx*ptb.screen_drect(1),... fromH
                    ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_bar_ry, ... fromV
                    ptb.screen_center(1) + .5*parameters.screen_bar_drx*ptb.screen_drect(1),... toH
                    ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_bar_ry, ... toV
                    parameters.screen_bar_thick);
    % reward
if parameters.flag_showreward && exist('end_of_block','var')
    if map.rewards(i_block)==1
        str_reward = [' reward is ',num2str(map.rewards(i_block)),' coin '];
    else
        str_reward = [' REWARD IS ',num2str(map.rewards(i_block)),' COINS '];
    end
    nbr_reward = Screen('TextBounds',ptb.screen_w,str_reward);
    DrawFormattedText(ptb.screen_w,str_reward,...
        ptb.screen_center(1)                                              - .5*nbr_reward(3),...
        ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_bar_ry - .5*nbr_reward(4)...
        );
end


%% Set available options
if ~end_of_trial
    % number of options
    if parameters.flag_optionscross
        nb_options = parameters.screen_optionscross.nb;
    else
        nb_options = parameters.screen_optionsline.nb;
    end
    % sublines
    options_sublines = map.links(map.avatar.in_station,:);
    options_sublines(~options_sublines) = [];
    % resize (to nb_options)
    options_sublines((nb_options+1):end) = [];
    options_sublines(end+1:nb_options) = 0;
    % enabled
    options_enabled = (options_sublines>0);
    % stations
    options_stations = zeros(1,nb_options);
    for i_options = 1:nb_options
        if options_sublines(i_options)
            options_stations(i_options) = find(options_sublines(i_options)==map.links(map.avatar.in_station,:));
        end
    end
    % distances
    options_dists = nan(1,nb_options);
    for i_options = 1:nb_options
        if options_stations(i_options)
            options_dists(i_options) = map.dists.steptimes_stations(map.avatar.to_station,options_stations(i_options));
        end
    end
    % symbols
    options_symbols(1:nb_options) = ' ';
    for i_options = 1:nb_options
        if options_enabled(i_options)
            tmp_nextpos = map.stations(options_stations(i_options)).position;
            tmp_thispos = map.stations(map.avatar.in_station).position;
            tmp_step    = tmp_nextpos-tmp_thispos;
            if      all(tmp_step == [+1,0])
                options_symbols(i_options) = 'R';
            elseif  all(tmp_step == [-1,0])
                options_symbols(i_options) = 'L';
            elseif  all(tmp_step == [0,+1])
                options_symbols(i_options) = 'D';
            elseif  all(tmp_step == [0,-1])
                options_symbols(i_options) = 'U';
            else
                error('ptb_screen_trial: error. step is not a cardinal');
            end
        end
    end
    % thicks
    options_thicks(1:nb_options) = parameters.screen_optionflags.exchange_thick;
    options_sizes(1:nb_options)  = parameters.screen_optionflags.exchange_size;
    % modifications
        % reorder if cross options
    if parameters.flag_optionscross
        new_optionsenabled  = zeros(1,nb_options);
        new_optionssublines = zeros(1,nb_options);
        new_optionsstations = zeros(1,nb_options);
        new_optionsdists    = nan(1,nb_options);
        new_optionssymbols(1:nb_options) = ' ';
        for i_options = 1:nb_options
            if options_enabled(i_options)
                switch options_symbols(i_options)
                    case 'R'
                        to_option = 1;
                    case 'U'
                        to_option = 2;
                    case 'L'
                        to_option = 3;
                    case 'D'
                        to_option = 4;
                end
                new_optionsenabled(to_option)  = options_enabled(i_options);
                new_optionssublines(to_option) = options_sublines(i_options);
                new_optionsstations(to_option) = options_stations(i_options);
                new_optionsdists(to_option)    = options_dists(i_options);
                new_optionssymbols (to_option) = options_symbols(i_options);
            end
        end
        options_enabled  = new_optionsenabled;
        options_sublines = new_optionssublines;
        options_stations = new_optionsstations;
        options_dists    = new_optionsdists;
        options_symbols  = new_optionssymbols;
    end
        % randomise
    if parameters.flag_randomize
        i_options = randperm(nb_options);
        options_enabled  = options_enabled(i_options);
        options_sublines = options_sublines(i_options);
        options_stations = options_stations(i_options);
        options_dists    = options_dists(i_options);
        options_symbols  = options_symbols(i_options);
        options_thicks   = options_thicks(i_options);
        options_sizes    = options_sizes(i_options);
    end
        % thicks
    if parameters.flag_arrowthicks && i_trial>1 && (~exist('do_quiz','var') || ~do_quiz)
            % forward
        i_options = (options_sublines==map.avatar.in_subline);
        options_thicks(i_options) = parameters.screen_optionflags.forward_thick;
            % backward
        if mod(map.avatar.in_subline,2)
            i_options = find(options_sublines==(map.avatar.in_subline+1));
        else
            i_options = find(options_sublines==(map.avatar.in_subline-1));
        end
        options_thicks(i_options) = parameters.screen_optionflags.backward_thick;
    end
        % thicks
    if parameters.flag_arrowsizes && i_trial>1 && (~exist('do_quiz','var') || ~do_quiz)
            % forward
        i_options = (options_sublines==map.avatar.in_subline);
        options_sizes(i_options)  = parameters.screen_optionflags.forward_size;
            % backward
        if mod(map.avatar.in_subline,2)
            i_options = find(options_sublines==(map.avatar.in_subline+1));
        else
            i_options = find(options_sublines==(map.avatar.in_subline-1));
        end
        options_sizes(i_options)  = parameters.screen_optionflags.backward_size;
    end
        % remove forward
    if parameters.flag_forward
        i_options = (options_sublines==map.avatar.in_subline);
        options_sublines(i_options) = 0;
        options_stations(i_options) = 0;
        options_dists(i_options)    = nan;
        options_symbols(i_options)  = 0;
        options_thicks(i_options)   = nan;
        options_sizes(i_options)    = parameters.screen_optionflags.exchange_size;
    end
        % enable changes
    switch parameters.flag_disabledchanges
        case 1
            % forward
            i_options = (options_sublines==map.avatar.in_subline);
            % backward
            if mod(map.avatar.in_subline,2) i_options(options_sublines==(map.avatar.in_subline+1)) = 1;
            else                            i_options(options_sublines==(map.avatar.in_subline-1)) = 1;
            end
            % disable other lines line
            options_enabled(~i_options) = 0;
        case 2
            % forward
            i_options = (options_sublines==map.avatar.in_subline);
            % backward
            if mod(map.avatar.in_subline,2) i_options(options_sublines==(map.avatar.in_subline+1)) = 1;
            else                            i_options(options_sublines==(map.avatar.in_subline-1)) = 1;
            end
            % disable this line
            options_enabled(i_options) = 0;
    end
end

%% Draw options
if parameters.flag_optionscross
    % option frame
    ptb_screen_station(ptb,parameters.screen_optioncrossstation,[]);
    % tmp values
    tmp_nb  = 4;
    tmp_sx  = parameters.screen_optionscross.sx;
    tmp_dx  = parameters.screen_optionscross.dx;
    tmp_nxs = ptb.screen_center(1)                                                          + .5 * cos(-pi*[0:.5:1.5]) *(tmp_sx+tmp_dx); % x positions
    tmp_nys  = ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_optionscross.ry   + .5 * sin(-pi*[0:.5:1.5]) *(tmp_sx+tmp_dx); % y positions
else
    % option frame
    ptb_screen_station(ptb,parameters.screen_optionlinestation,[]);
    % tmp values
    tmp_nb  = nb_options;
    tmp_sx  = parameters.screen_optionsline.sx;
    tmp_dx  = parameters.screen_optionsline.dx;
    tmp_nxs = ptb.screen_center(1) + .5 * ((1-tmp_nb):2:(tmp_nb-1))*(tmp_sx+tmp_dx); % x positions
    tmp_nys  = ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_optionsline.ry * ones(1,tmp_nb);
end
    % draw selected option
if end_of_trial
    ptb_screen_symbol(  ptb.screen_w,...
                        '*',...
                        255 - .5*(255-map.sublines(resp.subline).color),...
                        tmp_nxs(resp.option),...
                        1.5*tmp_sx,...
                        tmp_nys(resp.option));
end
    % draw options
Screen(ptb.screen_w, 'TextFont',            parameters.screen_optionsline.fontname);
Screen(ptb.screen_w, 'TextSize',            parameters.screen_optionsline.fontsize);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_optionsline.fontbgcolor);
for i_options = 1:tmp_nb
    if options_enabled(i_options)
        % set option
        tmp_symbol = options_symbols(i_options);
        tmp_thick  = options_thicks(i_options);
        if parameters.flag_blackandwhite
            tmp_color = [0,0,0];
        else
            tmp_color = map.sublines(options_sublines(i_options)).color;
        end
        if parameters.flag_optionscross
            tmp_textcolor = parameters.screen_optionscross.fontcolor;
            tmp_keyname   = parameters.screen_optionscross.keynames{i_options};
        else
            tmp_textcolor = parameters.screen_optionsline.fontcolor;
            tmp_keyname   = parameters.screen_optionsline.keynames{i_options};
        end
    else
        if options_sublines(i_options) && parameters.flag_showdisabled
            % disabled option
            tmp_symbol = options_symbols(i_options);
            tmp_thick  = options_thicks(i_options);
            tmp_color = [223,223,223];
            if parameters.flag_optionscross
                tmp_textcolor = parameters.screen_optionscross.fontcolor;
                tmp_keyname   = parameters.screen_optionscross.keynames{i_options};
            else
                tmp_textcolor = parameters.screen_optionsline.fontcolor;
                tmp_keyname   = parameters.screen_optionsline.keynames{i_options};
            end
        else
            % no option
            tmp_symbol = 'O';
            tmp_thick  = options_thicks(i_options);
            tmp_color = [223,223,223];
            if parameters.flag_optionscross
                tmp_textcolor = parameters.screen_optionscross.fontcolor;
                tmp_keyname   = parameters.screen_optionscross.keynames{i_options};
            else
                tmp_textcolor = parameters.screen_optionsline.fontcolor;
                tmp_keyname   = parameters.screen_optionsline.keynames{i_options};
            end
        end
    end
    % draw symbol
    ptb_screen_symbol(  ptb.screen_w,...
                        tmp_symbol,...
                        tmp_color,...
                        tmp_nxs(i_options),...
                        options_sizes(i_options)*tmp_sx,...
                        tmp_nys(i_options),...
                        tmp_thick);
end

%% Enum List
if exist('do_enum','var') && do_enum && exist('tmp_askstations','var') && tmp_askstations(i_trial)
    if exist('resp','var') && isfield(resp,'resp_istation')
        resp_istation = resp.resp_istation;
    else
        resp_istation = nan;
    end
    if exist('resp','var') && isfield(resp,'in_istation')
        in_istation = resp.in_istation;
    else
        in_istation = nan;
    end
    br_names = ptb_screen_enumlist(ptb,parameters.screen_list,[tmp_lastnames,tmp_nextnames],i_trial,resp_istation,in_istation);
end
%% Flip
[tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
if parameters.flag_timelimit && ~end_of_trial
    % start distinction for limited time response
    ptb.screen_time_this = tmp_stimulusonset;
    ptb.screen_time_next = tmp_stimulusonset + parameters.time_response;
else
    ptb.screen_time_this = tmp_stimulusonset;
    ptb.screen_time_next = tmp_stimulusonset;
end

%% Clean
clear i_sublines;
clear i_nxs i_options to_option;
clear str_reward nbr_reward;
clear new_optionsenabled new_optionsstations new_optionssublines new_optionsdists new_optionssymbols;
clear tmp_nb tmp_sx tmp_dx tmp_nxs tmp_ny tmp_nys tmp_sublines tmp_nbr;
clear tmp_nextpos tmp_thispos tmp_step;
clear tmp_symbol tmp_color tmp_textcolor tmp_keyname tmp_thick;
clear tmp_vbltimestamp tmp_stimulusonset;
