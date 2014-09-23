
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
    scan.subject.u      = 1:5;
%     scan.subject.r      = [6,10,18,19,22];
    
    %% MVPA
    scan.mvpa.name      = 'pilot';
    scan.mvpa.image     = 'Trial';
    scan.mvpa.source    = 'beta'; ... "beta" "cont" "spmT"
    scan.mvpa.mask      = 'S_parietal';
    scan.mvpa.zscore    = 0;
    scan.mvpa.regressor = struct(                               ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~data.resp_bool                          ... discard
        },'name',    { {'stay','switch'}                        ... name
        },'level',   { {data.resp_direction_switch==0,          ... level
                        data.resp_direction_switch==1}          ... 
        });
    scan.mvpa.classifier = struct('train_funct_name',{'jan'},'test_funct_name',{'jan'});

    %% RUN
    scan = scan_initialize(scan);
    scan = scan_mvpa_run(scan);
    
end
