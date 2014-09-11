
function sex = subs_sex()
    %% subjects
    u_sub = 1:22;
    n_sub = []; %[6,10,20];
    u_sub(n_sub) = [];

    %% paths
    path_training1  = 'data/data/training_1/';
    path_training2  = 'data/data/training_2/';
    path_scanner    = 'data/data/scanner/';

    %% age
    sex = [];
    for i_sub = u_sub
        training_1  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
        training_2  = load(sprintf('%sdata_sub_%02i.mat',path_training2,i_sub));
        scanner     = load(sprintf('%sdata_sub_%02i.mat',path_scanner,i_sub));

        name   = (scanner.participant.name);
        sex_t1 = (training_1.participant.sex);
        sex_t2 = (training_2.participant.sex);
        sex_s  = (scanner.participant.sex);
        sex(end+1) = unique([lower(sex_t1), lower(sex_t2), lower(sex_s)]);
    end

    sex = char(sex);
