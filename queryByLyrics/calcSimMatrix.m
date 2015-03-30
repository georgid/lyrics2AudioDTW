% function doit

function [similarityMatrix, listPhonemesWithStates] = calcSimMatrix(URI_targetFile_noExt, URIQueryPhonemes, URIQueryDurations)

% rootURI = '/Users/joro/Documents/Phd/UPF/arias/'
% URI_targetFile_noExt = [rootURI, 'dan-erhuang_01'];
% listPhonemesWithStates = doitJingju(URI_targetFile_noExt)
% doitJingjuSearch(URI_targetFile_noExt, listPhonemesWithStates)


% here load a file from data.m
%---------------------------
% 
% for i=1:length(list)
% URI_targetFile_noExt = list{i}


ANNOTATION_EXT = '.TextGrid'

% parameters: 

hasDeltas =	1;
withDurations = 1;
withHarmModel = 0;

addpath('matlab_htk')


% str_ = textscan(URI_targetFile_noExt, '%s', 'delimiter', '_')
% SECTION_NUM = str_{1,1}{end-1}
% command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentStep/dtw/ScoreParserDTW.py ' URI_score ' ' num2str(SECTION_NUM) ' ' num2str(withDurations)]
% system( command); 



if withHarmModel 
	URI_targetFile_noExt = [URI_targetFile_noExt,    '_harmonicModel']
end

fid = fopen(URIQueryPhonemes,'r');
phonemes = textscan(fid, '%s', 'Delimiter', '/n');
phonemes = phonemes{1,1}';
fclose(fid);

phonemeDurations = [];

if withDurations

	fid = fopen(URIQueryDurations,'r');
	phonemeDurations = textscan(fid, '%f');
	phonemeDurations = phonemeDurations{1,1}';
	fclose(fid);
end


pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';
% pathToModels = '/Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/model/hmmdefs9gmm9iter'


addpath('..');

if withDurations
	[similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs_durations(pathToModels, URI_targetFile_noExt, phonemes, phonemeDurations, hasDeltas);
	DETECTED_EXT = '.dtwDurationsAligned';
else
	[similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs(pathToModels, URI_targetFile_noExt , phonemes, phonemeDurations, hasDeltas);
	DETECTED_EXT = '.dtwAligned';
end

simMatrixFile = 'similarityMatrix.mat';
fprintf('saved similarity matrix to %s', simMatrixFile );
save(simMatrixFile, 'similarityMatrix');


end

