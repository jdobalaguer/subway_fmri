
function scan_plot_peristimulus_b(varargin)
    % SCAN_PLOT_PERISTIMULUS_B(PATH_TO_GLM)
    % SCAN_PLOT_PERISTIMULUS_B(SCAN,MASK,CONTRASTS)
    % Plot peristimulus BOLD signal (1st level betas)
    % (after running scan_glm_run() with scan.glm.function = 'fir')
    
    %% WARNINGS
    %#ok<*ERTAG,*FPARK>

    %% PARSE & LOAD
    if isstr(varargin{1}) && nargin==3,
        assert(exist([varargin{1},'/scan.mat'],'file')>0, 'scan_plot_peristimulus_b: error. no "scan.mat" file found');
        load([varargin{1},'/scan.mat']);
        scan.glm.plot.mask     = varargin{2};
        scan.glm.plot.contrast = varargin{3};
    elseif isstruct(varargin{1}) && nargin==1
        scan = varargin{1};
    else
        error('scan_plot_peristimulus_b: error. wrong input');
    end
    if ~iscell(scan.glm.plot.contrast), scan.glm.plot.contrast = {scan.glm.plot.contrast}; end
    
    for i_contrast = 1:length(scan.glm.plot.contrast)
         %% ASSERT
        assert(strcmp(scan.glm.function,'fir'),    'scan_plot_peristimulus_b: error. glm function is not "fir"');
        assert(isfield(scan.glm.plot,'mask'),      'scan_plot_peristimulus_b: error. no mask specified');
        dire_contrast = dir([scan.dire.glm_beta,'con_',scan.glm.plot.contrast{i_contrast},'*']);
        dire_contrast = strcat(scan.dire.glm_beta,strvcat(dire_contrast.name),filesep);
        scan.glm.plot.time = linspace(0,scan.glm.fir.len,scan.glm.fir.ord) - scan.glm.delay;
        assert(size(dire_contrast,1) == length(scan.glm.plot.time),'scan_plot_peristimulus_b: number of folders doesnt match order of the filter');

        %% LOAD MASK
        scan.file.plot_mask = [scan.dire.mask,scan.glm.plot.mask,'.img'];
        mask = spm_vol(scan.file.plot_mask);
        mask = double(mask.private.dat);
        mask = logical(mask(:));    

        %% VALUES
        values = nan(scan.subject.n , length(scan.glm.plot.time));
        for i_time = 1:size(dire_contrast,1)
            dire_time = strtrim(dire_contrast(i_time,:));
            file_subject = dir([dire_time,'beta_*.',scan.glm.plot.extension]);
            file_subject = strcat(dire_time,strvcat(file_subject.name));
            assert(size(file_subject,1)==scan.subject.n,'scan_plot_peristimulus_b: error. number of participants doesnt match number of files');
            value = nan(1,scan.subject.n);
            for i_subject = 1:scan.subject.n
                file_beta = strtrim(file_subject(i_subject,:));
                nii = spm_vol(file_beta);
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
        sa.ylim   = [-0.1,+0.1];
        sa.ylabel = sprintf('T statistic (con = %s)',strrep(scan.glm.plot.contrast{i_contrast},'_',' '));
        fig_axis(sa);
    end
end