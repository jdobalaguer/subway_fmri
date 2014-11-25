
function scan = preprocess()
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
    scan.subject.u      = 1;
    
    %% PREPROCESS
    i = 0;
    % despiking
    i = i+1;
    scan.preprocess(i).job  = 'none'; 'despike';
    scan.preprocess(i).from.path = 'epi3/run%d/images';
    scan.preprocess(i).from.file = '*images*.nii';
    scan.preprocess(i).move.path = 'epi3/run%d/spikes';
    scan.preprocess(i).move.file = {'g*images*.nii','ArtifactMask.nii','BadSliceLog*.txt'};

    % realignment
    i = i+1;
    scan.preprocess(i).job  = 'realignment';
    scan.preprocess(i).from.path = 'epi3/run%d/spikes';
    scan.preprocess(i).from.file = '*images*.nii';
    scan.preprocess(i).move.path = 'epi3/run%d/realign';
    scan.preprocess(i).move.file = {'u*images*.nii','*images*uw.mat','rp_*images*.txt','meanu*images*.nii'};
    
    % coregistration (structural to functional)
    i = i+1;
    scan.preprocess(i).job  = 'coregistration';
    scan.preprocess(i).from.path = 'str/images';
    scan.preprocess(i).from.file = '*images*.nii';
    scan.preprocess(i).mean.path = 'epi3/run1/realign';
    scan.preprocess(i).mean.file = 'meanu*images*.nii';
    scan.preprocess(i).move.path = 'str/coregistration';
    scan.preprocess(i).move.file = {'c*images*.nii'};
    scan.preprocess(i).run  = false;

    % normalisation 1 (coregistered structural to MNI)
    i = i+1;
    scan.preprocess(i).job  = 'normalisation_str';
    scan.preprocess(i).from.path = 'str/coregistration';
    scan.preprocess(i).from.file = '*images*.nii';
    scan.preprocess(i).move.path = 'str/normalisation';
    scan.preprocess(i).move.file = {sprintf('w%d*images*.nii',scan.pars.voxs),'*images*sn.mat'};
    scan.preprocess(i).run  = false;

    % normalisation 2 (functional to MNI)
    i = i+1;
    scan.preprocess(i).job  = 'normalisation_epi';
    scan.preprocess(i).from.path = 'epi3/run%d/realign';
    scan.preprocess(i).from.file = '*images*.nii';
    scan.preprocess(i).norm.path = 'str/normalisation';
    scan.preprocess(i).norm.file = '*images*sn.mat';
    scan.preprocess(i).move.path = 'epi3/run%d/normalisation';
    scan.preprocess(i).move.file = {sprintf('w%d*images*.nii',scan.pars.voxs)};

    % smoothing
    i = i+1;
    scan.preprocess(i).job  = 'smoothing';
    scan.preprocess(i).from.path = 'epi3/run%d/normalisation';
    scan.preprocess(i).from.file = '*images*.nii';
    scan.preprocess(i).move.path = 'epi3/run%d/smooth';
    scan.preprocess(i).move.file = {'s*images*.nii'};
    
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_preprocess_run(scan);
end
