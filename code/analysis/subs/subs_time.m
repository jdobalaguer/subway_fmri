for i=1:22
    fprintf('\n');
    fprintf('subject %02i ------------------------\n',i);
    fprintf('\n');
    ss = load(sprintf('data/data/scanner/data_sub_%02i.mat',i));
    find(strcmp(ss.time.screens,'break wait'))
    length(ss.time.screens)
    ss.time.screens(end-5:end)'
end
