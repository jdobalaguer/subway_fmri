
function scan = mvpa()
    %% WARNINGS
    %#ok<*NBRAK,*UNRCH,*NASGU>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    scan.pars.nslices   = 32;
    scan.pars.tr        = 2;
    scan.pars.ordsl     = scan.pars.nslices:-1:+1;
    scan.pars.refsl     = scan.pars.ordsl(1);
    scan.pars.reft0     = (find(scan.pars.ordsl==scan.pars.refsl)-1) * (scan.pars.tr/scan.pars.nslices);
    scan.pars.voxs      = 4;
    
    %% SUBJECT
%     scan.subject.u      = 1:5;
    scan.subject.r      = [6,10];
    
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
    
    %% MVPA
    scan.mvpa.classifier = struct('train_funct_name',{'train_bp_netlab'},'test_funct_name',{'test_bp_netlab'},'nHidden',{100});
    scan.mvpa.image     = 'Trial';
    scan.mvpa.mask      = 'xjview_temporal';
    scan.mvpa.name      = 'MVPA(xjview_temporal)';
    scan.mvpa.redo      = 1;
    scan.mvpa.regressor = struct(                               ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii_far                                  ... discard
        },'name',    { {'one','two','three','four'}             ... name
        },'level',   { {data.vbxi_subline_in == 1,              ...
                        data.vbxi_subline_in == 2,              ...
                        data.vbxi_subline_in == 3,              ...
                        data.vbxi_subline_in == 4}              ...
        });
    scan.mvpa.source    = 'beta'; ... "beta" "cont" "spmT"
    scan.mvpa.verbose   = false; % TODO
    scan.mvpa.zscore    = 0;

    %% RUN
    scan = scan_initialize(scan);
    scan = scan_mvpa_run(scan);
    
end
