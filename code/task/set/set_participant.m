if ~parameters.debug_subject; return; end
if ~isempty(parameters.debug_preload); return; end

participant = struct();

% info
participant.name = input('Name: ','s');
while any(participant.name == ' ')
    fprintf('Please dont use spaces.\n');
    participant.name = input('Name: ','s');
end
participant.age  = input('Age:  ','s');
participant.sex  = input('Sex:  ','s');
participant.hand = input('Hand:  ','s');

% filenames
participant.id   = 1;
participant.filename_data  = ['data',filesep,parameters.session,filesep,'data_',participant.name,'_',num2str(participant.id),'.mat'];
participant.filename_error = ['data',filesep,parameters.session,filesep,'error_',participant.name,'_',num2str(participant.id),'.mat'];

if exist(participant.filename_data,'file')
    error('set_participant: error. data file already exists');
end
if exist(participant.filename_error,'file')
    error('set_participant: error. error file already exists');
end

