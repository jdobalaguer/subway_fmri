
function newimg = mask_resample(oldimg,newsize,interpolation)
    
    %% defaults and variables
    if ischar(oldimg)||iscell(oldimg); oldimg = mask_load(oldimg); end
    if ~exist('interpolation','var'); interpolation = 'average'; end
    oldsize = size(oldimg);
    
    %% check
    assert(length(oldsize)==3, 'scan_resamplenii: error. length(oldsize) must be 3.');
    assert(length(newsize)==3, 'scan_resamplenii: error. length(newsize) must be 3.');
    
    %% resampling variables
    res = oldsize ./ newsize;
    x = 1:res(1):oldsize(1);
    y = 1:res(2):oldsize(2);
    z = 1:res(3):oldsize(3);
    
    %% resample
    switch interpolation
        case 'average'
            newimg = resample_average();
        case 'linear'
            newimg = resample_linear();
        otherwise
            error('scan_resamplenii: error. interpolation "%s" no valid\n',interpolation);
    end
    
    %% check
    if(all(size(newimg)~=newsize))
        fprintf('scan_resamplenii: warning. size(newnii) is wrong!\n');
    end
    
    %% functions
    % averaging interpolation
    function newnii = resample_average()
        newnii = nan(length(x),length(y),length(z));
        for i_x = 1:length(x)
                    fx = floor(x(i_x));
                    cx = fx + 1;
                    nx = x(i_x) - fx;
                    px = 1 - nx;
            for i_y = 1:length(y)
                    fy = floor(y(i_y));
                    cy = fy + 1;
                    ny = y(i_y) - fy;
                    py = 1 - ny;
                for i_z = 1:length(z)
                    fz = floor(z(i_z));
                    cz = fz + 1;
                    nz = z(i_z) - fz;
                    pz = 1 - nz;

                    neighbourhood = oldimg([fx,cx],[fy,cy],[fz,cz]);
                    neighbourhood = neighbourhood(:);

                    newnii(i_x,i_y,i_z) = sum(neighbourhood)./8;
                end
            end
        end
    end
    
    % linear interpolation
    function newnii = resample_linear()
        newnii = nan(length(x),length(y),length(z));
        for i_x = 1:length(x)
                    fx = floor(x(i_x));
                    cx = fx + 1;
                    nx = x(i_x) - fx;
                    px = 1 - nx;
            for i_y = 1:length(y)
                    fy = floor(y(i_y));
                    cy = fy + 1;
                    ny = y(i_y) - fy;
                    py = 1 - ny;
                for i_z = 1:length(z)
                    fz = floor(z(i_z));
                    cz = fz + 1;
                    nz = z(i_z) - fz;
                    pz = 1 - nz;

                    neighbourhood = oldimg([fx,cx],[fy,cy],[fz,cz]);
                    neighbourhood = neighbourhood(:);

                    weighting_x   = repmat(reshape([px,nx],[2,1,1]),[1,2,2]);
                    weighting_y   = repmat(reshape([py,ny],[1,2,1]),[2,1,2]);
                    weighting_z   = repmat(reshape([pz,nz],[1,1,2]),[2,2,1]);
                    weighting     = weighting_x(:) .* weighting_y(:) .* weighting_z(:);
                    weighting     = weighting ./ sum(weighting);

                    newnii(i_x,i_y,i_z) = sum(neighbourhood .* weighting);
                end
            end
        end
    end
    
end