function nbblocks = tools_getnumblocks(parameters,durabreak,nbtrials)
    
    durabreak = durabreak - parameters.time_breakpre;
    durabreak = durabreak - parameters.time_breakpos;
    
    durablock = 0;
    durablock = durablock + parameters.time_block;
    durablock = durablock + parameters.time_blockpre;
    durablock = durablock + parameters.time_blockpos;
    
    duratrial = parameters.time_trial;
    
    durablock = durablock + duratrial*nbtrials;
    
    nbblocks = durabreak / durablock;    
end