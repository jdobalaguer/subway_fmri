
function scan = mvpa_dx(scan)
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU,*COMNL>
    
    %% SCANNER
    if ~exist('scan','var'), scan = parameters(); end
    
    %% SET SUBJECTS
    if ~isfield(scan,'subject'), scan.subject = struct(); end
    if isfield(scan.subject,'u'), scan.subject = rmfield(scan.subject,'u'); end
    if isfield(scan.subject,'r'), scan.subject = rmfield(scan.subject,'r'); end
    scan.subject.r = [6,10];
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% INDEX
    ii_back  = logical(data.resp_direction_back_any);
    ii_null  = (~data.resp_bool);
    ii_bool  = ( data.resp_bool);
    ii_away  = (~data.resp_away_any);
    ii_corr  = logical(data.resp_correct_all);
    ii_first = ( data.expt_first );
    ii_easy  = ( data.vbxi_subline_start == data.vbxi_subline_goal);
    ii_hard  = ( data.vbxi_subline_start ~= data.vbxi_subline_goal);
    ii_first = ( data.expt_first );
    ii_far   = (data.optm_dist_subline_goal>1);
    
    ii_regular   = (data.vbxi_regular_in);
    ii_elbow     = (data.vbxi_elbow_in);
    ii_exchange  = (data.vbxi_exchange_in);
    ii_switch    = (data.resp_direction_switch);
    
    in_position_code   = 2*jb_discretize(data.vbxi_xposition_in,  2) + jb_discretize(data.vbxi_yposition_in,  2) - 2;
    goal_position_code = 2*jb_discretize(data.vbxi_xposition_goal,2) + jb_discretize(data.vbxi_yposition_goal,2) - 2;
    
    ii = (ii_bool & ii_corr & ii_hard & ~ii_first & ~ii_switch);
    ii = (ii_bool);
    
    %% MVPA SETTINGS
    scan.mvpa.extension  = 'img';                           % extension of GLM files
    scan.mvpa.glm        = 'smooth4';                       % directory of GLM files
    scan.mvpa.image      = {'Trial'};                       % subdirectory of GLM files
    scan.mvpa.mask       = 'voxs4/S_003_parietal.img';      % mask to apply
    scan.mvpa.mni        = false;                           % revert normalisation from MNI to subject space
    scan.mvpa.name       = 'dx';                            % folder name
    scan.mvpa.pooling    = false;                           % merge all session
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
                          'random',                             ...
                          'respswitch',                         ...
                       }                                        ...
        },'level',   { {                                        ... level
                           shuffle(data.resp_direction_switch), ...
                           data.resp_direction_switch,          ...
                       }                                        ...
        });
    scan.mvpa.runmean    = false;                           % average out each session/condition
    scan.mvpa.verbose    = false;                           % verbose
    
    % specific to DX
    scan.mvpa.summarize = true;                             % print summary
    scan.mvpa.decoder.training.function     = @scan_mvpa_dx_class_sdt_training;
    scan.mvpa.decoder.training.parameters   = {'sdt'};
    scan.mvpa.decoder.evaluate.function     = @scan_mvpa_dx_class_sdt_evaluate;
    scan.mvpa.decoder.evaluate.parameters   = {};

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% COPY SCRIPT
    file_script = mfilename('fullpath');
    if ~isempty(file_script)
        mkdirp(scan.dire.glm.root);
        copyfile(sprintf('%s.m',file_script),sprintf('%smvpa_glmdx.m',scan.dire.glm.root));
    end
    
    %% RUN
    scan = scan_mvpa_dx(scan);
end
