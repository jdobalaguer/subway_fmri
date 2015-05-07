
function scan = mvpa_load(scan)
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU>
    
    %% SCANNER
    if ~exist('scan','var'), scan = parameters(); end
    
    %% SET SUBJECTS
    scan.subject.r = [6,10];
    
    %% MVPA SETTINGS
    scan.mvpa.extension  = 'img';            % GLM files
    scan.mvpa.glm        = 'smooth4'; %'realignment';
    scan.mvpa.image      = {'Trial'}; %'Cue';
    scan.mvpa.mask       = ''; %'voxs4/Cue(Easy)_RightAngularGyrus.img';
    scan.mvpa.mni        = false;
    scan.mvpa.name       = 'load';
    scan.mvpa.verbose    = true;

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_load(scan);
end
