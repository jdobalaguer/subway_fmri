
function values = scan_plot_peristimulus_1(varargin)
    % SCAN_PLOT_PERISTIMULUS_1(PATH_TO_GLM)
    % SCAN_PLOT_PERISTIMULUS_1(SCAN,MASK,CONTRASTS)
    % Plot peristimulus BOLD signal (1st level)
    % (after running scan_glm_run() with scan.glm.function = 'fir')
    
    %% WARNINGS
    %#ok<*ERTAG,*FPARK>

    %% PARSE & LOAD
    if isstr(varargin{1}) && nargin==3,
        assert(exist([varargin{1},'/scan.mat'],'file')>0, 'scan_plot_peristimulus_1: error. no "scan.mat" file found');
        load([varargin{1},'/scan.mat']);
        scan.glm.plot.mask     = varargin{2};
        scan.glm.plot.contrast = varargin{3};
    elseif isstruct(varargin{1}) && nargin==1
        scan = varargin{1};
    else
        error('scan_plot_peristimulus_1: error. wrong input');
    end
    if ~iscell(scan.glm.plot.contrast), scan.glm.plot.contrast = {scan.glm.plot.contrast}; end
    
    for i_contrast = 1:length(scan.glm.plot.contrast)
         %% ASSERT
        assert(strcmp(scan.glm.function,'fir'),    'scan_plot_peristimulus_1: error. glm function is not "fir"');
        assert(isfield(scan.glm.plot,'mask'),      'scan_plot_peristimulus_1: error. no mask specified');
        dire_contrast = dir([scan.dire.glm_secondlevel,'con_',scan.glm.plot.contrast{i_contrast},'*']);
        dire_contrast = strcat(scan.dire.glm_secondlevel,strvcat(dire_contrast.name),filesep);
        scan.glm.plot.time = linspace(0,scan.glm.fir.len,scan.glm.fir.ord) - scan.glm.delay;
        assert(size(dire_contrast,1) == length(scan.glm.plot.time),sprintf('scan_plot_peristimulus_1: error. n_order(%d) and n_time(%d) not consistent',size(dire_contrast,1),length(scan.glm.plot.time)));

        %% LOAD MASK
        scan.file.plot_mask = [scan.dire.mask,scan.glm.plot.mask,'.img'];
        mask = spm_vol(scan.file.plot_mask);
        mask = double(mask.private.dat);
        mask = logical(mask(:));

        %% VALUES
        values = nan(scan.subject.n , length(scan.glm.plot.time));
        for i_time = 1:size(dire_contrast,1)
            dire_time = strtrim(dire_contrast(i_time,:));
            file_subject = dir([dire_time,'spmT_sub*_con*.',scan.glm.plot.extension]);
            file_subject = strcat(dire_time,strvcat(file_subject.name));
            value = nan(1,size(file_subject,1));
            for i_subject = 1:size(file_subject,1)
                fil_subject = strtrim(file_subject(i_subject,:));
                nii = spm_vol(fil_subject);
                nii = double(nii.private.dat);
                nii = nii(mask);
                value(i_subject) = nanmean(nii(:));
            end
            values(:,i_time) = value;
        end

        %% PLOT
        fig_figure();
        hold on;
        plot(scan.glm.plot.time,zeros(size(scan.glm.plot.time)),'--k');
        % previous to zero
        ii = (scan.glm.plot.time <= 0);
        fig_steplot(scan.glm.plot.time(ii),mean(values(:,ii)),ste(values(:,ii)),fig_color('wong',   1)/255);
        fig_plot(scan.glm.plot.time(ii),mean(values(:,ii)),'Color',fig_color('wong',   1)/255);
        % after zero
        ii = (scan.glm.plot.time >= 0);
        fig_steplot(scan.glm.plot.time(ii),mean(values(:,ii)),ste(values(:,ii)),fig_color('clovers',1)/255);
        fig_plot(scan.glm.plot.time(ii),mean(values(:,ii)),'Color',fig_color('clovers',1)/255);
        % axis
        sa.title  = strrep(sprintf('peristimulus time statistics (%s)',scan.glm.plot.mask),'_',' ');
        sa.xlim   = ranger(scan.glm.plot.time) + [-1,+1];
        sa.xtick  = scan.glm.plot.time;
        sa.xticklabel = num2leg(scan.glm.plot.time);
        sa.xlabel = 'time (sec)';
%         sa.ylim   = [-1,+1];
        sa.ylabel = sprintf('T statistic (con = %s)',strrep(scan.glm.plot.contrast{i_contrast},'_',' '));
        fig_axis(sa);
    end

end
