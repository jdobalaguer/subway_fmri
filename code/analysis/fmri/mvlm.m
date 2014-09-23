
function scan = mvlm()
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
    scan.subject.r      = [6,10];
    
    %% GLM
    scan.glm.delay      = 0;
    scan.glm.function   = 'hrf';
    scan.glm.hrf.ord    = [0,0];
    scan.glm.image      = 'normalisation';
    scan.glm.marge      = 5;
    scan.glm.regressor = struct(                                ...
          'subject', { block.expt_subject                       ...
                       data.expt_subject                        ... subject
                       block.expt_subject                       ...
        },'session', { block.expt_session                       ... 
                       data.expt_session                        ... 
                       block.expt_session                       ... 
        },'onset',   { block.vbxi_onset_cue                     ... onset
                       data.vbxi_onset                          ... 
                       block.vbxi_onset_reward                  ... 
        },'discard', { false(size(block.vbxi_onset_cue))        ... discard
                       false(size(data.vbxi_onset))             ...
                       isnan(block.vbxi_onset_reward)           ...
        },'name',    { 'Cue','Trial','Feedback'                 ... name
        },'subname', { {},{},{}                                 ... subname
        },'level',   { {},{},{}                                 ... level
        },'duration',{ 0 });                                    ... duration
    
    %% MVPA
    scan.mvpa.name          = '';
    scan.mvpa.image         = '';
    scan.mvpa.source        = '';
    scan.mvpa.mask          = '';
    scan.mvpa.zscore        = nan;
    scan.mvpa.regressor     = struct('subject',{},'session',{},'discard',{},'name',{},'level',{});
    scan.mvpa.classifier    = struct('train_funct_name',{''},'test_funct_name',{''});

    %% RUN
    scan = scan_initialize(scan);
    scan = scan_mvpa_glm(scan);
    
end
