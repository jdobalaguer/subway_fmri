
p = 'code/task/pics/places/';

d = dir(p);
d([1,2]) = [];

for i = 1:length(d)
    lowername = d(i).name;
    uppername = lowername;
    uppername(1) = upper(uppername(1));
    
    lowerpath = [p,lowername];
    tmppath   = [p,lowername,'.tmp'];
    upperpath = [p,uppername];
    
    movefile(lowerpath,tmppath);
    movefile(tmppath,upperpath);
end