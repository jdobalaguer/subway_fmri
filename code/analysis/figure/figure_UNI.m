
function figure_UNI(roi)
    %% FIGURE_UNI()
    % display average b_har across trials
    % roi = 'dlPFC';
    % roi = 'PostC';
    % roi = 'rAmyg';
    % roi = 'rAngG';
    % roi = 'rCaud';
    % roi = 'sParC2';
    % roi = 'vmPFC';
    
    %% warning
    
    %% function
    
    u_condition = {{'C'},{'L'},{'I'},{'R'}};
    n_condition = length(u_condition);
    
    % create figures
    for i_condition = 1:n_condition
        condition = u_condition{i_condition};
        f = ['.UNI/',roi,sprintf('_%s',condition{:}),'.fig'];
        if ~exist(f,'file'), launcher(roi,condition); end
    end
    
    % merge figures
    merger(roi,u_condition)
    
end

%% auxiliar launcher
function launcher(roi,condition)
    if ~exist('scan','var'), scan = parameters(); end
    scan.subject.r = [6,10];
    data  = load_data_ext ('scanner');
    ii_bool  = logical( data.resp_bool);
    ii_forw  = logical(~data.resp_away_any);
    ii_line  = (data.optm_dist_subline_goal < 3);
    ii_X     = ( data.vbxi_exchange_in);
    ii_S     = ( data.resp_direction_switch);
    ii_NX    = (~data.vbxi_exchange_in);
    ii_NS    = (~data.resp_direction_switch);
    ii_C     = ( ii_X &  ii_S);
    ii_L     = (~ii_X &  ii_S);
    ii_I     = ( ii_X & ~ii_S);
    ii_R     = (~ii_X & ~ii_S);
    if exist('condition','var')
        ii_condition = false(size(ii_bool));
        for i_condition = 1:length(condition)
            ii_condition = ii_condition | eval(['ii_',condition{i_condition}]);
        end
    end
    ii = ii_line & ii_forw & ii_bool & ii_condition;
    scan.mvpa.extension  = 'img';            % GLM files
    scan.mvpa.glm        = 'normalisation4';
    scan.mvpa.image      = {'Trial'};
    scan.mvpa.mask       = sprintf('ROI_gnone/mask/%s.img',roi);
    scan.mvpa.mni        = false;
    scan.mvpa.name       = 'pilot';
    scan.mvpa.pooling    = true;
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
                          '# stations to goal',...
                          '# lines to goal',...
                       }  ...
        },'level',   { {                                        ... level
                           data.optm_dist_station_goal,           ...
                           data.optm_dist_subline_goal,           ...
                        } ...
        });
    scan.mvpa.runmean    = false;
    scan.mvpa.verbose    = false;
    scan.mvpa.plot.dimension = 'horizontal';
    scan = scan_initialize(scan);
    scan = scan_mvpa_uni(scan);
    set(gcf(),'Visible','off');
    mkdirp('.UNI/');
    saveas(gcf(),['.UNI/',roi,sprintf('_%s',condition{:}),'.fig']);
    close(gcf());
end

%% auxiliar merger
function merger(roi,u_condition)
    n_condition = length(u_condition);
    c_condition = fig_color('hsv',n_condition);
    u_ytick = { -8 : 2 : +12 , -2:1:+3 };
    u_ylim  = { [-8,+13] , [-2,+3] };
    
    % put all figures together
    for i_axis = 1:2
        fh = fig_figure();
        fa = {};
        sh = {};
        sa = {};
        for i_condition = 1:length(u_condition)

            % load subfigure
            condition = u_condition{i_condition};
            f = ['uni/',roi,sprintf('_%s',condition{:}),'.fig'];
            sh{i_condition} = openfig(f,'invisible');
            sa{i_condition} = get(sh{i_condition},'Children');

            % create subplot
            figure(fh);

            % create subplot
            % j_subplot = ((i_axis-1) * n_condition) + i_condition;
            j_subplot = i_condition;
            fa{i_condition}(i_axis) = subplot(1,n_condition,j_subplot);

            % copy axis
            u_children = get(sa{i_condition}(i_axis),'children');
            copyobj(u_children,fa{i_condition}(i_axis));

            % set new legend
            stuff.xtick = [];
            stuff.xlim  = [0.5,1.5];
            stuff.xticklabel = {};
            stuff.ytick = u_ytick{i_axis};
            stuff.ylim  = u_ylim{i_axis};
%             stuff.yticklabel = {};
            fig_axis(stuff);
            set(fa{i_condition}(i_axis),'XColor',[1,1,1]);

            % change color
            u_children = get(fa{i_condition}(i_axis),'Children');
            u_children(1 : .5*length(u_children)) = [];
            n_children = length(u_children);
            for i_children = 1:n_children
                u_children(i_children).FaceColor = c_condition(i_condition,:);
%                 grandchildren = get(u_children(i_children),'Children');
%                 set(grandchildren,'FaceColor',c_condition(i_condition,:));
            end
            
            % close subfigure
            close(sh{i_condition});
        end
    end
    
end