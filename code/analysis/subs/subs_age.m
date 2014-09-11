
function age = subs_age()
    %% subjects
    u_sub = 1:22;
    n_sub = []; %[6,10,20];
    u_sub(n_sub) = [];

    %% paths
    path_training1  = 'data/data/training_1/';
    path_training2  = 'data/data/training_2/';
    path_scanner    = 'data/data/scanner/';

    %% age
    age = [];
    for i_sub = u_sub
        training_1  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
        training_2  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
        scanner     = load(sprintf('%sdata_sub_%02i.mat',path_scanner,i_sub));

        name   = (scanner.participant.name);
        age_t1 = (training_1.participant.age);
        age_t2 = (training_2.participant.age);
        age_s  = (scanner.participant.age);
        age(end+1) = unique([str2num(age_t1), str2num(age_t2), str2num(age_s)]);
    end
end
