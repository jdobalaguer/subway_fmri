
function session = subs_sessions(subject,session)
    %% warning
    %#ok<*NASGU>
    
    %% load
    if ~exist('subject','var') && ~exist('session','var')
        data = load_data_ext('scanner');
        subject = mat2vec(data.expt_subject)';
        session = mat2vec(data.expt_session)';
    end
    
    %% get blocks
    session = jb_applyvector(@(s) max(session(subject == s)), unique(subject));
    
    
end