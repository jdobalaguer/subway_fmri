
function c = tools_cellcat(varargin)
    assert(~isempty(varargin),'scan_mvpa: cellcat: error. empty varargin');
    c = varargin{1};
    for i = 2:length(varargin)
        c = {c{:},varargin{i}{:}};
    end
end
