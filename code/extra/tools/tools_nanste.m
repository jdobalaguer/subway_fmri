function y = tools_nanste(x)
    
    nb_nbs = sqrt(sum(~isnan(x)));
    y = nanstd(x)./nb_nbs; 
    
end
