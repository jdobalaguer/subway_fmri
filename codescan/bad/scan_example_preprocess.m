function preprocessing_batch(subjID)
%% batch for preprocessing fMRI data in SPM8
%  input variable is a string that specifis subject ID
%  This batch utilize the SPM batch system, matlabbatch. Each step will be saved as a
%  batch file for review. go through the list and make changes to
%  parameters as you need.
%
%  preparation before start:
%  a. data should be organized as follows:
%  study\subject\run
%
%  b. rename files using rename_nii_files.
%  anatomical image is named subxxx-anta.nii
%  c. reorient images using display tool in SPM
%  origin at AC point, horizontal plane through AC-PC plane
%------------------------------------------------------------- 
%  written by Xiao-Fei Yang, 2009  ###xiaofei321##at##gmail##dot###com


%%  0.specify data directory
inputdir = ['study\',subjID];
cd(inputdir)

% list all the runs
% make sure you don't have any files named 'run*' under the same directory 
list = dir([inputdir,'\run*']);



%% 1.slice timing correction
clear matlabbatch


for i = 1:length(list)
scans_temp = [];
       
        scanslist = dir([inputdir,'\run',int2str(i),'\sub*.nii'])
        for k = 1:length(scanslist)
            scans_temp{k} = [inputdir,'/run',int2str(i),'/',scanslist(k).name,',1'];
        end
        scans{i} = scans_temp;


end

% fill in fields of structure matlabbatch
matlabbatch{1}.spm.temporal.st.scans = scans;
% number of slices
matlabbatch{1}.spm.temporal.st.nslices = 32;
% TR in seconds
matlabbatch{1}.spm.temporal.st.tr = 2;
% TE = TR - (TR/nslices)
tr = matlabbatch{1}.spm.temporal.st.tr;
nslices = matlabbatch{1}.spm.temporal.st.nslices;
matlabbatch{1}.spm.temporal.st.ta = tr - (tr/nslices);

% slice order very important. depend on EPI sequence used
% here it's interleaved
% ask JC what order you should use
matlabbatch{1}.spm.temporal.st.so = [2:2:32 1:2:32];

% reference slice
% can be any slice. here is the first
matlabbatch{1}.spm.temporal.st.refslice = 1;


% save batch file for review
savefile = ['slicetime_',subjID];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)



%% 2.realign and unwarp
clear matlabbatch

% loop the runs
for i = 1:length(list)
   
  
       
        scans = [];
       % temporal corrected files has prefix 'a'
        scanslist = dir([inputdir,'\',list(i).name,'\asub*.nii']);
        for k = 1:length(scanslist)
            scans{k} = [inputdir,'/',list(i).name,'/',scanslist(k).name,',1'];
        end
        
        matlabbatch{1}.spm.spatial.realignunwarp.data(i).scans = scans';
end

% save batch file
savefile = ['realignunwarp_a_',subjID];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)






%% 3. co-registration
%  here anatomical image is co-registered to functional image
clear matlabbatch

% specify reference file, the file you want to co-register other files to 
matlabbatch{1}.spm(1).spatial.coreg.estimate.ref = {[inputdir,'\run1\uasub',subjID,'-run1-0001.nii,1']};
% specify the file that will be transformed to match the reference
matlabbatch{1}.spm(1).spatial.coreg.estimate.source = {[inputdir,'\sub',subjID,'-anat.nii,1']};
% specify the files that you want to apply the transformation to
matlabbatch{1}.spm(1).spatial.coreg.estimate.other = {[inputdir,'\sub',subjID,'-anat.nii,1']};


% save batch file
savefile = ['coreg_',subjID];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)



%% 4. segmentation
clear matlabbatch

% from which we get sub*-anat_seg_sn_mat. it save the transformation
% the file to be segmented. need to be an anatomical image
matlabbatch{1}.spm.spatial.preproc.data = {[inputdir,'\sub',subjID,'-anat.nii,1']};


% 'mni' for caucasian brains and 'eastern' for Asian brains
matlabbatch{1}.spm.spatial.preproc.opts.regtype = 'eastern';

% save batch
savefile = ['segment_',subjID];
save(savefile,'matlabbatch')
% run batch
spm_jobman('run',matlabbatch)



%% 5. normalise
clear matlabbatch



scans = [];
% specify images that need transformation
for i = 1:length(list)
scans_temp = [];
       
        scanslist = dir([inputdir,'\run',int2str(i),'\uasub*.nii'])
        for k = 1:length(scanslist)
            scans_temp{k} = [inputdir,'/run',int2str(i),'/',scanslist(k).name,',1'];
        end
        scans = [scans scans_temp];


end
anat_image{1} = [inputdir,'\sub',subjID,'-anat.nii,1'];
scans = [scans anat_image];

% specify the transformation you want to apply
matlabbatch{1}.spm.spatial.normalise.write.subj.matname = {[inputdir,'\sub',subjID,'-anat_seg_sn.mat']};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = scans';
matlabbatch{1}.spm.spatial.normalise.write.roptions.bb = [-78  -112   -112;78    76    85];
matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = 'w';

% save batch
savefile = ['normalise_',subjID];
save(savefile,'matlabbatch')
% run batch
spm_jobman('run',matlabbatch)




%% 6. smooth

clear matlabbatch
scans = [];

for i = 1:length(list)
scans_temp = [];
       
        scanslist = dir([inputdir,'\run',int2str(i),'\wuasub*.nii'])
        for k = 1:length(scanslist)
            scans_temp{k} = [inputdir,'/run',int2str(i),'/',scanslist(k).name,',1'];
        end
        scans = [scans scans_temp];


end
matlabbatch{1}.spm.spatial.smooth.data = scans';
% specify smoothing kernel
matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];

% save batch
savefile = ['smooth_',subjID];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)


%% 99. delete intermediate files
% to save space
% for i = 1:length(list)
%     cd([inputdir,'\',list(i).name])
%     delete('sub*.nii')
%     delete('asub*.nii')
%     delete('uasub*.nii')
%     delete('wuasub*.nii')
% end
% 

