
function b = tools_backwardsline(f)
    b = f + bin2sign(mod(f,2));
end

function y = bin2sign(x)
    y = double(logical(x));
    y(~y) = -1;
end
