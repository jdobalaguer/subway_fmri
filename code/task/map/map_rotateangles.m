mapfile = 'allmap_';

% angles
u_angle = [90,180, 270];
nb_angles = length(u_angle);

% load
load(['files/',mapfile,'.mat']);
old_allo = allo;
clear allo map;

for i_angle = 1:nb_angles
    
    % rotate
    allo = old_allo.duplicate();
    allo.rotate(u_angle(i_angle));

    % translate
    map = allo_translate(allo);

    % save
    filename = ['files/',mapfile,'_',num2str(u_angle(i_angle)),'.mat'];
    save(filename,'map','allo');
    
end
