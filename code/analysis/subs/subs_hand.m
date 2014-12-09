
function hand = subs_hand()
    %% subjects
    u_sub = 1:22;

    %% paths
    path_training1  = 'data/data/training_1/';
    path_training2  = 'data/data/training_2/';
    path_scanner    = 'data/data/scanner/';

    %% age
    hand = [];
    for i_sub = u_sub
        training_1  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
        training_2  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
        scanner     = load(sprintf('%sdata_sub_%02i.mat',path_scanner,i_sub));

        name    = (scanner.participant.name);
        hand_t1 = hand2num(training_1.participant.hand);
        hand_t2 = hand2num(training_2.participant.hand);
        hand_s  = hand2num(scanner.participant.hand);
        u = unique([hand_t1, hand_t2, hand_s]);
        u(isnan(u)) = [];
        if length(u)==1
            hand(i_sub) = u;
        else
            hand(i_sub) = nan;
        end
    end
end

function n = hand2num(h)
    switch h
        case 'r'
            n = +1;
        case 'R'
            n = +1;
        case 'l'
            n = -1;
        case 'L'
            n = -1;
        otherwise
            n = nan;
    end
end
