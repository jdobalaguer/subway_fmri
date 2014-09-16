
function scan = mvpa()
    %% WARNINGS
    %#ok<*NBRAK,*UNRCH>
    
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
    scan.glm.pooling    = 1;
    scan.glm.redo       = 1;
    
    %% GLM REGRESSORS
    % todo: break regressors by event
    data  = load_data_ext( 'scanner');
    scan.glm.regressor = struct(                                ...
          'subject', { data.expt_subject                        ... subject
        },'session', { data.expt_session                        ... session
        },'onset',   { data.vbxi_onset                          ... onset
        },'discard', { []                                       ... discard
        },'name',    { {}                                       ... name
        },'subname', { {}                                       ... subname
        },'level',   { {}                                       ... level
        },'duration',{ 0 });                                    ... duration
    
    %% MVPA SETTINGS
    scan.mvpa.name      = 'first_mvpa';
    scan.mvpa.redo      = 1;
    scan.mvpa.mask      = '';
    scan.mvpa.partition = 4;
    scan.mvpa.shift     = 0;
    scan.mvpa.nn.hidden = 50;

    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan_mvpa_run(scan); 
    
end
