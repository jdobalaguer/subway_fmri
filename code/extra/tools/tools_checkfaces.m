
names = map_getfaces();
    
for i = 1:length(names)
    filename = [names{i},'.jpg'];
    if ~exist(filename,'file')
        display(filename);
    end
end
