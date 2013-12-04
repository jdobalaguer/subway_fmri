
%% press key
ptb_response;
while ~tmp_response.nbkeys
    ptb_response;
end

time.screens{end+1}  = 'click press';
time.getsecs(end+1) = GetSecs();
time.breakgs(end+1) = time.breakgs(end);

%% release
ptb_release;

time.screens{end+1}  = 'click release';
time.getsecs(end+1) = GetSecs();
time.breakgs(end+1) = time.breakgs(end);

%% clean
clear tmp_response;
