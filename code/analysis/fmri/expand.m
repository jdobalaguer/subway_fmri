
function scan = expand()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan.pars.nslices = 32;
    scan.pars.tr      = 2;
    scan.pars.ordsl   = scan.pars.nslices:-1:+1;
    scan.pars.refsl   = scan.pars.ordsl(1);
    scan.pars.reft0   = (find(scan.pars.ordsl==scan.pars.refsl)-1) * (scan.pars.tr/scan.pars.nslices);
    scan.pars.voxs    = 4;
    
    %% SET SUBJECTS
    scan.subject.r      = [];
                                     
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_expand(scan);
end
