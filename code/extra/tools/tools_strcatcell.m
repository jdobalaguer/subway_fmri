
function y = strcatcell(s,x)
    n = length(x);
    y = cell(1,n);
    for i = 1:n
        y{i} = [s,x{i}];
    end
end
        