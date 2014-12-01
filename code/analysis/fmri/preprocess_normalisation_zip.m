
function scan = zip_normalisation()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan = parameters();
    scan.pars.voxs = 2;
    
    %% PREPROCESS
    i = 0;
    
    % normalisation 1
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = ['str/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.run = false;
    scan.preprocess{i}.zip = true;
    scan.preprocess{i}.rm  = true;

    % normalisation 2 (functional to MNI)
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = ['epi3/run%d/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.zip = true;
    scan.preprocess{i}.rm  = true;
    
    % smoothing
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = ['epi3/run%d/smooth',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.zip = true;
    scan.preprocess{i}.rm  = true;
    
    %% RUN
    for u = 1:22
        s = scan;
        s.subject.u = u;
        s = scan_initialize(s);
        s = scan_preprocess_run(s);
    end
end
