
function scan = mvpa_dx()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    scan = parameters();
    
    %% SET SUBJECTS
    scan.subject.r = [6,10];
%     scan.subject.u = 1;
    
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
    scan.mvpa.extension  = 'img';            % GLM files
    scan.mvpa.glm        = 'realignment';
    scan.mvpa.image      = 'Trial';
    scan.mvpa.mask       = 'voxs4/S_003_miniparietal.img';
    scan.mvpa.mni        = true;
    scan.mvpa.name       = 'pilot';
    scan.mvpa.pooling    = false; % merge all session
    scan.mvpa.redo       = 1;
    scan.mvpa.regressor  = struct(                              ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii                                      ... discard
        },'name',    { { 'switch','response' }                  ... name
        },'level',   { { data.resp_direction_switch, data.resp_direction_code }             ... level
        });
    
    % specific to DX
    scan.mvpa.decoder.training.function     = @scan_mvpa_dx_class_glmfit;
    scan.mvpa.decoder.training.parameters   = {'binomial','link','probit'};
    scan.mvpa.decoder.evaluate.function     = @scan_mvpa_dx_class_glmval;
    scan.mvpa.decoder.evaluate.parameters   = {'logit'};

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_dx(scan);
end
