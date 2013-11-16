
%% press key
ptb_response;
while ~tmp_response.nbkeys
    ptb_response;
end

%% release
ptb_release;

%% clean
clear tmp_response;
