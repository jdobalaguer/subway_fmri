
workspace = struct();

tmp_who = who();
for tmp_index = 1:length(tmp_who)
    if ~any(strcmp(tmp_who{tmp_index},{'tmp_who,tmp_index','workspace'}))
        eval(sprintf('workspace.(tmp_who{tmp_index}) = %s;',tmp_who{tmp_index}));
    end
end

clear tmp_who tpm_i;
