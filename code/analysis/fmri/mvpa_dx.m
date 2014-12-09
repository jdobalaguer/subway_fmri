
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
%     scan.subject.u = 1;
    
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
    
    ii = (ii_bool);
    ii = (ii_bool & ~ii_switch);
%     ii = (ii_bool & ii_corr & ii_hard & ~ii_first & ~ii_switch);
    
    %% MVPA SETTINGS
    scan.mvpa.extension  = 'img';                       % extension of GLM files
    scan.mvpa.glm        = 'normalisation4';            % directory of GLM files
    scan.mvpa.glm        = 'realignment';
    scan.mvpa.image      = 'Trial';                     % subdirectory of GLM files
    scan.mvpa.mask       = 'voxs4/S_003_parietal.img';  % mask to apply
%     scan.mvpa.mask       = 'searchlight4/hmap_respcode.img';
%     scan.mvpa.mask       = 'searchlight4/hmap_respswitch.img';
%     scan.mvpa.mask       = 'searchlight4/hmap_subline.img';
    scan.mvpa.mask       = 'xjview4/hippocampus_left.img';
    scan.mvpa.mni        = true;                        % revert normalisation from MNI to subject space
    scan.mvpa.name       = 'pilot';
    scan.mvpa.pooling    = false;                       % merge all session
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
%                           'random',                             ...
%                           'respswitch',                         ...
%                           'respcode',                           ...
                          'subline',                            ...
                       }                                        ...
        },'level',   { {                                        ... level
%                            randi(2,size(data.expt_subject))  ...
%                            data.resp_direction_switch,          ...
%                            data.resp_direction_code,            ...
                           data.vbxi_subline_in,                ...
                        }                                       ...
        });
    scan.mvpa.runmean    = true;                       % average out each session/condition
    scan.mvpa.verbose    = false;                       % verbose
    
    % specific to DX
    scan.mvpa.summarize = true; % print summary
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

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_dx(scan);
end
