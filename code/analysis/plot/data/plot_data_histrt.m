
function plot_data_histrt(session)
    % load results
    allresults = load_results(session);
    
    allresults.trial_data.avatar_inexchange = (allresults.trial_data.resp_nboptions>2);

    n_outlier = 1;
    xs = 0.05;
    xx = 0:xs:n_outlier;

    u_participant = unique(allresults.trial_data.exp_sub);
    nb_participants = length(u_participant);
    
    for i_participant = 1:nb_participants
        ii_participant = (allresults.trial_data.exp_sub == u_participant(i_participant));
        ii_outlier = (allresults.trial_data.resp_rt>n_outlier);

        hin = hist(allresults.trial_data.resp_rt(allresults.trial_data.avatar_inexchange & ii_participant & ~ii_outlier),xx);
        subplot(nb_participants,2,2*i_participant-1)
        bar(xx,hin/sum(hin))
        xlim([0,n_outlier])

        hout = hist(allresults.trial_data.resp_rt(~allresults.trial_data.avatar_inexchange & ii_participant & ~ii_outlier),xx);
        subplot(nb_participants,2,2*i_participant)
        bar(xx,hout/sum(hout))
        xlim([0,n_outlier])
    end

end