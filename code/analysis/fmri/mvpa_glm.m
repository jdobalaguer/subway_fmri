
function scan = mvpa_glm()
    %% WARNINGS
    %#ok<*NBRAK,*UNRCH,*NASGU>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    scan = parameters();
    
    %% SUBJECT
%     scan.subject.r      = [6,10];
    scan.subject.u      = 1;
    
    %% GLM
    scan.glm.delay      = 0;
    scan.glm.function   = 'hrf';
    scan.glm.hrf.ord    = [0,0];
    scan.glm.image      = 'normalisation4';
    scan.glm.marge      = 5;
    scan.glm.pooling    = true;
    scan.glm.redo       = 1;
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
    scan.mvpa.classifier    = struct('train_funct_name',{''},'test_funct_name',{''});
    scan.mvpa.glm           = scan.glm.image;
    scan.mvpa.image         = ''; %Trial, Cue, Feedback
    scan.mvpa.mask          = '';
    scan.mvpa.name          = '';
    scan.mvpa.regressor     = struct('subject',{},'session',{},'discard',{},'name',{},'level',{});
    scan.mvpa.source        = ''; %beta, cont, spmt
    scan.mvpa.zscore        = nan;

    %% RUN
    scan = scan_initialize(scan);
    scan = scan_mvpa_glm(scan);
    
end
