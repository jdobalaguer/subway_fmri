function quiz = fix_nbquiz(quiz)

    u_field = fieldnames(quiz);
    nb_fields = length(u_field);
    
    u_quiz = unique(quiz.exp_quiz);
    nb_quizs = length(u_quiz);
    
    nb_trials = max(hist(quiz.exp_quiz,u_quiz));
    
    exp_quiz = [];
    j_quiz = 1;
    
    for i_quiz = 1:nb_quizs
        ii_trials = (quiz.exp_quiz == u_quiz(i_quiz));
        
        % remove incomplete quizs
        if sum(ii_trials) < nb_trials
            for i_field = 1:nb_fields
                quiz.(u_field{i_field})(:,ii_trials) = [];
            end
        % change index of the complete ones
        else
            exp_quiz(end+1:end+nb_trials) = j_quiz;
            j_quiz = j_quiz + 1;
        end
    end
    
    quiz.exp_quiz = exp_quiz;
end