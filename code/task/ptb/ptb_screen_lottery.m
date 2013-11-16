if ~parameters.debug_subject; return; end

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

% Select rewards
rewards_win   = data.avatar_reward(logical(data.exp_stoptrial)) .* ...
                (data.resp_station(logical(data.exp_stoptrial)) == data.avatar_goalstation(logical(data.exp_stoptrial)));
rewards_total = data.avatar_reward(logical(data.exp_stoptrial));
rewards_win(isnan(rewards_win)) = [];
rewards_total(isnan(rewards_total)) = [];

if isempty(rewards_win) || isempty(rewards_total)
    fprintf('ptb_screen_lottery: warning. no rewards\n');
else
    % ratio
    ratio_coins = parameters.reward_maxbonus./sum(rewards_total);
    reward      = ratio_coins * sum(rewards_win);

    % Screen
    if reward == 1
        str_reward = sprintf('Congratulations! Your extra reward is %d pound!',reward);
    else
        str_reward = sprintf('Congratulations! Your extra reward is %.2f pounds!',reward);
    end
    DrawFormattedText(ptb.screen_w,str_reward,'center','center');

    % Flip
    Screen(ptb.screen_w,'Flip');
    ptb_resp_click;
end

% clean
clear rewards_win rewards_total str_reward;
