if ~parameters.flag_enum; return; end
if ~parameters.debug_subject; return; end
if ~isempty(parameters.debug_preload)
    if isempty(enum.exp_enum)
        i_enum = 1;
    else
        i_enum = max(enum.exp_enum) + 1;
    end
    return;
end

% struct
i_enum = 1;
enum = struct();

% experiment
enum.exp_sub = [];
enum.exp_map = [];
enum.exp_block = [];
enum.exp_enum  = [];
enum.exp_trial = [];

% response
enum.resp_bool          = [];
enum.resp_gs            = [];
enum.resp_rt            = [];
enum.resp_respistation  = [];
enum.resp_respstation   = [];
enum.resp_respname      = {};
enum.resp_inistation    = [];
enum.resp_instation     = [];
enum.resp_inname        = {};
enum.resp_distin        = [];
enum.resp_cor           = [];

% avatar
enum.avatar_goalstation  = [];
enum.avatar_instation    = [];
enum.avatar_insubline    = [];
enum.avatar_inexchange   = [];

% time
enum.time_trial    = [];
