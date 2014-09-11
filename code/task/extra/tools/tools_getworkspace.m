
tmp_field = who();

tmp_workspace = struct();
for tmp_index = 1:length(tmp_field)
    eval(sprintf('tmp_workspace.%s = %s;',tmp_field{tmp_index},tmp_field{tmp_index}));
end

clear tmp_field tmp_index;
