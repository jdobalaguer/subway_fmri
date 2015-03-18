
function scan = mvpa_rsa(scan)
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU>
    
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
    ii_away  = (~ii_back & ~ii_null & data.resp_away_any);
    ii_fill  = ( ii_back |  ii_null |  ii_away);
    ii_forw  = (~ii_back & ~ii_null & ~ii_away);
    ii_easy  = (ii_forw & (data.vbxi_subline_start == data.vbxi_subline_goal));
    ii_hard  = (ii_forw & (data.vbxi_subline_start ~= data.vbxi_subline_goal));
    ii_first = (ii_hard &  data.expt_first );
    ii_then  = (ii_hard & ~data.expt_first );
    ii_far   = (ii_then & (data.optm_dist_subline_goal>1));
    ii = (~data.expt_first & data.resp_bool);
    
    %% MVPA SETTINGS
    scan.mvpa.extension  = 'img'; % glm files extension
    scan.mvpa.glm        = 'normalisation4';
    scan.mvpa.image      = 'Trial';
%     scan.mvpa.mask       = 'voxs4/S_003_miniparietal.img';
    scan.mvpa.mask       = 'searchlight4/hmap_respcode.img';
    scan.mvpa.mni        = false;
    scan.mvpa.name       = 'rsa';
    scan.mvpa.pooling    = false; % merge all session
    scan.mvpa.redo       = 2;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { {                                        ... name
                         'switch',                              ...
                         'response',                            ...
                         'random',                              ...
                       }                                        ...
                       
        },'level',   { {                                        ... level
                          data.resp_direction_switch,           ...
                          data.resp_direction_code,             ...
                          randi(2,1,length(data.expt_subject)), ...
                        } ...
        });
    scan.mvpa.runmean    = false;
    scan.mvpa.verbose    = false;                       % verbose
    
    % specific to RSA
    scan.mvpa.deeye         = 0;               % remove diagonal from the regression
    scan.mvpa.distance      = 'euclidean';     % "pearson", "spearman", "dot", "[s]euclidean", "manhattan", "cosine", "univariate"
    scan.mvpa.plot.flag     = [1,1,0];         %[rdm,shrinked,model]
    scan.mvpa.plot.average  = true;
    scan.mvpa.plot.subject  = [];
    scan.mvpa.shrink        = true;
    scan.mvpa.within        = true; % remove values between sessions
        
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_rsa(scan);
end
