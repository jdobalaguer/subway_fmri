if end_of_trial && ~resp.bool; return; end
if end_of_trial && ~parameters.flag_timelimit; return; end
if end_of_trial && ~parameters.flag_showresp;  return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);
Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);


%% Draw stations
    % total reward
if parameters.flag_showreward && exist('end_of_block','var')
    tmp_rewardswin   = data.avatar_reward(logical(data.exp_stoptrial)) .* ...
                       (data.resp_station(logical(data.exp_stoptrial)) == data.avatar_goalstation(logical(data.exp_stoptrial)));
    tmp_rewardstotal = data.avatar_reward(logical(data.exp_stoptrial));
    tmp_rewardstring = sprintf(parameters.screen_reward.labelstr,nansum(tmp_rewardswin),nansum(tmp_rewardstotal));
    DrawFormattedText(ptb.screen_w,tmp_rewardstring,...
        parameters.screen_reward.labelrx*ptb.screen_drect(1)+ptb.screen_rect(1),...
        parameters.screen_reward.labelry*ptb.screen_drect(2)+ptb.screen_rect(2));
    clear tmp_rewardswin tmp_rewardstotal tmp_rewardstring;
end    
    % goal station
if parameters.flag_goallines
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
if ~parameters.flag_avatarlines
    tmp_color = [];
end
parameters.screen_instation.labelstr = 'this is';
if ~(exist('do_enum','var') && do_enum && exist('tmp_askstations','var') && tmp_askstations(i_trial))
    parameters.screen_instation.stationstr = [map.stations(map.avatar.in_station).name,' Station'];
end
ptb_screen_station(ptb,parameters.screen_instation,tmp_color);
    % bar
for i_bar = 1:length(parameters.screen_bar_ry)
    Screen('DrawLine',  ptb.screen_w, ...
                        parameters.screen_bar_color,...
                        ptb.screen_center(1) - .5*parameters.screen_bar_drx*ptb.screen_drect(1),  ... fromH
                        ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_bar_ry(i_bar), ... fromV
                        ptb.screen_center(1) + .5*parameters.screen_bar_drx*ptb.screen_drect(1),  ... toH
                        ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_bar_ry(i_bar), ... toV
                        parameters.screen_bar_thick);
end
    % reward
if parameters.flag_showreward && exist('end_of_block','var')
    for i_bar = 1:length(parameters.screen_bar_ry)
        if map.avatar.reward == parameters.reward_low
            tmp_rewtexture = ptb_gettexture(ptb,'blacksilver_low');
        else
            tmp_rewtexture = ptb_gettexture(ptb,'blacksilver_high');
        end
        tmp_rewrect    = CenterRectOnPoint([0,0,267,52],...
                            ptb.screen_center(1),...
                            ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_bar_ry(i_bar));
        Screen('DrawTexture',ptb.screen_w,tmp_rewtexture,[],tmp_rewrect);
        clear tmp_rewimage tmp_rewmap tmp_rewalpha tmp_rewtexture tmp_rewrect;
    end
end


%% Set available options
if ~end_of_trial
    % number of options
    nb_options = parameters.screen_cross.nb;
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
                options_symbols(i_options) = 'E';
            elseif  all(tmp_step == [-1,0])
                options_symbols(i_options) = 'W';
            elseif  all(tmp_step == [0,+1])
                options_symbols(i_options) = 'S';
            elseif  all(tmp_step == [0,-1])
                options_symbols(i_options) = 'N';
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
        new_optionsenabled  = zeros(1,nb_options);
        new_optionssublines = zeros(1,nb_options);
        new_optionsstations = zeros(1,nb_options);
        new_optionsdists    = nan(1,nb_options);
        new_optionssymbols(1:nb_options) = ' ';
        for i_options = 1:nb_options
            if options_enabled(i_options)
                switch options_symbols(i_options)
                    case 'W'
                        to_option = 1;
                    case 'N'
                        to_option = 2;
                    case 'S'
                        to_option = 3;
                    case 'E'
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
% option frame
ptb_screen_station(ptb,parameters.screen_crossstation,[]);
% tmp values
tmp_nb  = 4;
tmp_sx  = parameters.screen_cross.sx;
tmp_dx  = parameters.screen_cross.dx;
tmp_nxs = ptb.screen_center(1)                                                  + .5 * cos(-pi*[1,0.5,1.5,0]) *(tmp_sx+tmp_dx); % x positions
tmp_nys = ptb.screen_rect(2) + ptb.screen_drect(2)*parameters.screen_cross.ry   + .5 * sin(-pi*[1,0.5,1.5,0]) *(tmp_sx+tmp_dx); % y positions

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
Screen(ptb.screen_w, 'TextFont',            parameters.screen_cross.fontname);
Screen(ptb.screen_w, 'TextSize',            parameters.screen_cross.fontsize);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_cross.fontbgcolor);
for i_options = 1:tmp_nb
    if options_enabled(i_options)
        % set option
        tmp_symbol = options_symbols(i_options);
        tmp_thick  = options_thicks(i_options);
        if parameters.flag_blackandwhite
            tmp_color = parameters.screen_crossstation.blackcolor;
        else
            tmp_color = map.sublines(options_sublines(i_options)).color;
        end
        tmp_textcolor = parameters.screen_cross.fontcolor;
    else
        if options_sublines(i_options) && parameters.flag_showdisabled
            % disabled option
            tmp_symbol = options_symbols(i_options);
            tmp_thick  = options_thicks(i_options);
            tmp_color  = parameters.screen_crossstation.disabledcolor;
            tmp_textcolor = parameters.screen_cross.fontcolor;
        else
            % no option
            tmp_symbol = 'O';
            tmp_thick  = options_thicks(i_options);
            tmp_color  = parameters.screen_crossstation.disabledcolor;
            tmp_textcolor = parameters.screen_cross.fontcolor;
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
% draw picture
if parameters.flag_showpics
    tmp_pictexture = ptb_gettexture(ptb,map.stations(map.avatar.in_station).name);
    tmp_picrect    = CenterRectOnPoint([0,0,2*parameters.screen_picture.boxdx,2*parameters.screen_picture.boxdy],...
                                        parameters.screen_picture.boxrx*ptb.screen_drect(1)+ptb.screen_rect(1),...
                                        parameters.screen_picture.boxry*ptb.screen_drect(2)+ptb.screen_rect(2));
    Screen('DrawTexture',ptb.screen_w,tmp_pictexture,[],tmp_picrect);
    clear tmp_picimage tmp_pictexture tmp_picrect;
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
if end_of_trial
    [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip');
else
    [tmp_vbltimestamp,tmp_stimulusonset] = Screen(ptb.screen_w,'Flip',ptb.screen_time_next);
end

if exist('do_quiz','var')  && do_quiz
    time.screens{end+1}  = 'quiz do';
elseif exist('do_enum','var') && do_enum
    time.screens{end+1}  = 'enum do';
elseif end_of_trial
    time.screens{end+1}  = 'trial done';
else
    time.screens{end+1}  = 'trial';
end
time.getsecs(end+1) = tmp_stimulusonset;
time.breakgs(end+1) = time.breakgs(end);

% start distinction for limited time response
if parameters.flag_timelimit
    if ~end_of_trial
        ptb.screen_time_this = tmp_stimulusonset;
        ptb.screen_time_next = tmp_stimulusonset + parameters.time_trial + parameters.time_trialjit*(2*rand()-1);
    end
else
    ptb.screen_time_this = tmp_stimulusonset;
    ptb.screen_time_next = tmp_stimulusonset;
end

%% Clean
clear i_bar;
clear i_sublines;
clear i_nxs i_options to_option;
clear str_reward nbr_reward;
clear new_optionsenabled new_optionsstations new_optionssublines new_optionsdists new_optionssymbols;
clear tmp_nb tmp_sx tmp_dx tmp_nxs tmp_ny tmp_nys tmp_sublines tmp_nbr;
clear tmp_nextpos tmp_thispos tmp_step;
clear tmp_symbol tmp_color tmp_textcolor tmp_keyname tmp_thick;
clear tmp_vbltimestamp tmp_stimulusonset;
