
function scan = expand()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan = parameters();
    
    %% SET SUBJECTS
    scan.subject.r      = [];
                                     
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_expand(scan);
end
