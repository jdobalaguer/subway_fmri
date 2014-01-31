
i_image  = 1;
filename = sprintf('image_%03i.png',i_image);
while exist(filename,'file')
    i_image  = i_image + 1;
    filename = sprintf('image_%03i.png',i_image);
end    
imwrite(Screen('GetImage', ptb.screen_w, ptb.screen_rect), filename);
