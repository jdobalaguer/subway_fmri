
function scan = preprocess_unzip()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan = parameters();
    scan.pars.voxs = 2;
    
    %% LOAD
    runs = subs_sessions();
    once = ones(size(runs));
    
    %% PREPROCESS
    i = 0;
    
    % unzip image 2 (functional to MNI)
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = 'epi3/run%d/images';
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.run   = runs;
    scan.preprocess{i}.unzip = true;
    scan.preprocess{i}.rmzip = true;

    %% RUN
    for u = 2:22
        s = scan;
        s.subject.u = u;
        s = scan_initialize(s);
        s = scan_preprocess_run(s);
    end
end
