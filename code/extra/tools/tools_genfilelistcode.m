

function s = tools_genfilelistcode(p)
    
    s = {};
    d = dir(p);
    d([1,2]) = [];


    for i = 1:length(d)
        filename = d(i).name;
        s{end+1} = ['''',filename,''', ...\n'];
        fprintf(s{end});
    end
    
end
