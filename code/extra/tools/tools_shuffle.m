function y = tools_shuffle(x)
    y = x(randperm(length(x)));
end