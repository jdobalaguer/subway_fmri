
function subj_condregs = scan3_mvpa_randomregressors(tmp_workspace)
    s_x = length(tmp_workspace.subj_condfields);
    s_y = length(tmp_workspace.subj_condruns);
    
    r = inf;
    while any(sum(r)>1)
        r   = zeros(s_x,s_y);
        s_1 = floor(s_y / s_x);
        for i_x = 1:s_x
            ii_y1 = (s_1*(i_x-1))+1;
            ii_y2 = s_1*(i_x);
            ii_y  = ii_y1:ii_y2;
            r(i_x,ii_y) = 1;
        end
    end
    r = shuffle(r,2);
    
    subj_condregs = r;
end
