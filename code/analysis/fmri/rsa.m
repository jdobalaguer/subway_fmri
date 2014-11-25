
function scan = rsa()
    %% WARNINGS
    %#ok<*NUSED,*ALIGN,*INUSD>
    
    %% SCANNER
    scan.pars.nslices = 32;
    scan.pars.tr      = 2;
    scan.pars.ordsl   = scan.pars.nslices:-1:+1;
    scan.pars.refsl   = scan.pars.ordsl(1);
    scan.pars.reft0   = (find(scan.pars.ordsl==scan.pars.refsl)-1) * (scan.pars.tr/scan.pars.nslices);
    scan.pars.voxs    = 4;
    
    %% SET SUBJECTS
    scan.subject.u      = 1:3;
%     scan.subject.r      = [6,10];
    
    %% GLM SETTINGS
    scan.glm.copy       = true(1,6);
    scan.glm.delay      = 0;
    scan.glm.function   = 'hrf';
    scan.glm.hrf.ord    = [0,0];
    scan.glm.image      = 'normalisation';
    scan.glm.marge      = 5;
    scan.glm.pooling    = true;
    scan.glm.redo       = 4; %[1-4] = do from the {regressors, first regression, copy, dont}
    
    %% GLM REGRESSORS
    data  = load_data_ext( 'scanner');
    block = load_block_ext('scanner');
    % temporary indexes
    ii_back  = logical(data.resp_direction_back_any);
    ii_null  = (~data.resp_bool);
    ii_away  = (~ii_back & ~ii_null & data.resp_away_any);
    ii_fill  = ( ii_back |  ii_null |  ii_away);
    ii_forw  = (~ii_back & ~ii_null & ~ii_away);
    ii_easy  = (ii_forw & (data.vbxi_subline_start == data.vbxi_subline_goal));
    ii_hard  = (ii_forw & (data.vbxi_subline_start ~= data.vbxi_subline_goal));
    ii_first = (ii_hard &  data.expt_first );
    ii_then  = (ii_hard & ~data.expt_first );
    ii_respE = (ii_then &  data.resp_direction_east);
    ii_respN = (ii_then &  data.resp_direction_north);
    ii_respS = (ii_then &  data.resp_direction_south);
    ii_respW = (ii_then &  data.resp_direction_west);
    % regressors
    scan.glm.regressor = struct(                        ...
        'subject', { block.expt_subject,data.expt_subject(ii_fill),data.expt_subject(ii_easy),data.expt_subject(ii_first),data.expt_subject(ii_respE),data.expt_subject(ii_respN),data.expt_subject(ii_respS),data.expt_subject(ii_respW),block.expt_subject}, ...
        'session', { block.expt_session,data.expt_session(ii_fill),data.expt_session(ii_easy),data.expt_session(ii_first),data.expt_session(ii_respE),data.expt_session(ii_respN),data.expt_session(ii_respS),data.expt_session(ii_respW),block.expt_session}, ...
        'onset',   { block.vbxi_onset_cue,data.vbxi_onset(ii_fill),data.vbxi_onset(ii_easy),data.vbxi_onset(ii_first),data.vbxi_onset(ii_respE),data.vbxi_onset(ii_respN),data.vbxi_onset(ii_respS),data.vbxi_onset(ii_respW),block.vbxi_onset_reward }, ...
        'discard', { [],[],[],[],[],[],[],[],isnan(block.vbxi_onset_reward) },  ...
        'name',    { 'Cue','Fill','Easy','First','respE','respN','respS','respW','Feed' }, ...
        'subname', { {},{},{},{},{},{},{},{},{} }, ...
        'level',   { {},{},{},{},{},{},{},{},{} }, ...
        'duration',{  0, 0, 0, 0, 0, 0, 0, 0, 0 });
                                     
    %% RSA SETTINGS
    scan.rsa.mask       = 'resp_occipital';
    scan.rsa.name       = 'pilot';
    scan.rsa.regressor  = {'respE','respN','respS','respW'};
    
    %% SANITY CHECK
    scan = scan_initialize(scan);
     
    %% RUN
    scan = scan_rsa_glm(scan);
    scan = scan_rsa_run(scan);
end
