
% using the sum of certainty values for confirmatory, disconfirmatory, and
% mixed strategies

%% prepare the behavioural data
% for each run, we need a .mat file with names, onset, duration
clear all; close all;
maindir='/Users/csummerfield/data/ruz/fMRI/images/';
behavdir='/Users/csummerfield/data/ruz/fMRI/behav/';
submat = [6:23];
modelname = 'rules11RL';
onsetsname = 'rules11RL_onsets';
runs = 1:4;

load([behavdir,'alldataRL.mat']);
fn=fieldnames(sdata);
for s=1:length(submat)
    clear block_data other_data
    
    sub=submat(s);
    cd(maindir)
    cd(['sub' num2str(sub)])
    cd('behavioural')
    
    for run=runs;
        data=[];
        indx=sdata.sub==submat(s) & sdata.sess==run;
        for f=1:length(fn);
            try
                eval(['data.',fn{f},'=sdata.',fn{f},'(:,indx);']);
            end
        end
        
        other_data{run}=data;
        
        behav_file = [behavdir,'datafMRI_s' num2str(sub) '_b',num2str(run),'.mat'];
        load(behav_file)
        block_data{run} = data;
    end
    save('block_data.mat','block_data');
    mkdir(onsetsname);
    cd(onsetsname)
    
    
    for run = runs
        % TR
        TR = 2;
        
        % conditions of interest
        clear  reg param
        %figure,subplot(311),plot(Palt),subplot(312),plot(PE),subplot(313),plot(alt)
        
        param(1).main={'stim'};
        param(1).names={'aVb','aV1b','aV2b','target','cuenovelty','target_x_aVb','target_x_aV1b','target_x_aV2b'};
        CN=logic2sign(block_data{run}.cuenovelty);
        TC=logic2sign(block_data{run}.targetchoice);
        param(1).pmod = {other_data{run}.aVb,other_data{run}.aV1b,other_data{run}.aV2b,TC,CN,TC.*other_data{run}.aVb,TC.*other_data{run}.aV1b,TC.*other_data{run}.aV2b};
        param(1).onsets =(block_data{run}.starttrialv-block_data{run}.startscanning(1))./TR;
        param(1).duration = 0;
        
        param(2).main={'feedback'};
        param(2).names={'cor'};
        param(2).pmod = {other_data{run}.feedback};
        param(2).onsets =(block_data{run}.starttrialv+3 - block_data{run}.startscanning(1,1))./TR;
        param(2).duration = 0;
        
        reg.names{1}='block';
        reg.onsets{1}=(block_data{run}.startblock(:,1)-block_data{run}.startscanning(:,1))./TR;
        reg.durations{1}=0;
        
        save(['conds_run' num2str(run) '.mat'], 'reg', 'param');
        % save(['conds_run' num2str(run) '.mat'], 'reg');
        
        
        % regressors of no interest: realignment parameters
        rpfile = ['rp_frun' num2str(run) '_001.txt'];
        R = load(fullfile(maindir,['sub' num2str(sub)],['run' num2str(run)],rpfile));
        save(['rp_run' num2str(run) '.mat'],'R')
    end
end

%% 1st level prepare the GLM
maindir='/Users/csummerfield/data/ruz/fMRI/images/';
submat = 6:23;
modelname = 'rules11RL';
onsetsname = 'rules11RL_onsets';
for s=1:length(submat)
    sub=submat(s);
    clear matlabbatch
    
    runs = 1:4;
    
    statsdir =fullfile(maindir,['sub' num2str(sub)],modelname);
    try rmdir(statsdir,'s'); end
    mkdir(statsdir)
    matlabbatch{1}.spm.stats.fmri_spec.dir = {statsdir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    
    onsetsdir = [maindir,'sub',num2str(submat(s)),filesep,'behavioural',filesep,onsetsname];
    
    for irun=1:length(runs)
        run = runs(irun);
        
        rundir = fullfile(maindir,['sub' num2str(sub)],['run' num2str(run)]); % run directory
        scans  = cellstr(spm_select('FPlist', rundir, '^sw4u.*\.nii')); % select images in the current rundir
        condfile =fullfile(onsetsdir,['conds_run' num2str(run) '.mat']); % to load multiple conditions (here seqpos x bloctype)
        rpfile = fullfile(onsetsdir,['rp_run' num2str(run) '.mat']); % use realignment parameters as nuisance
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(irun).scans = scans;
        
        clear param reg
        icon=0;
        load(condfile,'param')
        for ip=1:length(param)
            icon=icon+1;
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).name = param(ip).main{1};
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).onset = param(ip).onsets;
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).duration = param(ip).duration;
            for ic=1:length(param(ip).names)
                matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).pmod(ic).name = param(ip).names{ic};
                matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).pmod(ic).param = param(ip).pmod{ic};
                matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).pmod(ic).poly = 1;
            end
        end
        load(condfile,'reg','param')
        for ic=1:length(reg.names)
            icon=icon+1;
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).name = reg.names{ic};
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).onset = reg.onsets{ic};
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).duration = reg.durations{ic};
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(irun).cond(icon).pmod = struct('name', {}, 'param', {}, 'poly', {});
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess(irun).multi_reg = {rpfile};
        matlabbatch{1}.spm.stats.fmri_spec.sess(irun).hpf = 128;
    end
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    job_id = cfg_util('initjob', matlabbatch);
    cfg_util('run', job_id);
    cfg_util('deljob', job_id);
end


%% GLM estimate
maindir = '/Users/csummerfield/data/ruz/fMRI/images/';
submat = 6:23;
modelname = 'rules11RL';
onsetsname = 'rules11RL_onsets';
for s=1:length(submat)
    sub=submat(s);
    clear matlabbatch
    
    statsdir =fullfile(maindir,['sub' num2str(sub)],modelname);
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile(statsdir,'SPM.mat')};
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    
    job_id = cfg_util('initjob', matlabbatch);
    cfg_util('run', job_id);
    cfg_util('deljob', job_id);
end


%%
% GLM contrasts
maindir = '/Users/csummerfield/data/ruz/fMRI/images/';
submat = 6:23;
modelname = 'rules11RL';
onsetsname = 'rules11RL_onsets';
for s=1:length(submat)
    sub=submat(s);
    clear matlabbatch
    
    %%% main contrasts
    matlabbatch{1}.spm.stats.con.spmmat = {fullfile(maindir,['sub' num2str(sub)],modelname,'SPM.mat')};
    
    n=1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'stim';  % this is familiar>novel
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'aVb';   % this is  non>target
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'aVc';   % this is  non>target
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'aVd';   % this is  non>target
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'target';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'cue';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'target_x_aVb';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';    
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'target_x_aV1b';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';    
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'target_x_aV2b';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'feedback';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 0 0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'cor';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    n=n+1;
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = 'block';
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'replsc';
    
    
    
    
    for i=1:length(matlabbatch{1}.spm.stats.con.consess)
        allcontrastsname{i} = matlabbatch{1}.spm.stats.con.consess{i}.tcon.name;
    end
    save(fullfile(maindir,['sub' num2str(sub)],modelname,'allcontrasts.mat'),'allcontrastsname')
    
    %%% SPM does the contrasts
    matlabbatch{1}.spm.stats.con.delete = 1;
    job_id = cfg_util('initjob', matlabbatch);
    cfg_util('run', job_id);
    cfg_util('deljob', job_id);
end

%% copy and rename for group level analyses
maindir = '/Users/csummerfield/data/ruz/fMRI/images/';
submat = 6:23;
modelname = 'rules11RL';
onsetsname = 'rules11RL_onsets';
groupdir = fullfile(maindir, 'group', modelname);
mkdir(groupdir);
load( fullfile(maindir,['sub' num2str(submat(1))],modelname,'allcontrasts.mat'))
condindx = 1:length(allcontrastsname);
condnames = allcontrastsname;
% condindx = 1:5;
% condnames = {'Stim','seqpos','logseqpos','expseqpos','totseqpos'};
for i=1:length(condindx)
    indx = condindx(i);
    cd(groupdir)
    try rmdir(condnames{i},'s'), end
    mkdir(condnames{i})
    
    for s=1:length(submat)
        sub=submat(s);
        orifile = fullfile(maindir,['sub' num2str(sub)],modelname,sprintf('spmT_%04i',indx));
        destfile = fullfile(groupdir,condnames{indx},['tcon' condnames{indx} 'sub' num2str(sub)]);
        copyfile([orifile '.img'],[destfile '.img'])
        copyfile([orifile '.hdr'],[destfile '.hdr'])
        orifile = fullfile(maindir,['sub' num2str(sub)],modelname,sprintf('con_%04i',indx));
        destfile = fullfile(groupdir,condnames{indx},['con' condnames{indx} 'sub' num2str(sub)]);
        copyfile([orifile '.img'],[destfile '.img'])
        copyfile([orifile '.hdr'],[destfile '.hdr'])
    end
end

%% second level analyses
maindir = '/Users/csummerfield/data/ruz/fMRI/images/';
submat = 6:23;
modelname = 'rules11RL';
onsetsname = 'rules11RL_onsets';
groupdir = fullfile(maindir, 'group', modelname);
load( fullfile(maindir,['sub' num2str(submat(1))],modelname,'allcontrasts.mat'))
condindx = 1:length(allcontrastsname);
condnames = allcontrastsname;
for i=1:length(condnames)
    constr = condnames{i};
    condir = fullfile(groupdir,constr);
    cd(condir)
    disp(condir)
    try delete SPM.mat; end
    clear matlabbatch
    % design
    matlabbatch{1}.spm.stats.factorial_design.dir = {condir};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(spm_select('FPlist', condir, '^tcon.*\.img'));
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1; % threshold masking
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1; % implicit mask
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''}; % explicit mask
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1; % dont know what it is
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1; %  grand mean scaling
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1; % global normalization
    % estimate
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(condir,'SPM.mat')};
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    % contrast
    matlabbatch{3}.spm.stats.con.spmmat = {fullfile(condir,'SPM.mat')};
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = constr;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1; % contrast vector, here just 1, (simple T)
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 1;
    % run
    for ibatch=1:3
        job_id = cfg_util('initjob', matlabbatch(ibatch));
        cfg_util('run', job_id);
        cfg_util('deljob', job_id);
        cd(groupdir)
    end
end

%%
% addpath(genpath('C:\toolbox\xjviewnew'))
% xjview