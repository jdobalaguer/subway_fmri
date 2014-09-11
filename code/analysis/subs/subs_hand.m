
clear all;

%% subjects
u_sub = 1:22;
n_sub = [6,10,20];
u_sub(n_sub) = [];

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
    hand_t1 = (training_1.participant.hand);
    hand_t2 = (training_2.participant.hand);
    hand_s  = (scanner.participant.hand);
    hand(end+1) = unique([str2num(hand_t1), str2num(hand_t2), str2num(hand_s)]);
end

