
function scan = preprocess()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan = parameters();
    
    %% LOAD
    runs = subs_sessions();
    once = ones(size(runs));
    
    %% SET SUBJECTS
    scan.subject.r = [];
    
    %% PREPROCESS
    i = 0;
    
    % zip EPI 4D
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = 'epi4';
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.run = once;
    scan.preprocess{i}.zip = true;
    scan.preprocess{i}.rm  = true;
    
    % zip GRE fieldmap
    i = i+1;
    scan.preprocess{i}.job  = 'none';
    scan.preprocess{i}.from.path = 'gre';
    scan.preprocess{i}.from.file = '';
    scan.preprocess{i}.run = once;
    scan.preprocess{i}.zip = true;
    scan.preprocess{i}.rm  = true;
    
    % slice timing
    % i = i+1;
    % scan.preprocess{i}.job  = 'slicetiming';
    % scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/images'];
    % scan.preprocess{i}.from.file = '*images*.nii';
    % scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/slicetime'];
    % scan.preprocess{i}.move.file = {'a*images*.nii'};
    % scan.preprocess{i}.run = runs;
    % scan.preprocess{i}.zip = true;
    % scan.preprocess{i}.rm  = true;
    
    % despiking
    i = i+1;
    scan.preprocess{i}.job  = 'despike';
    scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/images'];
    scan.preprocess{i}.from.file = '*images*.nii';
    scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/spikes'];
    scan.preprocess{i}.move.file = {'g*images*.nii','ArtifactMask.nii','BadSliceLog*.txt'};
    scan.preprocess{i}.run = runs;
    scan.preprocess{i}.zip = true;
    scan.preprocess{i}.rm  = true;

    % realignment
    i = i+1;
    scan.preprocess{i}.job  = 'realignment';
    scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/spikes'];
    scan.preprocess{i}.from.file = '*images*.nii';
    scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/realignment'];
    scan.preprocess{i}.move.file = {'u*images*.nii','*images*uw.mat','rp_*images*.txt','meanu*images*.nii'};
    scan.preprocess{i}.run = runs;
    scan.preprocess{i}.zip = true;
    scan.preprocess{i}.rm  = true;
    
    % coregistration (structural to functional)
    i = i+1;
    scan.preprocess{i}.job  = 'coregistration';
    scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/str/images'];
    scan.preprocess{i}.from.file = '*images*.nii';
    scan.preprocess{i}.mean.path = [pwd(),'/data/nii/sub_%02i/epi3/run1/realignment'];
    scan.preprocess{i}.mean.file = 'meanu*images*.nii';
    scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/str/coregistration'];
    scan.preprocess{i}.move.file = {'c*images*.nii'};
    scan.preprocess{i}.run = once;

    % normalisation 1 (coregistered structural to MNI)
    i = i+1;
    scan.preprocess{i}.job  = 'normalisation_str';
    scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/str/coregistration'];
    scan.preprocess{i}.from.file = '*images*.nii';
    scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/str/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.move.file = {'w*images*.nii','*images*sn.mat'};
    scan.preprocess{i}.run = once;

    % normalisation 2 (functional to MNI)
    i = i+1;
    scan.preprocess{i}.job  = 'normalisation_epi';
    scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/realignment'];
    scan.preprocess{i}.from.file = '*images*.nii';
    scan.preprocess{i}.norm.path = [pwd(),'/data/nii/sub_%02i/str/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.norm.file = '*images*sn.mat';
    scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.move.file = {'w*images*.nii'};
    scan.preprocess{i}.run = runs;
    
%     % inverse normalization (MNI to functional)
%     i = i+1;
%     scan.preprocess{i}.job  = 'normalisation_mni';
%     scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/smooth4'];
%     scan.preprocess{i}.from.file = '*images*.nii';
%     scan.preprocess{i}.norm.path = [pwd(),'/data/nii/sub_%02i/str/normalisation',sprintf('%d',scan.pars.voxs)];
%     scan.preprocess{i}.norm.file = '*images*sn.mat';
%     scan.preprocess{i}.orig.path = [pwd(),'/data/nii/sub_%02i/epi3/run1/realignment'];
%     scan.preprocess{i}.orig.file = '*images*.nii';
%     scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/trash'];
%     scan.preprocess{i}.move.file = {};
%     scan.preprocess{i}.run = runs;
    
    % smoothing
    i = i+1;
    scan.preprocess{i}.job  = 'smoothing';
    scan.preprocess{i}.from.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/normalisation',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.from.file = '*images*.nii';
    scan.preprocess{i}.move.path = [pwd(),'/data/nii/sub_%02i/epi3/run%d/smooth',sprintf('%d',scan.pars.voxs)];
    scan.preprocess{i}.move.file = {'s*images*.nii'};
    scan.preprocess{i}.run = runs;
    
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_preprocess_run(scan);
end
