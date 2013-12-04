
%% keyboard release
if (    parameters.resp_kbadmin || ...
        parameters.resp_kbcross || ...
        parameters.resp_kbline          )
    
    while KbCheck(); end
end

%% mouse release
if parameters.resp_mouse
    tmp_mb = 1;
    while any(tmp_mb)
        [tmp_mx,tmp_my,tmp_mb] = GetMouse;
    end
    clear tmp_mx tmp_my tmp_mb;
end
        
%% button box release
if (parameters.resp_buttonbox) && exist('lptread','builtin')
    while lptread(  7); end
    while lptread( 71); end
    while lptread(167); end
    while lptread(231); end
end
