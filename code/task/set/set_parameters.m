parameters = struct();

%% debug
parameters.debug_subject = 1;
parameters.debug_preload = '';

%% flags
parameters.flag_audio   = 0;            % use audio
parameters.flag_mail    = 0;            % alert with mails (for each mode)

parameters.flag_goallines = 1;          % show subline indicators under the goal label
parameters.flag_tasksel = 'rand';       % increasing difficulty over time (both for quiz and task). options: 'incr', 'home', 'rand', 'oneorone'
parameters.flag_quizsel = 'rand';       % increasing difficulty over time (both for quiz and task). options: 'incr', 'home', 'rand', 'oneorone'
parameters.flag_timechange = 1;         % waiting time when switching sublines
parameters.flag_showresp   = 0;         % show response (with timelimit)

%% session/modes
parameters.session = input('Session: ','s');         % session (defines the different modes in set_mode)
parameters.mode = {};
parameters.flag_arrowthicks = nan;      % forward is thicker
parameters.flag_arrowsizes  = nan;      % forward is bigger
parameters.flag_mapload     = nan;      % preload the map matching participant name
parameters.flag_blackandwhite = nan;    % identify sublines with different colours
parameters.flag_avatarlines = nan;      % show subline indicators under the goal label 
parameters.flag_showmap     = nan;      % show map at the beginning of each trial
parameters.flag_showpics    = nan;      % show a picture associated with the current station
parameters.flag_quiz        = nan;      % have quizes between blocks
parameters.flag_enum        = nan;      % have enumerations between blocks
parameters.flag_disabledchanges = nan;  % switching lines requires an extra action
parameters.flag_showdisabled = nan;     % show arrows even when options are disabled (in change points)
parameters.flag_stopprob    = nan;      % stochastic probability of stopping after optimal nb of steps
parameters.flag_showreward  = nan;      % use rewards for each journey
parameters.flag_timize      = nan;      % pass screen through time (not clicks)
parameters.flag_timelimit   = nan;      % limited response time
parameters.flag_break       = nan;      % breaks screens across the experiment
parameters.flag_blank       = nan;      % blank screen between trials
parameters.flag_jittering   = nan;      % jittering wait between trials
parameters.flag_scanner     = nan;      % interaction with fmri scanner

%% run
parameters.run_by_min = 0;
parameters.run_min    = nan;
parameters.run_by_blocks = 0;
parameters.run_blocks = nan;
parameters.run_by_trials = 0;
parameters.run_trials = nan;
parameters.run_by_breaks = 0;
parameters.run_breaks = nan;

%% bailout
parameters.bailout_optprop = 0.5; % proportion of bailouts with optimal algorithm

%% map
parameters.map_thick = 7;
parameters.map_fontsize = 20;

%% enum
parameters.enum_rmin    = (.05:.05:.5);
parameters.enum_rblocks = (.05:.05:.5);
parameters.enum_rtrials = (.05:.05:.5);
parameters.enum_nbsublines = 2;
parameters.enum_nbstations = 5;

%% quiz
parameters.quiz_rmin    = (.1:.1:1);
parameters.quiz_rblocks = (.1:.1:1);
parameters.quiz_rtrials = (.1:.1:1);
parameters.quiz_nbquestions = 10;

%% reward
parameters.reward_maxbonus = 20;
parameters.reward_high = 5;
parameters.reward_low  = 1;
parameters.reward_prop = 0.5;
parameters.reward_block = [];

%% screen times
parameters.time_breakpre = 10;
parameters.time_breakpos = 5;
parameters.time_block    = 3;
parameters.time_blockpre = 3.5;
parameters.time_blockprejit = 1.5;
parameters.time_map      = 10;
parameters.time_trial    = 3;
parameters.time_trialjit = 0;
parameters.time_exchange = 1;
parameters.time_blank    = 2;
parameters.time_blankjit = 1;
parameters.time_rew      = 2;
parameters.time_rewjit   = 0;
parameters.time_blockpos = 3.5;
parameters.time_blockposjit = 1.5;
parameters.time_quizstart= 2;
parameters.time_quizpre  = 2;
parameters.time_quizend  = 2;
parameters.time_quizpos  = 2;

%% response buttons
parameters.resp_kbadmin   = 1;
parameters.resp_kbcross   = 1;
parameters.resp_kbline    = 1;
parameters.resp_mouse     = 1;
parameters.resp_buttonbox = 0;
parameters.resp_default   = 'none';   % one of {'random','forward','none'}

%% screen structs
%parameters.screen_rect   = [0,0,1280,960];
%parameters.screen_rect   = [0,0,1920,1080];
parameters.screen_bg_color  = [0,0,0];%[255,255,255];

parameters.screen_fontcolor = [128,128,128];
parameters.screen_whitecolor = [0,0,0];%[255,255,255];
parameters.screen_blackcolor = [255,255,255];%[0,0,0];
parameters.screen_fontbgcolor = [255,255,255,0];%[0,0,0,0];
parameters.screen_fontsize  = 32;
parameters.screen_fontname  = 'Arial';

    % reward
parameters.screen_reward = struct();
parameters.screen_reward.labelrx  = 0.1;
parameters.screen_reward.labelry  = 0.1;
parameters.screen_reward.labelstr = 'total bonus is %d/%d so far';

    % goal station
parameters.screen_goalstation = struct();
parameters.screen_goalstation.labeldy = 20;
parameters.screen_goalstation.labelfontcolor = [128,128,128];
parameters.screen_goalstation.labelfontsize  = 32;
parameters.screen_goalstation.labelfontname  = 'Arial';
parameters.screen_goalstation.labelstr = 'meeting at';
parameters.screen_goalstation.boxcolorin = parameters.screen_bg_color;
parameters.screen_goalstation.boxcolorout = [255,255,255];%[0,0,0];
parameters.screen_goalstation.boxthick = 2;
parameters.screen_goalstation.boxround = 1;
parameters.screen_goalstation.boxdx = 30;
parameters.screen_goalstation.boxdy = 10;
parameters.screen_goalstation.stationstr = ' ';
parameters.screen_goalstation.stationry = 0.15;
parameters.screen_goalstation.stationfontcolor = [255,255,255];%[0,0,0];
parameters.screen_goalstation.stationfontsize  = 32;
parameters.screen_goalstation.stationfontname  = 'Arial';

    % bar
parameters.screen_bar_drx   = 0.666;
parameters.screen_bar_ry    = [0.25,0.75];
parameters.screen_bar_thick = 1;
parameters.screen_bar_color = [128,128,128];

    % in station
parameters.screen_instation = struct();
parameters.screen_instation.labeldy = 20;
parameters.screen_instation.labelfontcolor = [128,128,128];
parameters.screen_instation.labelfontsize  = 32;
parameters.screen_instation.labelfontname  = 'Arial';
parameters.screen_instation.labelstr = 'this is';
parameters.screen_instation.boxcolorin = parameters.screen_bg_color;
parameters.screen_instation.boxcolorout = [255,255,255];%[0,0,0];
parameters.screen_instation.boxthick = 2;
parameters.screen_instation.boxround = 1;
parameters.screen_instation.boxdx = 30;
parameters.screen_instation.boxdy = 10;
parameters.screen_instation.stationstr = ' ';
parameters.screen_instation.stationry = 0.85;
parameters.screen_instation.stationfontcolor = [255,255,255];%[0,0,0];
parameters.screen_instation.stationfontsize  = 32;
parameters.screen_instation.stationfontname  = 'Arial';

    % flag options
parameters.screen_optionflags = struct();
parameters.screen_optionflags.blackandwhite_color = [255,255,255];%[0,0,0];
parameters.screen_optionflags.forward_thick = 15;
parameters.screen_optionflags.exchange_thick = 10;
parameters.screen_optionflags.backward_thick = 5;
parameters.screen_optionflags.forward_size = 1.0;
parameters.screen_optionflags.exchange_size = 0.8;
parameters.screen_optionflags.backward_size = 0.6;

    % cross box
parameters.screen_crossstation = struct();
parameters.screen_crossstation.labeldy = 20;
parameters.screen_crossstation.labelfontcolor = [128,128,128];
parameters.screen_crossstation.labelfontsize  = 32;
parameters.screen_crossstation.labelfontname  = 'Arial';
parameters.screen_crossstation.labelstr = 'exchange for';
parameters.screen_crossstation.boxcolorin = parameters.screen_bg_color;
parameters.screen_crossstation.boxcolorout = [255,255,255];%[0,0,0];
parameters.screen_crossstation.boxthick = 10;
parameters.screen_crossstation.boxround = 0.3;
parameters.screen_crossstation.boxdx = 170;
parameters.screen_crossstation.boxdy = 150;
parameters.screen_crossstation.stationstr = ' ';
parameters.screen_crossstation.stationry = 0.5;
parameters.screen_crossstation.stationfontcolor = [255,255,255];%[0,0,0];
parameters.screen_crossstation.stationfontsize  = 32;
parameters.screen_crossstation.stationfontname  = 'Arial';
parameters.screen_crossstation.disabledcolor    = [223,223,223];%[32,32,32];
parameters.screen_crossstation.blackcolor       = [223,223,223];%[0,0,0];

    % picture
parameters.screen_picture = struct();
parameters.screen_picture.alpha = 0.3;
parameters.screen_picture.boxdx = 0.8*parameters.screen_crossstation.boxdx;
parameters.screen_picture.boxdy = 0.8*parameters.screen_crossstation.boxdy;
parameters.screen_picture.boxrx = 0.5;
parameters.screen_picture.boxry = parameters.screen_crossstation.stationry;

    % cross options
parameters.screen_cross.labeldy = 10;
parameters.screen_cross.nb = 4;
parameters.screen_cross.sx = 80;
parameters.screen_cross.dx = 120;
parameters.screen_cross.ry = parameters.screen_crossstation.stationry;
parameters.screen_cross.fontcolor = [255,255,255];%[0,0,0];
parameters.screen_cross.fontbgcolor = [255,255,255,0];%[0,0,0,0];
parameters.screen_cross.fontsize  = 32;
parameters.screen_cross.fontname  = 'Arial';

    % waiting screen
parameters.screen_wait = struct();
parameters.screen_wait.color        = [255,255,255];%[0,0,0];
parameters.screen_wait.rayon_circle = 50;
parameters.screen_wait.thick_circle = 10;
parameters.screen_wait.rayon_hand   = 25;
parameters.screen_wait.thick_hand   = 10;

    % enum list screen
parameters.screen_list = struct();
parameters.screen_list.fontsize  = 32;
parameters.screen_list.fontname  = 'Arial';
parameters.screen_list.fontbgcolor = [255,255,255];%[0,0,0,0];
parameters.screen_list.fontcolor_last = [192,192,192];
parameters.screen_list.fontcolor_next = [255,255,255];%[0,0,0];
parameters.screen_list.fontcolor_cor = [0,255,0];
parameters.screen_list.fontcolor_bad = [255,0,0];
parameters.screen_list.boxcolorin  = [0,0,0];%[255,255,255];
parameters.screen_list.boxcolorout = [255,255,255];%[0,0,0];
parameters.screen_list.boxthick = 2;
parameters.screen_list.boxround = 0.5;
parameters.screen_list.box_prx = 0.9;
parameters.screen_list.box_pry = 0.5;
parameters.screen_list.box_drx = 0.15;
parameters.screen_list.box_dry = 0.8;
