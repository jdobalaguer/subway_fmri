
function mask_movie(mask)
    f = fig_figure();
    s = size(mask,3);
    for k = 1:36
        imagesc(mask(:,:,k),[0,1]);
        M(k) = getframe();
    end
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    movie(M,-20,10);
end