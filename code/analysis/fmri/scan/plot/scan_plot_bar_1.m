
function scan_plot_bar_1(varargin)
    % SCAN_PLOT_BAR_1(PATH_TO_GLM)
    % SCAN_PLOT_BAR_1(SCAN,MASK,CONTRASTS)
    % Plot bars for BOLD signal (1st level)
    % (after running scan_glm_run())
    
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
        error('scan_plot_bar_1: error. wrong input');
    end
    
    %% ASSERT
    assert(isfield(scan.glm.plot,'mask'), 'scan_plot_bar_1: error. no mask specified');
        
    %% LOAD MASK
    scan.file.plot_mask = [scan.dire.mask,scan.glm.plot.mask,'.img'];
    mask = spm_vol(scan.file.plot_mask);
    mask = double(mask.private.dat);
    mask = logical(mask(:));
    
    %% VALUES
    values = nan(scan.subject.n , length(scan.glm.plot.contrast));
    for i_contrast = 1:length(scan.glm.plot.contrast)
        dire_contrast = [scan.dire.glm_secondlevel,'con_',scan.glm.plot.contrast{i_contrast},filesep()];
        file_subject = dir([dire_contrast,'spmT_sub*_con*.',scan.glm.plot.extension]);
        file_subject = strcat(dire_contrast,strvcat(file_subject.name));
        value = nan(1,size(file_subject,1));
        for i_subject = 1:size(file_subject,1)
            fil_subject = strtrim(file_subject(i_subject,:));
            nii = spm_vol(fil_subject);
            nii = double(nii.private.dat);
            nii = nii(mask);
            value(i_subject) = nanmean(nii(:));
        end
        values(:,i_contrast) = value;
    end
    
    %% PLOT
    m = meeze(values);
    e = steeze(values);
    
    %% axis
    sa = struct();
    sa.ytick   = -3:1:+3;
    sa.ylim    = ranger(sa.ytick);
        
    %% plot
    f = figure();
    fig_barweb(m,e,...
            [],...                                                  width
            {''},...                                                group names
            '',...                                                  title
            '',...                                                  xlabel
            '',...                                                  ylabel
            fig_color('w')./255,...                                 colour
            'y',...                                                 grid
            scan.glm.plot.contrast,...                              legend
            2,...                                                   error sides (1, 2)
            'axis'...                                               legend ('plot','axis')
            );
    fig_axis(sa);
    fig_figure(f);
    fig_fontname(f);
    fig_fontsize(f);
end
