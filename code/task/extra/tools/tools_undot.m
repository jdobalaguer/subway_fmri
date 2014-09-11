
function d = tools_undot(d)
    i_d=1;
    while i_d<=length(d)
        if d{i_d}(1)=='.';  d(i_d) = [];
        else                i_d = i_d+1;
        end
    end
end
