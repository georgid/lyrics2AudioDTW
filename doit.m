function doit

path_testFile = '/Users/joro/Documents/Phd/UPF/adaptation_data_soloVoice/ISTANBUL/'
pathToModels = '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/'


% here load a file from data.m
%---------------------------
%

% parameters: 

hasDeltas =	1;
withDurations = 1;
% TODO: decide on: scaled or not 

% read the score 
addpath('readLyrics');
[Symbols, NoteDurations, Lyrics, Offset, OtherInfo] = readSymbTr( URI_symbTr, [], 'symbTr_v1', '', '53-TET',          false);

%%%% calc phoneme durations. manually point to starting and ending noteNums
%%%% . end is the starting of next syllable
[phonemes, phonemeDurations] = calcPhonemeDurations(NoteDurations, Lyrics, startNoteNum, endNoteNum);



if withDurations
	[similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs_durations(pathToModels, URI_testFile_noExt, phonemes, phonemeDurations, hasDeltas);
	outputExtension = '.dtwDurationsAligned';
else
	[similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs(pathToModels, URI_testFile_noExt, phonemes, phonemeDurations, hasDeltas);
	outputExtension = '.dtwAligned';
end



% classic dtw, returns -loglikmatrix 
[totalDistMatrix, backPtrMatrix, costMatrix] = dtw(similarityMatrix);

% find optimal path (with min dist)
[minimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath (totalDistMatrix, backPtrMatrix);

addpath('visualize');
visualizePath(totalDistMatrix, URI_testFile_noExt, listPhonemesWithStates, pathXs, pathYs)

% eval. TODO file output
addpath('eval');
parseMinPath(minimalPath, listPhonemesWithStates, [URI_testFile_noExt outputExtension] );

