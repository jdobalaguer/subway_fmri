
%% directories
p4 = '~/dmt/gitmatlab/subway_fmri/data/mask/voxs4/';
p8 = '~/dmt/gitmatlab/subway_fmri/data/mask/resample8/';
d = dir([p4,'*.img']);

%% new size
s = [20,24,17];

%% resample
% figure;
for i = 1:length(d)
    v = load_nii([p4,d(i).name]);
    v = v.img;
    w = mask_resample(v,s);
    w = double(w>0);
%     subplot(length(d),1,i);
%     hist(w(:));
    w = mask_save(w,[p8,d(i).name]);
end