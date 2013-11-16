if ~parameters.flag_quiz; return; end
if end_of_task; return; end

do_quiz = 1;

%% QUIZ TIME?
% minutes counter
if parameters.run_by_min
    gs = GetSecs - ptb.time_start;
    gm = gs/60;
    if i_quiz > length(parameters.quiz_min) || parameters.quiz_min(i_quiz) > gm
        do_quiz = 0;
    end
end    
% block counter
if parameters.run_by_blocks
    if i_quiz > length(parameters.quiz_blocks) || parameters.quiz_blocks(i_quiz) > i_block
        do_quiz = 0;
    end
end
% trial counter
if parameters.run_by_trials
    if i_quiz > length(parameters.quiz_trials) || parameters.quiz_trials(parameters.quiz_trials) > j_trial
        do_quiz = 0;
    end
end

if do_quiz
    %% INTRO
    % intro screen
    ptb_screen_quizintro;
    
    %% SET QUESTIONS
    % set questions
    questions = nan(parameters.quiz_nbquestions,3);
    for i_trial = 1:parameters.quiz_nbquestions
        % find a combination
        ok = 0;
        while ~ok
            % in_station (half exchange, half regular)
            if mod(i_trial,2);  tmp_instations = participant.quiz_regular;  % regular
            else                tmp_instations = participant.quiz_exchange; % exchange
            end
            % to_station
            if mod(i_trial,4)<2;  tmp_tostations = participant.quiz_regular;  % regular
            else                  tmp_tostations = participant.quiz_exchange; % exchange
            end
            % set stations
            tmp_dists = map.dists.exchanges_sublines(tmp_instations,tmp_tostations);
            [i_tmpinstations,i_tmptostations] = tools_setstations(tmp_dists,parameters,participant,ptb,i_block,j_trial,1);
            in_station = tmp_instations(i_tmpinstations);
            to_station = tmp_tostations(i_tmptostations);
            % in_subline
            tmp_sublines = unique(map.links(in_station,:));
            tmp_sublines(~tmp_sublines) = [];
            in_subline = tmp_sublines(randi(length(tmp_sublines)));
            
            % conditions
            ok = 1;
                % half exchange, half regular
            if mod(i_trial,2);  if sum(map.links(in_station,:)>0)~=2; ok = 0; end % regular
            else                if sum(map.links(in_station,:)>0)<3;  ok = 0; end % exchange
            end
                % min 2 sublines
            tmp_sublinedist = map.dists.exchanges_sublines(to_station,in_station);
            if tmp_sublinedist<2; ok=0; end
                % min 2 options
            if length(tmp_sublines)<2; ok=0; end
        end
        % set
        questions(i_trial,1) = in_station;
        questions(i_trial,2) = to_station;
        questions(i_trial,3) = in_subline;
    end
    % permute
    questions = questions(randperm(parameters.quiz_nbquestions),:);
    
    
    %% QUIZ
    % run the quiz
    for i_trial = 1:parameters.quiz_nbquestions
        end_of_trial = 0;
        
        % set map
        map.avatar.in_station = questions(i_trial,1);
        map.avatar.to_station = questions(i_trial,2);
        map.avatar.in_subline = questions(i_trial,3);
        
        % trial
        end_of_trial = 0;
        while ~end_of_trial
            % trial screen
            ptb_screen_trial;
            % get response
            ptb_resp_kbtrial;
            % wait for exchange
            ptb_screen_wait;
        end
        % limit_time screen
        ptb_screen_trial;
        
        % save quiz
        quiz_add;
        data_save;
        
        % escape
        if end_of_task; break; end
        
        % clean
        clear resp end_of_trial;
    end
    
    % end screen
    ptb_screen_quizend;
    
    % increment index
    i_quiz = i_quiz + 1;
end

% clean
clear gs gm;
clear do_quiz;
clear tmp_dists;
clear tmp_block;
clear ok questions;
clear i_station tmp_regular tmp_exchange;
clear tmp_instations tmp_tostations;
clear i_tmpinstations i_tmptostations;
clear in_station to_station in_subline;
clear tmp_sublines tmp_sublinedist;
