
%% keyboard release
if (    parameters.resp_kbadmin || ...
        parameters.resp_kbcross || ...
        parameters.resp_kbline          )
    
    while KbCheck(); end
end

%% mouse
if parameters.resp_mouse
    tmp_mb = 1;
    while any(tmp_mb)
        [tmp_mx,tmp_my,tmp_mb] = GetMouse;
    end
    clear tmp_mx tmp_my tmp_mb;
end
        
%% button box release
if (parameters.resp_buttonbox)
    
    while lptread(1); end
    while lptread(2); end
    while lptread(3); end
    while lptread(4); end
end
