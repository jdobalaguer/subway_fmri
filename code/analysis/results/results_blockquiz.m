function block_quiz = results_blockquiz(quiz)
    
    %% initialise
    nb_quiz = max(quiz.exp_quiz);
    % struct
    block_quiz = struct();
    % id
    block_quiz.exp_sub(1:nb_quiz) = nan;
    block_quiz.exp_map(1:nb_quiz) = unique(quiz.exp_map);
    block_quiz.exp_quiz           = 1:nb_quiz;
    % cor
    block_quiz.cor = nan(1,nb_quiz);
    for i_quiz = 1:nb_quiz
        ii_quiz = find(quiz.exp_quiz == i_quiz);
        block_quiz.cor(i_quiz) = nanmean(quiz.resp_cor(ii_quiz));
    end
end
