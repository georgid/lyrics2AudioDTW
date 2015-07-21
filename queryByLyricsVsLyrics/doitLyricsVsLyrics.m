function [simMatrixLyrics, stateNetwork1] = doitLyricsVsLyrics(URI_scorePath, URI_targetFile_noExt,SECTION_NUM,  tempoCoeff1, tempoCoeff2)


% URI_scorePath = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' 
% 
% SECTION_NUM = 2;
% 
% URI_targetFile_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma'
% simMatrixLyrics, stateNetwork1  = doitLyricsVsLyrics(URI_scorePath, URI_targetFile_noExt,SECTION_NUM,  tempoCoeff1, tempoCoeff2)



% SANITY CHECK lyrics models Vs same LyricsModel. Computes Dista matrix and
% we
% expect to see strong diagonal
%%%%%%%%%%%%% params

numFramesPerSec = 100;



pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';

hasDeltas = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/lyrics2lyrics.py ' URI_scorePath ' ' num2str(SECTION_NUM) ' ' URI_targetFile_noExt ' ' num2str(tempoCoeff1)]
[status, commandOut] = system( command); 
commandOut


command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/lyrics2lyrics.py ' URI_scorePath ' ' num2str(SECTION_NUM) ' ' URI_targetFile_noExt ' ' num2str(tempoCoeff2)]
[status, commandOut] = system( command); 
commandOut

phonemes_URI1 = [URI_scorePath   num2str(SECTION_NUM)  '.states_'  double2str(tempoCoeff1)];
phonemes_URI2 = [URI_scorePath   num2str(SECTION_NUM)  '.states_'  float2str(tempoCoeff2)];

addpath('..')
% parse stateNetworks
stateNetwork1 = readTextFile(phonemes_URI1);
stateNetwork2 = readTextFile(phonemes_URI2);

% parse states
simMatrixLyrics = calcSimMatrixLyrics(pathToModels,  stateNetwork1, stateNetwork2, hasDeltas);

end