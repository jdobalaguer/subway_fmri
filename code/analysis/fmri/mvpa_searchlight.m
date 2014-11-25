
function scan = searchlight()
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
%     scan.subject.u      = 1;
    scan.subject.r      = [6,10]; %,18,19,22];
    
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
    
    %% MVPA
    scan.mvpa.classifier = struct('train_funct_name',{'train_bp_netlab'},'test_funct_name',{'test_bp_netlab'},'nHidden',{100});
    scan.mvpa.dummy_sel  = true;
    scan.mvpa.image      = 'Trial';
    scan.mvpa.mask       = 'xjview_occipital';
    scan.mvpa.name       = 'SL(xjview_occipital)';
    scan.mvpa.nvoxel     = 168;
    scan.mvpa.redo       = 1;
    scan.mvpa.regressor  = struct(                               ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~ii_then                                 ... discard
        },'name',    { {'east','north','south','west'}          ... name
        },'level',   { {data.resp_direction_east,               ... level
                        data.resp_direction_north,              ...
                        data.resp_direction_south,              ...
                        data.resp_direction_west}               ... 
        });
    scan.mvpa.source     = 'beta'; ... "beta" "cont" "spmT"
    scan.mvpa.sphere     = 3;
    scan.mvpa.verbose   = false; % TODO
    scan.mvpa.zscore     = 0;

    %% RUN
    scan = scan_initialize(scan);
    scan = scan_mvpa_searchlight(scan);
    
end
