
function paths = scan_genpaths()
    paths = struct();
    paths.nii       = 'nii/';
    paths.loc       = 'loc/';
    paths.gre       = 'gre/';
    paths.str       = 'str/';
    paths.epi3      = 'epi3/';
    paths.epi4      = 'epi4/';
    paths.run       = 'run%d/';
    paths.images    = 'images/';
    paths.realigned = 'realigned/';
    paths.smooth    = 'smooth/';
end