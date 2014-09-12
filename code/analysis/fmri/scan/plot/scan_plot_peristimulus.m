
function scan_plot_peristimulus(varargin)
    % SCAN_PLOT_PERISTIMULUS(LEVEL,SCAN)
    % SCAN_PLOT_PERISTIMULUS(LEVEL,PATH_TO_GLM,MASK,CONTRASTS)
    % Plot peristimulus BOLD signal
    % (after running scan_glm_run() with scan.glm.function = 'fir')
    % level can be 'first', 'beta', or 'second'
    
    %% WARNINGS
    %#ok<*ERTAG>
    
    %% FUNCTION
    switch varargin{1}
        case 1
            scan_plot_peristimulus_1(varargin{2:end});
        case 'first'
            scan_plot_peristimulus_1(varargin{2:end});
        case 'beta'
            scan_plot_peristimulus_b(varargin{2:end});
        case 2
            scan_plot_peristimulus_2(varargin{2:end});
        case 'second'
            scan_plot_peristimulus_2(varargin{2:end});
        otherwise
            assert(ischar(varargin{1}),'scan_plot_peristimulus: error. level is not a string')
            error('scan_plot_peristimulus: error. level "%s" not recognised',varargin{1});
    end
end
