
assert(exist('tmp_workspace','var')>0,      'tools_setworkspace: error. no "tmp_workspace" variable');
assert(isstruct(tmp_workspace),             'tools_setworkspace: error. "tmp_workspace" is not a struct');
assert(~isfield(tmp_workspace,'tmp_field'), 'tools_setworkspace: error. forbidden field "tmp_field"');
assert(~isfield(tmp_workspace,'tmp_index'), 'tools_setworkspace: error. forbidden field "tmp_index"');

clearvars -except tmp_workspace;

tmp_field = fieldnames(tmp_workspace);
for tmp_index = 1:length(tmp_field)
    eval(sprintf('%s = tmp_workspace.%s;',tmp_field{tmp_index},tmp_field{tmp_index}));
end

clear tmp_workspace tmp_field tmp_index;
