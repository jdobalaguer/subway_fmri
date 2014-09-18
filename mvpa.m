
function scan = mvpa()
    %% WARNINGS
    %#ok<*NBRAK,*UNRCH>
    
    %% DATA
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    scan.pars.nslices   = 32;
    scan.pars.tr        = 2;
    scan.pars.ordsl     = scan.pars.nslices:-1:+1;
    scan.pars.refsl     = scan.pars.ordsl(1);
    scan.pars.reft0     = (find(scan.pars.ordsl==scan.pars.refsl)-1) * (scan.pars.tr/scan.pars.nslices);
    scan.pars.voxs      = 4;
    
    %% SET SUBJECTS
    scan.subject.u      = [9]; 
    
    %% GLM SETTINGS
    scan.glm.delay      = 0;
    scan.glm.function   = 'hrf';
    scan.glm.hrf.ord    = [0,0];
    scan.glm.image      = 'normalisation';
    scan.glm.marge      = 5;
    scan.glm.regressor = struct(                                ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'onset',   { data.vbxi_onset                          ... onset
        },'discard', { []                                       ... discard
        },'name',    { 'Trial'                                  ... name
        },'subname', { {}                                       ... subname
        },'level',   { {}                                       ... level
        },'duration',{ 0 });                                    ... duration
    
    %% MVPA SETTINGS
    scan.mvpa.name      = 'first_mvpa';
    scan.mvpa.image     = 'Trial';
    scan.mvpa.source    = 'beta'; ... "beta" "cont" "spmT"
    scan.mvpa.mask      = 'S_parietal';
    scan.mvpa.zscore    = 0;
    scan.mvpa.regressor = struct(                               ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'discard', { ~data.resp_bool                          ... discard
        },'name',    { {'regular','exchange'}                   ... name
        },'level',   { {data.vbxi_exchange_in==0,               ... level
                        data.vbxi_exchange_in==1}               ... 
        });
%     scan.mvpa.classifier = struct( ...
%           'train_funct_name', {'train_bp_netlab'    ...
%         },'test_funct_name',  {'test_bp_netlab'     ...
%         },'nHidden',          {100,                ...
%         });
    scan.mvpa.classifier = struct( ...
          'train_funct_name', {'train_jan'  ...
        },'test_funct_name',  {'test_jan'   ...
        });

    %% FILL-IN
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_mvpa_run(scan);
    
end
