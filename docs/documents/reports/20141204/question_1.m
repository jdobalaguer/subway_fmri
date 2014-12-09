

%% WARNINGS
%#ok<*NUSED,*ALIGN,*INUSD,*NASGU>

%% LOAD IMAGES
if ~exist('scan','var'), scan = parameters(); end
scan.subject.r = [6,10];
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

ib.subject  = id.subject(id.first);
ib.easy     = id.easy(id.first);
ib.hard     = id.hard(id.first);
ib.same     = (jb_displace(id.easy(id.first),1,block.expt_session + 5*block.expt_subject) == id.easy(id.first));
ib.bool     = id.bool(id.first);

%% REACTION TIMES

time.all      = data.resp_reactiontime(id.subject & id.first);
time.easy     = data.resp_reactiontime(id.subject & id.first & id.easy);
time.hard     = data.resp_reactiontime(id.subject & id.first & id.hard);
beta.easy     = beta.all(ib.easy(ib.subject));
beta.hard     = beta.all(ib.hard(ib.subject));

% plot
fig_figure();
hold on;
c = fig_color('jet',4)./255;
k = 0;
for i = [0,1]
    for j = [0,1]
        k = k+1;
        subplot(2,2,k);
        x = beta.all(ib.easy(ib.subject) == i & ib.same(ib.subject) == j);
        y = time.all(ib.easy(ib.subject) == i & ib.same(ib.subject) == j);
        plot(x,y,'marker','.','linestyle','none','color',c(k,:))
        sa.xlim  = [-40,+40];
        sa.ylim  = [  0,  3];
        sa.title = sprintf('easy % d same % d',i,j);
        fig_axis(sa);
    end
end

%% CORRELATION
% correlation
leg = {'constant','easy','same','reaction time'};
X = [];
X(:,1) = ib.easy(ib.subject);
X(:,2) = ib.same(ib.subject);
X(:,3) = time.all';
y = beta.all';
[b,~,stats] = glmfit(X,y);
for i = 1:length(b)
    fprintf('%s \n',leg{i});
    fprintf('beta:    %.2f \n',b(i));
    fprintf('p-value: %.2f \n',stats.p(i));
    fprintf('\n');
end
