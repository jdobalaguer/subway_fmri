if ~parameters.flag_quiz; return; end
if ~parameters.debug_subject; return; end
if ~isempty(parameters.debug_preload)
    if isempty(quiz.exp_quiz)
        i_quiz = 1;
    else
        i_quiz = max(quiz.exp_quiz) + 1;
    end
    return;
end

% struct
i_quiz = 1;
quiz = struct();

% experiment
quiz.exp_sub = [];
quiz.exp_map = [];
quiz.exp_block = [];
quiz.exp_quiz  = [];
quiz.exp_trial = [];

% response
quiz.resp_bool    = [];
quiz.resp_keycode = [];
quiz.resp_gs      = [];
quiz.resp_rt      = [];
quiz.resp_option  = [];
quiz.resp_nboptions = [];
quiz.resp_optionssublines = nan(parameters.screen_cross.nb,0);
quiz.resp_optionsstations = nan(parameters.screen_cross.nb,0);
quiz.resp_optionsdists    = nan(parameters.screen_cross.nb,0);
quiz.resp_subline = [];
quiz.resp_station = [];
quiz.resp_steptime = [];
quiz.resp_dist    = [];
quiz.resp_cor     = [];

% avatar
quiz.avatar_goalstation  = [];
quiz.avatar_instation    = [];
quiz.avatar_insubline    = [];
quiz.avatar_inexchange   = [];
quiz.avatar_toexchange   = [];

% dists
quiz.dists_steptimes_stations = [];
quiz.dists_steptimes_sublines = [];
quiz.dists_exchanges_stations = [];
quiz.dists_exchanges_sublines = [];
quiz.dists_euclidean          = [];

% time
quiz.time_trial    = [];


%% SUBSET OF STATIONS
% find regular/exchange stations
tmp_regular = [];
tmp_exchange = [];
for i_station = 1:map.nb_stations
    if sum(map.links(i_station,:)>0)==2; tmp_regular(end+1)  = i_station; end % regular
    if sum(map.links(i_station,:)>0)>2;  tmp_exchange(end+1) = i_station; end % exchange
end
% permute
tmp_regular  = tmp_regular (randperm(length(tmp_regular)));
tmp_exchange = tmp_exchange(randperm(length(tmp_exchange)));
% resize
tmp_regular((length(tmp_exchange)+1):end) = [];
tmp_exchange((length(tmp_regular)+1):end) = [];
% store
participant.quiz_regular  = tmp_regular;
participant.quiz_exchange = tmp_exchange;

