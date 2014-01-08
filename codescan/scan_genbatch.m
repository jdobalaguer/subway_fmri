
function batch = scan_genbatch(filenames,fext)
    if ~iscell(filenames); filenames={filenames}; end
    batch = cell(1);
    % data
    for i_filename = 1:length(filenames)
        batch{1}.spm.spatial.realignunwarp.data.scans{i_filename} = filenames{i_filename};
    end
    batch{1}.spm.spatial.realignunwarp.data.pmscan = '';
    % estimation
    batch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    batch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
    batch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    batch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    batch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    batch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    batch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    % unwrap estimation
    batch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    batch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    batch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    batch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    batch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    batch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    batch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    batch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    batch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    batch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    % unwrap reslicing
    batch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 0]; % don't do the mean image
    batch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    batch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    batch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    batch{1}.spm.spatial.realignunwarp.uwroptions.prefix = fext;
end

