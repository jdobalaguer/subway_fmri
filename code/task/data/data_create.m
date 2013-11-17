if ~parameters.debug_subject; return; end
if ~isempty(parameters.debug_preload); return; end

% folder
if ~exist('data','dir')
    mkdir 'data';
end

% struct
data = struct();

% experiment
data.exp_sub = [];
data.exp_map = [];
data.exp_session = {};
data.exp_block = [];
data.exp_trial = [];
data.exp_jtrial = [];
data.exp_starttrial = [];
data.exp_stoptrial = [];

% flag
data.flag_audio         = [];
data.flag_mail          = [];

data.flag_arrowthicks   = [];
data.flag_arrowsizes    = [];
data.flag_showsublines  = [];
data.flag_tasksel       = {};
data.flag_quizsel       = {};
data.flag_timechange    = [];

data.flag_blackandwhite = [];
data.flag_showmap       = [];
data.flag_quiz          = [];
data.flag_enum          = [];
data.flag_disabledchanges = [];
data.flag_showdisabled  = [];
data.flag_stopprob      = [];
data.flag_showreward    = [];
data.flag_timelimit     = [];
data.flag_jittering     = [];
data.flag_scanner       = [];

% response
data.resp_bool    = [];
data.resp_keycode = [];
data.resp_gs      = [];
data.resp_rt      = [];
data.resp_option  = [];
data.resp_nboptions = [];
data.resp_optionssublines = nan(parameters.screen_cross.nb,0);
data.resp_optionsstations = nan(parameters.screen_cross.nb,0);
data.resp_optionsdists    = nan(parameters.screen_cross.nb,0);
data.resp_subline = [];
data.resp_station = [];
data.resp_steptime = [];
data.resp_dist    = [];
data.resp_cor     = [];
data.resp_maptime  = [];

% avatar
data.avatar_startstation = [];
data.avatar_startsubline = [];
data.avatar_goalstation  = [];
data.avatar_instation    = [];
data.avatar_insubline    = [];
data.avatar_inexchange   = [];
data.avatar_toexchange   = [];
data.avatar_time         = [];
data.avatar_reward       = [];
data.avatar_stopprob     = [];

% dists
data.dists_steptimes_stations = [];
data.dists_steptimes_sublines = [];
data.dists_exchanges_stations = [];
data.dists_exchanges_sublines = [];
data.dists_euclidean          = [];

% time
data.time_trial    = [];
