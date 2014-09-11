
function mask_3D(mask)
    fig_figure();
    if isstr(mask)||iscell(mask); mask = mask_load(mask); end
    isosurface(smooth3(mask));
    xlim([1,size(mask,2)]);
    ylim([1,size(mask,1)]);
    zlim([1,size(mask,3)]);
end