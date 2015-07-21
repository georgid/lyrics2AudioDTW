function [ stateNetwork1, stateNetwork2] = lyrics2StatesNetwork(URI_targetFile_noExt, URI_scorePath,  SECTION_NUM, tempoCoeff1, tempoCoeff2)

%%%%%%%%%%%%% params

numFramesPerSec = 100;



% URI_targetFile_noExt =  '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma_2_zemin_from_24_931985_to_33_767787'

URI_recordingQueryToGetTempoFrom = URI_targetFile_noExt;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/lyrics2lyrics.py ' URI_scorePath ' ' num2str(SECTION_NUM) ' ' URI_recordingQueryToGetTempoFrom ' ' num2str(tempoCoeff1)]
[status, commandOut] = system( command); 
commandOut


% command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/lyrics2lyrics.py ' URI_scorePath ' ' num2str(SECTION_NUM) ' ' URI_recordingQueryToGetTempoFrom ' ' num2str(tempoCoeff2)]
% [status, commandOut] = system( command); 
% commandOut

phonemes_URI1 = [URI_scorePath   num2str(SECTION_NUM)  '.states_'  sprintf('%1.1f', tempoCoeff1)];
phonemes_URI2 = [URI_scorePath   num2str(SECTION_NUM)  '.states_'  sprintf('%1.1f', tempoCoeff2)];

addpath('..')
% parse stateNetworks
stateNetwork1 = readTextFile(phonemes_URI1);
% stateNetwork2 = readTextFile(phonemes_URI2);
stateNetwork2 = [];


end