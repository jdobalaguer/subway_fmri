
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
%     scan.subject.u      = 22;
    scan.subject.r      = [6,10,18,19,22];
    
    %% MVPA
    scan.mvpa.name      = 'pilot';
    scan.mvpa.image     = 'Trial';
    scan.mvpa.source    = 'beta'; ... "beta" "cont" "spmT"
    scan.mvpa.mask      = 'S_parietal';
    scan.mvpa.sphere    = 2;
    scan.mvpa.zscore    = 1;
    scan.mvpa.regressor = struct(                               ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~data.resp_bool                          ... discard
        },'name',    { {'L1','L2','L3','L4'}                    ... name
        },'level',   { {data.vbxi_subline_in==1,                ... level
                        data.vbxi_subline_in==2,                ... 
                        data.vbxi_subline_in==3,                ... 
                        data.vbxi_subline_in==4}                ... 
        });
    scan.mvpa.classifier = struct('train_funct_name',{'jan'},'test_funct_name',{'jan'});

    %% RUN
    scan = scan_initialize(scan);
    scan = scan_mvpa_searchlight(scan);
    
end
