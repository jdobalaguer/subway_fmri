if ~parameters.debug_subject; return; end

if ~exist('enum','var')
    enum_create;
end

% exp
enum.exp_sub(end+1)   = participant.id;
enum.exp_map(end+1)   = map.id;
enum.exp_block(end+1) = i_block;
enum.exp_enum(end+1)  = i_enum;
enum.exp_trial(end+1) = i_trial;

% response
enum.resp_bool(end+1)           = resp.bool;
enum.resp_gs(end+1)             = resp.gs;
enum.resp_rt(end+1)             = resp.rt;
enum.resp_respistation(end+1)   = resp.resp_istation;
enum.resp_respstation(end+1)    = resp.resp_station;
enum.resp_respname{end+1}       = resp.resp_name;
enum.resp_inistation(end+1)     = resp.in_istation;
enum.resp_instation(end+1)      = resp.in_station;
enum.resp_inname{end+1}         = resp.in_name;
enum.resp_distin(end+1)         = resp.distin;
enum.resp_cor(end+1)            = resp.cor;

% avatar
enum.avatar_goalstation(end+1)    = map.avatar.to_station;
enum.avatar_instation(end+1)      = map.avatar.in_station;
enum.avatar_insubline(end+1)      = map.avatar.in_subline;
enum.avatar_inexchange(end+1)     = (length(unique(map.links(map.avatar.in_station,:))) > 3); %0,ford,back

% time
enum.time_trial(end+1)    = ptb.screen_time_this;
