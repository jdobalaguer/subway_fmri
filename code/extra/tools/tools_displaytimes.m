
function tools_displaytimes(time)
    
    % intialise
    dgs = 0;
    snl(1:15) = ' ';
    
    for i=2:length(time.screens)
        
        % this
        snt = time.screens{i}; snt(end+1:15) = ' ';
        gst = time.getsecs(i);
        bgt = time.breakgs(i);
        
        % previous
        snp = time.screens{i-1}; snp(end+1:15) = ' ';
        gsp = time.getsecs(i-1);
        bgp = time.breakgs(i-1);
        
        % sum
        dgs = dgs + (gst-gsp);
        
        % flags
        isblank = ~isempty(strfind(snt,'blank'));
        ispress = ~isempty(strfind(snt,'press'));
        isclick = ~isempty(strfind(snt,'click release'));
        isbreak = ~isempty(strfind(snt,'break pos'));
        
        if ~ispress
            txt_gst = sprintf('%.2f',gst-bgt); txt_gst(end+1:6)=' ';
            txt_dgs = sprintf('%.2f',dgs);     txt_dgs(end+1:5)=' ';
            fprintf('%s .. \t %s ( %s) \n',snl,txt_gst,txt_dgs);
            snl = snt;
            dgs = 0;
        end

    end
end