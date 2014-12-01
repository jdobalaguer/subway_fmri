
function scan = rsa_searchlight()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD,*NASGU>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    scan = parameters();
    
    %% SET SUBJECTS
%     scan.subject.r = [6,10];
    scan.subject.u = 1;
    
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
    
    %% RSA SETTINGS
    scan.rsa.deeye      = 15;               % remove diagonal from the regression
    scan.rsa.distance   = 'pearson';      % "pearson", "spearman", "dot", "[s]euclidean", "cosine"
    scan.rsa.extension  = 'img';            % GLM files
    scan.rsa.glm        = 'realignment';
    scan.rsa.image      = 'Trial';
    scan.rsa.mask       = ''; %'xjview/occipital.img';
    scan.rsa.mni        = true;
    scan.rsa.name       = 'pilot';
    scan.rsa.plot.rdm       = true;
    scan.rsa.plot.subrdm    = true;
    scan.rsa.plot.model     = true;
    scan.rsa.plot.subject   = 1;
    scan.rsa.redo       = 1;
    scan.rsa.regressor  = struct(                               ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii_far                                  ... discard
        },'name',    { {'subline',...
                        'response',...
                        'switch',...
                       }                    ... name
        },'level',   { {data.vbxi_subline_in,...
                        data.resp_direction_code,...
                        data.resp_direction_switch,...
                        } ...
        });
    scan.rsa.shrink    = true;
    scan.rsa.sphere    = 3;
        
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_rsa_searchlight(scan);
end
