
%% keyboard release
if (    parameters.resp_kbadmin || ...
        parameters.resp_kbcross || ...
        parameters.resp_kbline          )
    
    while KbCheck(ptb.kb_i); end
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
if (parameters.resp_buttonbox)
    while Gamepad('GetButton', ptb.gamepad_i, 1); end
    while Gamepad('GetButton', ptb.gamepad_i, 2); end
    while Gamepad('GetButton', ptb.gamepad_i, 3); end
    while Gamepad('GetButton', ptb.gamepad_i, 4); end
end
