function i_w = tools_randsel(w)
    x = rand()* sum(w);
    i_w = 1;
    while x > w(i_w)
        x = x - w(i_w);
        i_w = i_w + 1;
    end
end