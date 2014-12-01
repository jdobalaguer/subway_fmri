
function scan = move_normalisation()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan.pars.nslices = 32;
    scan.pars.tr      = 2;
    scan.pars.ordsl   = scan.pars.nslices:-1:+1;
    scan.pars.refsl   = scan.pars.ordsl(1);
    scan.pars.reft0   = (find(scan.pars.ordsl==scan.pars.refsl)-1) * (scan.pars.tr/scan.pars.nslices);
    scan.pars.voxs    = 2;
    
    %% SET SUBJECTS
    scan.subject.r = 1;
    
    %% PREPROCESS
    i = 0;
    
    % normalisation 1
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = 'str/normalisation';
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.move.path = ['str/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.move.file = {'*'};
    scan.preprocess{i}.run = false;
    scan.preprocess{i}.rm  = true;

    % normalisation 2 (functional to MNI)
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = 'epi3/run%d/normalisation';
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.move.path = ['epi3/run%d/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.move.file = {'*'};
    scan.preprocess{i}.rm  = true;
    
    % smoothing
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = 'epi3/run%d/smooth';
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.move.path = ['epi3/run%d/smooth',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.move.file = {'*'};
    scan.preprocess{i}.rm  = true;
    
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_preprocess_run(scan);
end
