

%% WARNINGS
%#ok<*NUSED,*ALIGN,*INUSD,*NASGU>

%% LOAD IMAGES
if ~exist('scan','var'), scan = parameters(); end
scan.subject.u = [1,3,4,5,6,8,9,11,13,14,15,16,18,21];
scan.mvpa.extension  = 'img';            % GLM files
scan.mvpa.glm        = 'smooth4';
scan.mvpa.image      = 'Cue';
scan.mvpa.mask       = 'voxs4/Cue(Easy)_RightAngularGyrus.img';
scan.mvpa.mni        = false;
scan.mvpa.name       = 'load';
scan = scan_initialize(scan);
scan = scan_mvpa_filename(scan);        % get beta files
scan = scan_mvpa_image(scan);           % get images
scan = scan_mvpa_getmask(scan);         % get mask
scan = scan_mvpa_mni2sub(scan);         % reverse normalization for subject
scan = scan_mvpa_applymask(scan);       % apply mask
scan = scan_mvpa_unnan(scan);           % remove nans
scan = scan_mvpa_uni_mean(scan);        % voxel mean

%% LOAD DATA
block = load_block_ext('scanner');
data  = load_data_ext( 'scanner');

%% GET VALUES
beta = cell2mat(scan.mvpa.variable.beta);
ii.subject = jb_anyof(block.expt_subject, scan.subject.u);
ii.easy = (block.vbxi_subline_goal == block.vbxi_subline_start);
ii.same = (jb_displace(ii.easy,1,[block.expt_session + 5*block.expt_subject]) == ii.easy);
x = jb_getvector(double(beta),double(block.expt_subject(ii.subject)),double(ii.easy(ii.subject)),double(ii.same(ii.subject)));

%% STATISTICS
jb_anova(x);

%% PLOT
m =  meeze(x);
e = steeze(x);
fig_figure;
fig_barweb(m,e);
