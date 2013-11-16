
    % response
    tmp_response = struct();
    tmp_response.escape = 0;
    tmp_response.enable = 0;
    tmp_response.west   = 0;
    tmp_response.north  = 0;
    tmp_response.south  = 0;
    tmp_response.east   = 0;
    tmp_response.mx     = nan;
    tmp_response.my     = nan;
    
    [kdown,ksecs,kcode] = KbCheck();
    
    %% keyboard admin
    if parameters.resp_kbadmin
        tmp_response.escape = (tmp_response.escape || kcode(KbName('ESCAPE')));
    end
    
    %% keyboard cross
    if parameters.resp_kbcross
        tmp_response.west   = (tmp_response.west   || kcode(KbName('LeftArrow')));
        tmp_response.north  = (tmp_response.north  || kcode(KbName('UpArrow')));
        tmp_response.south  = (tmp_response.south  || kcode(KbName('DownArrow')));
        tmp_response.east   = (tmp_response.east   || kcode(KbName('RightArrow')));
        tmp_response.enable = (tmp_response.enable || kcode(KbName('SPACE')));
    end
    
    %% keyboard line
    if parameters.resp_kbline
        tmp_response.west   = (tmp_response.west   || kcode(KbName('C')));
        tmp_response.north  = (tmp_response.north  || kcode(KbName('V')));
        tmp_response.south  = (tmp_response.south  || kcode(KbName('B')));
        tmp_response.east   = (tmp_response.east   || kcode(KbName('N')));
        tmp_response.enable = (tmp_response.enable || kcode(KbName('SPACE')));
    end
    
    %% mouse
    if parameters.resp_mouse
        [tmp_mx,tmp_my,tmp_mb] = GetMouse;
        if any(tmp_mb)
            tmp_response.mx = tmp_mx;
            tmp_response.my = tmp_my;
        end
    end
    
    %% button box
    if parameters.resp_buttonbox
        tmp_response.west   = (tmp_response.west   || lptread(1));
        tmp_response.north  = (tmp_response.north  || lptread(2));
        tmp_response.south  = (tmp_response.south  || lptread(3));
        tmp_response.east   = (tmp_response.east   || lptread(4));
    end
    
    %% any response?
    tmp_response.nbkeys = 0;
    tmp_response.nbcard = 0;
    if (tmp_response.escape)
        tmp_response.nbkeys = tmp_response.nbkeys+1;
    end
    if (tmp_response.enable)
        tmp_response.nbkeys = tmp_response.nbkeys+1;
    end
    if (tmp_response.west)
        tmp_response.nbkeys = tmp_response.nbkeys+1;
        tmp_response.nbcard = tmp_response.nbcard+1;
    end
    if (tmp_response.north)
        tmp_response.nbkeys = tmp_response.nbkeys+1;
        tmp_response.nbcard = tmp_response.nbcard+1;
    end
    if (tmp_response.south)
        tmp_response.nbkeys = tmp_response.nbkeys+1;
        tmp_response.nbcard = tmp_response.nbcard+1;
    end
    if (tmp_response.east)
        tmp_response.nbkeys = tmp_response.nbkeys+1;
        tmp_response.nbcard = tmp_response.nbcard+1;
    end
    
    %% clean
    clear kdown ksecs kcode;
