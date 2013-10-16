parameters = struct();

%% debug
parameters.debug_subject = 1;
parameters.debug_preload = '';
parameters.debug_mapload = 0;

%% flag
    % permanent
parameters.flag_audio   = 1;            % use audio
parameters.flag_mail    = 0;            % alert with mails (for each mode)

parameters.flag_forward = 0;            % forward is an option
parameters.flag_arrowthicks  = 1;       % forward is thicker
parameters.flag_arrowsizes  = 1;        % forward is bigger
parameters.flag_optionscross = 1;       % use a cross form
parameters.flag_randomize = 0;          % shuffle options (doesn't make sense with the cross)
parameters.flag_showsublines = 1;       % show subline indicators under the labels
parameters.flag_showdisabled = 1;       % show arrows even when options are disabled (in change points)
% variable
parameters.flag_timelimit  = 0;         % limited response time
parameters.flag_timechange = 1;         % waiting time when switching sublines
parameters.flag_quiz = 0;               % have quizes between blocks
parameters.flag_enum = 0;               % have enumerations between blocks

%% session/modes
parameters.session = 1;                 % which session (defines the different modes in set_mode)
parameters.mode = 0;
parameters.flag_stopprob = nan;         % stochastic probability of stopping after optimal nb of steps
parameters.flag_showreward = nan;       % use rewards for each journey
parameters.flag_blackandwhite = nan;    % identify sublines with different colours
parameters.flag_disabledchanges = nan;  % switching lines requires an extra action

%% run
parameters.run_by_min = 1;
parameters.run_min    = 50;
parameters.run_by_blocks = 0;
parameters.run_blocks = 70;
parameters.run_by_trials = 0;
parameters.run_trials = 1000;

%% stop
    % needs to be >0
    % if 0, prob is always 1
    % if inf, prob is always 0
parameters.stop_power = 0.5;

%% enum
parameters.enum_min    = (.05:.05:.5)*parameters.run_min;
parameters.enum_blocks = (.05:.05:.5)*parameters.run_blocks;
parameters.enum_trials = (.05:.05:.5)*parameters.run_trials;
parameters.enum_nbsublines = 2;
parameters.enum_nbstations = 5;

%% quiz
parameters.quiz_min    = (.55:.05:1)*parameters.run_min;
parameters.quiz_blocks = (.55:.05:1)*parameters.run_blocks;
parameters.quiz_trials = (.55:.05:1)*parameters.run_trials;
parameters.quiz_nbquestions = 15;

%% reward
parameters.reward_high = 5;
parameters.reward_low  = 1;
parameters.reward_prop = 0.5;

%% screen times
parameters.time_response = 3;
parameters.time_exchange = 1;

%% screen structs
%parameters.screen_rect   = [0,0,1080,810];
parameters.screen_bg_color  = [255,255,255];

parameters.screen_fontcolor = [128,128,128];
parameters.screen_fontbgcolor = [0,0,0,0];
parameters.screen_fontsize  = 20;
parameters.screen_fontname  = 'Arial';

    % goal station
parameters.screen_goalstation = struct();
parameters.screen_goalstation.labeldy = 20;
parameters.screen_goalstation.labelfontcolor = [128,128,128];
parameters.screen_goalstation.labelfontsize  = 20;
parameters.screen_goalstation.labelfontname  = 'Arial';
parameters.screen_goalstation.labelstr = 'meeting at';
parameters.screen_goalstation.boxcolorin = parameters.screen_bg_color;
parameters.screen_goalstation.boxcolorout = [0,0,0];
parameters.screen_goalstation.boxthick = 2;
parameters.screen_goalstation.boxround = 1;
parameters.screen_goalstation.boxdx = 30;
parameters.screen_goalstation.boxdy = 10;
parameters.screen_goalstation.stationstr = ' ';
parameters.screen_goalstation.stationry = 0.2;
parameters.screen_goalstation.stationfontcolor = [0,0,0];
parameters.screen_goalstation.stationfontsize  = 20;
parameters.screen_goalstation.stationfontname  = 'Arial';

    % bar
parameters.screen_bar_drx   = 0.666;
parameters.screen_bar_ry    = 0.333;
parameters.screen_bar_thick = 1;
parameters.screen_bar_color = [128,128,128];

    % in station
parameters.screen_instation = struct();
parameters.screen_instation.labeldy = 20;
parameters.screen_instation.labelfontcolor = [128,128,128];
parameters.screen_instation.labelfontsize  = 20;
parameters.screen_instation.labelfontname  = 'Arial';
parameters.screen_instation.labelstr = 'this is';
parameters.screen_instation.boxcolorin = parameters.screen_bg_color;
parameters.screen_instation.boxcolorout = [0,0,0];
parameters.screen_instation.boxthick = 2;
parameters.screen_instation.boxround = 1;
parameters.screen_instation.boxdx = 30;
parameters.screen_instation.boxdy = 10;
parameters.screen_instation.stationstr = ' ';
parameters.screen_instation.stationry = 0.5;
parameters.screen_instation.stationfontcolor = [0,0,0];
parameters.screen_instation.stationfontsize  = 20;
parameters.screen_instation.stationfontname  = 'Arial';

    % flag options
parameters.screen_optionflags = struct();
parameters.screen_optionflags.blackandwhite_color = [0,0,0];
parameters.screen_optionflags.forward_thick = 15;
parameters.screen_optionflags.exchange_thick = 10;
parameters.screen_optionflags.backward_thick = 5;
parameters.screen_optionflags.forward_size = 1.0;
parameters.screen_optionflags.exchange_size = 0.8;
parameters.screen_optionflags.backward_size = 0.6;

    % cross options
parameters.screen_optioncrossstation = struct();
parameters.screen_optioncrossstation.labeldy = 20;
parameters.screen_optioncrossstation.labelfontcolor = [128,128,128];
parameters.screen_optioncrossstation.labelfontsize  = 20;
parameters.screen_optioncrossstation.labelfontname  = 'Arial';
parameters.screen_optioncrossstation.labelstr = 'exchange for';
parameters.screen_optioncrossstation.boxcolorin = parameters.screen_bg_color;
parameters.screen_optioncrossstation.boxcolorout = [0,0,0];
parameters.screen_optioncrossstation.boxthick = 2;
parameters.screen_optioncrossstation.boxround = 0.3;
parameters.screen_optioncrossstation.boxdx = 135;
parameters.screen_optioncrossstation.boxdy = 120;
parameters.screen_optioncrossstation.stationstr = ' ';
parameters.screen_optioncrossstation.stationry = 0.8;
parameters.screen_optioncrossstation.stationfontcolor = [0,0,0];
parameters.screen_optioncrossstation.stationfontsize  = 32;
parameters.screen_optioncrossstation.stationfontname  = 'Arial';

parameters.screen_optionscross.labeldy = 10;
parameters.screen_optionscross.nb = 4;
parameters.screen_optionscross.sx = 60;
parameters.screen_optionscross.dx = 80;
parameters.screen_optionscross.ry = parameters.screen_optioncrossstation.stationry;
parameters.screen_optionscross.keynames = {'RightArrow','UpArrow','LeftArrow','DownArrow'};
parameters.screen_optionscross.exitkbname = 'ESCAPE';
parameters.screen_optionscross.enablekbname = 'SPACE';
parameters.screen_optionscross.fontcolor = [0,0,0];
parameters.screen_optionscross.fontbgcolor = [0,0,0,0];
parameters.screen_optionscross.fontsize  = 20;
parameters.screen_optionscross.fontname  = 'Arial';

    % line options
parameters.screen_optionlinestation = struct();
parameters.screen_optionlinestation.labeldy = 20;
parameters.screen_optionlinestation.labelfontcolor = [128,128,128];
parameters.screen_optionlinestation.labelfontsize  = 20;
parameters.screen_optionlinestation.labelfontname  = 'Arial';
parameters.screen_optionlinestation.labelstr = 'exchange for';
parameters.screen_optionlinestation.boxcolorin = parameters.screen_bg_color;
parameters.screen_optionlinestation.boxcolorout = [0,0,0];
parameters.screen_optionlinestation.boxthick = 2;
parameters.screen_optionlinestation.boxround = 1;
parameters.screen_optionlinestation.boxdx = 350;
parameters.screen_optionlinestation.boxdy = 50;
parameters.screen_optionlinestation.stationstr = ' ';
parameters.screen_optionlinestation.stationry = 0.8;
parameters.screen_optionlinestation.stationfontcolor = [0,0,0];
parameters.screen_optionlinestation.stationfontsize  = 32;
parameters.screen_optionlinestation.stationfontname  = 'Arial';

parameters.screen_optionsline.labeldy = 10;
parameters.screen_optionsline.nb = 6;
parameters.screen_optionsline.sx = 60;
parameters.screen_optionsline.dx = 30;
parameters.screen_optionsline.ry = parameters.screen_optionlinestation.stationry;
parameters.screen_optionsline.keynames = {'X','C','V','B','N','M'};
parameters.screen_optionsline.exitkbname = 'ESCAPE';
parameters.screen_optionsline.enablekbname = 'SPACE';
parameters.screen_optionsline.fontcolor = [0,0,0];
parameters.screen_optionsline.fontbgcolor = [0,0,0,0];
parameters.screen_optionsline.fontsize  = 20;
parameters.screen_optionsline.fontname  = 'Arial';

    % waiting screen
parameters.screen_wait = struct();
parameters.screen_wait.color        = [0,0,0];
parameters.screen_wait.rayon_circle = 50;
parameters.screen_wait.thick_circle = 10;
parameters.screen_wait.rayon_hand   = 25;
parameters.screen_wait.thick_hand   = 10;

    % enum list screen
parameters.screen_list = struct();
parameters.screen_list.fontsize  = 20;
parameters.screen_list.fontname  = 'Arial';
parameters.screen_list.fontbgcolor = [0,0,0,0];
parameters.screen_list.fontcolor_last = [192,192,192];
parameters.screen_list.fontcolor_next = [0,0,0];
parameters.screen_list.fontcolor_cor = [0,255,0];
parameters.screen_list.fontcolor_bad = [255,0,0];
parameters.screen_list.boxcolorin  = [255,255,255];
parameters.screen_list.boxcolorout = [0,0,0];
parameters.screen_list.boxthick = 2;
parameters.screen_list.boxround = 0.5;
parameters.screen_list.box_prx = 0.9;
parameters.screen_list.box_pry = 0.5;
parameters.screen_list.box_drx = 0.15;
parameters.screen_list.box_dry = 0.8;
parameters.screen_list.exitkbname = 'ESCAPE';
