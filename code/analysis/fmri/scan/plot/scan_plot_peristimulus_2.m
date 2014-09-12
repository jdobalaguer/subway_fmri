
function scan_plot_peristimulus_2(varargin)
    % SCAN_PLOT_PERISTIMULUS2(PATH_TO_GLM)
    % SCAN_PLOT_PERISTIMULUS2(SCAN,MASK,CONTRASTS)
    % Plot peristimulus BOLD signal (2nd level)
    % (after running scan_glm_run() with scan.glm.function = 'fir')
    
    %% WARNINGS
    %#ok<*NOPRT,*FPARK,*AGROW,*NODEF,*ERTAG>
    
    %% PARSE & LOAD
    if isstr(varargin{1}) && nargin==3,
        assert(exist([varargin{1},'/scan.mat'],'file')>0, 'scan_plot_peristimulus_2: error. no "scan.mat" file found');
        load([varargin{1},'/scan.mat']);
        scan.glm.plot.mask     = varargin{2};
        scan.glm.plot.contrast = varargin{3};
    elseif isstruct(varargin{1}) && nargin==1
        scan = varargin{1};
    else
        error('scan_plot_peristimulus_2: error. wrong input');
    end
    if ~iscell(scan.glm.plot.contrast), scan.glm.plot.contrast = {scan.glm.plot.contrast}; end
    
    for i_contrast = 1:length(scan.glm.plot.contrast)
        %% ASSERT
        assert(strcmp(scan.glm.function,'fir'),    'scan_plot_peristimulus_2: error. glm function is not "fir"');
        assert(isfield(scan.glm.plot,'mask'),      'scan_plot_peristimulus_2: error. no mask specified');
        file_contrast = dir([scan.dire.glm_contrast,'con_',scan.glm.plot.contrast{i_contrast},'*.',scan.glm.plot.extension]);
        file_contrast = strcat(scan.dire.glm_contrast,strvcat(file_contrast.name));
        scan.glm.plot.time = linspace(0,scan.glm.fir.len,scan.glm.fir.ord) - scan.glm.delay;
        assert(size(file_contrast,1) == length(scan.glm.plot.time),sprintf('scan_plot_peristimulus_2: error. n_order(%d) and n_time(%d) not consistent',size(file_contrast,1),length(scan.glm.plot.time)));

        %% LOAD MASK
        scan.file.plot_mask = [scan.dire.mask,scan.glm.plot.mask,'.img'];
        mask = spm_vol(scan.file.plot_mask);
        mask = double(mask.private.dat);
        mask = logical(mask(:));

        %% VALUES
        values = nan(1,size(file_contrast,1));
        for i_time = 1:size(file_contrast,1)
            nii = spm_vol(strtrim(file_contrast(i_time,:)));
            nii = double(nii.private.dat);
            nii = nii(mask);
            values(i_time) = nanmean(nii(:));
        end

        %% PLOT
        fig_figure();
        hold on;
        plot(scan.glm.plot.time,zeros(size(scan.glm.plot.time)),'--k');
        ii = (scan.glm.plot.time <= 0); fig_plot(scan.glm.plot.time(ii),values(ii),'Color',fig_color('wong',   1)/255);
        ii = (scan.glm.plot.time >= 0); fig_plot(scan.glm.plot.time(ii),values(ii),'Color',fig_color('clovers',1)/255);
        sa.title  = strrep(sprintf('peristimulus time statistics (%s)',scan.glm.plot.mask),'_',' ');
        sa.xlim   = ranger(scan.glm.plot.time) + [-1,+1];
        sa.xtick  = scan.glm.plot.time;
        sa.xticklabel = num2leg(scan.glm.plot.time);
        sa.xlabel = 'time (sec)';
        sa.ylim   = [-10,+10];
        sa.ylabel = sprintf('T statistic (con = %s)',strrep(scan.glm.plot.contrast{i_contrast},'_',' '));
        fig_axis(sa);
    end

end
