% w = weights
% t = temperature

function i_w = tools_softmax(w, t)
    w = w / t;
    e_w = exp(w);
    i_w = tools_randsel(e_w);
end
