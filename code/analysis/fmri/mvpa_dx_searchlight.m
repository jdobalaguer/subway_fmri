
function scan = mvpa_dx_searchlight(scan)
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU,*COMNL>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    if ~exist('scan','var'), scan = parameters(); end
    
    %% SET SUBJECTS
    if ~isfield(scan,'subject'), scan.subject = struct(); end
    if isfield(scan.subject,'u'), scan.subject = rmfield(scan.subject,'u'); end
    if isfield(scan.subject,'r'), scan.subject = rmfield(scan.subject,'r'); end
    scan.subject.r = [6,10];
%     scan.subject.u = 1:5;
    
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
    
    in_position_code   = 2*jb_discretize(data.vbxi_xposition_in,  2) + jb_discretize(data.vbxi_yposition_in,  2) - 2;
    goal_position_code = 2*jb_discretize(data.vbxi_xposition_goal,2) + jb_discretize(data.vbxi_yposition_goal,2) - 2;
    
    ii_regular   = (data.vbxi_regular_in);
    ii_elbow     = (data.vbxi_elbow_in);
    ii_exchange  = (data.vbxi_exchange_in);
    ii_switch    = (data.resp_direction_switch);
    
    ii = (ii_bool);
%     ii = (ii_bool & ~ii_switch);
%     ii = (ii_bool & ii_corr & ii_hard & ~ii_first & ~ii_switch);
    
    %% MVPA SETTINGS
    scan.mvpa.extension  = 'img';            % GLM files
    scan.mvpa.glm        = 'normalisation4';
    scan.mvpa.image      = 'Trial';
    scan.mvpa.mask       = ''; %'voxs4/S_003_parietal.img';
    scan.mvpa.mni        = false;
    scan.mvpa.name       = 'pilot';
    scan.mvpa.pooling    = false; % merge all session
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
                          'respswitch',                        ...
                          'respcode',                          ...
                          'subline',                            ...
                          'facein',                             ...
                          'facegoal',                           ...
                          'posin',                              ...
                          'posgoal',                            ...
                       }                                        ...
        },'level',   { {                                        ... level
                           data.resp_direction_switch,          ...
                           data.resp_direction_code,            ...
                           data.vbxi_subline_in,                ...
                           data.vbxi_face_in,                   ...
                           data.vbxi_face_goal,                 ...
                           in_position_code,                    ...
                           goal_position_code,                  ...
                        } ...
        });
    scan.mvpa.runmean    = false;                       % average out each session/condition
    scan.mvpa.verbose    = false;                       % verbose
    
    % specific to DX
    scan.mvpa.summarize                     = false;
        % support-vector-machine
    scan.mvpa.decoder.training.function     = @scan_mvpa_dx_class_svm_training;
    scan.mvpa.decoder.training.parameters   = {'kernel_function','linear','method','LS'};
    scan.mvpa.decoder.evaluate.function     = @scan_mvpa_dx_class_svm_evaluate;
    scan.mvpa.decoder.evaluate.parameters   = {};
        % average distance
    scan.mvpa.decoder.training.function     = @scan_mvpa_dx_class_dist_training;
    scan.mvpa.decoder.training.parameters   = {};
    scan.mvpa.decoder.evaluate.function     = @scan_mvpa_dx_class_dist_evaluate;
    scan.mvpa.decoder.evaluate.parameters   = {};
        % signal detection theory
    scan.mvpa.decoder.training.function     = @scan_mvpa_dx_class_sdt_training;
    scan.mvpa.decoder.training.parameters   = {'sdt'};
    scan.mvpa.decoder.evaluate.function     = @scan_mvpa_dx_class_sdt_evaluate;
    scan.mvpa.decoder.evaluate.parameters   = {};

    % specific to searchlight
    scan.mvpa.sphere    = 3;
    scan.mvpa.template  = 'normalisation4.img';

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_dx_searchlight(scan);
end
