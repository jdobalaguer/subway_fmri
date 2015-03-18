
function scan = mvpa_glm()
    %% WARNINGS
    %#ok<*NBRAK,*UNRCH,*NASGU>
    
    %% DATA
    block = load_block_ext('scanner');
    data  = load_data_ext( 'scanner');
    
    %% SCANNER
    scan = parameters();
    
    %% SUBJECT
%     scan.subject.r      = [];
    scan.subject.u      = 1;
    
    %% GLM
    
    % things you can change
    scan.glm.image      = 'smooth4';
    scan.glm.regressor = struct(                                ...
          'subject', { block.expt_subject                       ... subject
                       data.expt_subject                        ...
                       block.expt_subject                       ...
        },'session', { block.expt_session                       ... sesion
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
    scan.glm.redo       = 1;
    
    % things you cannot change
    scan.glm.delay      = 0;
    scan.glm.function   = 'hrf';
    scan.glm.hrf.ord    = [0,0];
    scan.glm.marge      = 0;
    scan.glm.pooling    = true;
    
    %% MVPA
    scan.mvpa.name = '';
    scan.mvpa.glm  = scan.glm.image;

    %% RUN
    scan = scan_initialize(scan);
    scan = scan_mvpa_glm(scan);
    
end
