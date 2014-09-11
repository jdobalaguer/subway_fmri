
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
name = {};
for i_sub = u_sub
    training_1  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
    training_2  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
    scanner     = load(sprintf('%sdata_sub_%02i.mat',path_scanner,i_sub));
    
    name_t1 = (training_1.participant.name);
    name_t2 = (training_2.participant.name);
    name_s  = (scanner.participant.name);
    name{end+1} = unique({name_t1, name_t2, name_s});
    
    fprintf('tmp_name : sub_%02i %s \n',i_sub,name{end}{1});
end

