
function mask_movie(mask,dim)
    % defaults
    if ischar(mask); mask = mask_load(mask); end
    if ~exist('dim','var'); dim = 3; end
    % generate
    fig_figure();
    s = size(mask,dim);
    for i=1:s
        imagesc2();
        M(i) = getframe();
    end
    % display
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    movie(M,-20,10);
    
    function imagesc2()
        switch dim
            case 1
                imagesc(squeeze(mask(i,:,:)),[0,1]);
            case 2
                imagesc(squeeze(mask(:,i,:)),[0,1]);
            case 3
                imagesc(squeeze(mask(:,:,i)),[0,1]);
            otherwise
                error(sprintf('mask_movie: error. dim "%d" not valid'),dim);
        end
    end
end

