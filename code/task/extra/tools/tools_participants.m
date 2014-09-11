function [sex,age] = tools_participants(session)
    allresults = load_results(session);
    
    nb_pars = length(allresults.participant);
    sex = '';
    age = [];
    for i_par = 1:nb_pars
        fprintf('    %s : \n',allresults.participant{i_par}.name);
        % sex
        if isempty(allresults.participant{i_par}.sex)
            allresults.participant{i_par}.sex = input(sprintf('sex %s : ',allresults.participant{i_par}.name),'s');
        end
        sex(end+1) =         allresults.participant{i_par}.sex(1);
        % age
        if isempty(allresults.participant{i_par}.age)
            allresults.participant{i_par}.age = num2str(input(sprintf('age %s : ',allresults.participant{i_par}.name),'s'));
        end
        age(end+1) = str2num(allresults.participant{i_par}.age);
    end
end