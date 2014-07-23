
clear all;

allresults = load_results('scanner');
allresults = results_adddata(allresults);
data = allresults.trial_data;


u_par     = unique(data.exp_sub);
u_trial   = unique(data.exp_trial);
nb_pars   = length(u_par);
nb_trials = length(u_trial);

rts = zeros(nb_pars,nb_trials);

%% sort values
for i_par = 1:nb_pars
    for i_trial = 1:nb_trials

        ii_par   = (data.exp_sub   == u_par(i_par));
        ii_trial = (data.exp_trial == u_trial(i_trial));
        rt       = 1000 * data.resp_rt(ii_par & ii_trial & data.avatar_regular);

        rts(i_par,i_trial) = nanmean(rt);
    end
end

%% trim values
rts(:,14:end) = [];

%% plot
% set
m_rts = nanmean(rts);
e_rts = nanstd(rts) ./ sqrt(sum(~isnan(rts),1));

% figure
f = fig_figure();

% splines plot
fig_steplot(m_rts,e_rts);
fig_errplot(m_rts,e_rts);

% axis
sa_plot.title   = 'RT decreases with #steps';
sa_plot.xlabel  = 'step';
sa_plot.ylabel  = 'reaction time';
% sa_plot.ytick   = 800:200:1200;
% sa_plot.ylim    = [750,1250];
fig_axis(sa_plot);
