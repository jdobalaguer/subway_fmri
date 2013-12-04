if ~parameters.debug_subject; return; end
if ~isempty(parameters.debug_preload); return; end

% struct
time = struct();
time.screens = {'nan'};
time.getsecs = nan;
time.breakgs = nan;
