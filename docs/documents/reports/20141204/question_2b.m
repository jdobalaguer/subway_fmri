

%% WARNINGS
%#ok<*NUSED,*ALIGN,*INUSD,*NASGU>

%% LOAD IMAGES
if ~exist('scan','var'), scan = parameters(); end
% scan.subject.u = [1,3,4,5,6,8,9,11,13,14,15,16,18,21];
scan.subject.r = [];

scan.mvpa.extension  = 'img';            % GLM files
scan.mvpa.glm        = 'smooth4';
scan.mvpa.image      = 'Cue';
scan.mvpa.mask       = 'voxs4/Cue(Easy)_RightAngularGyrus.img';
% scan.mvpa.mask       = 'voxs4/Cue(Bool)_LeftAngularGyrus.img';
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
beta.all = cell2mat(scan.mvpa.variable.beta);

%% LOAD DATA
block = load_block_ext('scanner');
data  = load_data_ext( 'scanner');

%% INDEX
id.subject  = jb_anyof(data.expt_subject, scan.subject.u);
id.easy     = (data.vbxi_subline_goal == data.vbxi_subline_start);
id.hard     = ~id.easy;
id.first    = logical(data.expt_first);
id.bool     = logical(data.resp_bool);

ib.subject   = id.subject(id.first);
ib.easy      = id.easy(id.first);
ib.hard      = id.hard(id.first);
ib.same      = (jb_displace(ib.easy,1,block.expt_session + 5*block.expt_subject) == ib.easy);
ib.bool      = id.bool(id.first);

ib.samelines_1 = (jb_displace(block.vbxi_subline_start,1,block.expt_session + 5*block.expt_subject) == block.vbxi_subline_start) & (jb_displace(block.vbxi_subline_goal,1,block.expt_session + 5*block.expt_subject) == block.vbxi_subline_goal );
ib.samelines_2 = (jb_displace(block.vbxi_subline_start,1,block.expt_session + 5*block.expt_subject) == block.vbxi_subline_goal)  & (jb_displace(block.vbxi_subline_goal,1,block.expt_session + 5*block.expt_subject) == block.vbxi_subline_start);
ib.samelines   = ib.samelines_1 | ib.samelines_2;

%% PLOT

x = [];
for i_subject = 1:scan.subject.n
    ii_subject = (block.expt_subject == scan.subject.u(i_subject));
    
%     x(i_subject,1) = mean(beta.all(ii_subject(ib.subject) & ib.easy(ib.subject) & ib.same(ib.subject) &  ib.samelines(ib.subject)));
%     x(i_subject,2) = mean(beta.all(ii_subject(ib.subject) & ib.easy(ib.subject) & ib.same(ib.subject) & ~ib.samelines(ib.subject)));
    x(i_subject,2) = mean(beta.all(ii_subject(ib.subject) & ib.easy(ib.subject) &  ib.same(ib.subject)));
    x(i_subject,3) = mean(beta.all(ii_subject(ib.subject) & ib.easy(ib.subject) & ~ib.same(ib.subject)));
%     x(i_subject,5) = mean(beta.all(ii_subject(ib.subject) & ib.hard(ib.subject) & ib.same(ib.subject) &  ib.samelines(ib.subject)));
%     x(i_subject,6) = mean(beta.all(ii_subject(ib.subject) & ib.hard(ib.subject) & ib.same(ib.subject) & ~ib.samelines(ib.subject)));
    x(i_subject,6) = mean(beta.all(ii_subject(ib.subject) & ib.hard(ib.subject) &  ib.same(ib.subject)));
    x(i_subject,7) = mean(beta.all(ii_subject(ib.subject) & ib.hard(ib.subject) & ~ib.same(ib.subject)));
end

m = meeze(x);
e = steeze(x);

fig_figure();
fig_barweb(m,e);



