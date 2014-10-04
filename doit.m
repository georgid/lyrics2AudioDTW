function doit


% here load a file from data.m
%---------------------------

ANNOTATION_EXT = '.TextGrid'

% parameters: 

hasDeltas =	1;
withDurations = 0;
% 1-words Level
evalLevel = 0; 

% TODO: decide on: scaled or not 

% read the score 
addpath('readLyrics');
[Symbols, NoteDurations, Lyrics, Offset, OtherInfo] = readSymbTr( URI_symbTr, [], 'symbTr_v1', '', '53-TET',          false);

%%%% calc phoneme durations. manually point to starting and ending noteNums
%%%% . end is the starting of next syllable
[phonemes, phonemeDurations, wordsSequence] = calcPhonemeDurations(NoteDurations, Lyrics, startNoteNum, endNoteNum);



if withDurations
	[similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs_durations(pathToModels, URI_testFile_noExt, phonemes, phonemeDurations, hasDeltas);
	DETECTED_EXT = '.dtwDurationsAligned';
else
	[similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs(pathToModels, URI_testFile_noExt, phonemes, phonemeDurations, hasDeltas);
	DETECTED_EXT = '.dtwAligned';
end



% classic dtw, returns -loglikmatrix 
[totalDistMatrix, backPtrMatrix, costMatrix] = dtw(similarityMatrix);

% find optimal path (with min dist)
[minimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath (totalDistMatrix, backPtrMatrix);

% addpath('visualize');
% visualizePath(totalDistMatrix, URI_testFile_noExt, listPhonemesWithStates, pathXs, pathYs)

% eval. TODO file output
addpath('eval');
if (evalLevel == 0)
	[startTimeStamps, listTokens ] = parseMinPath(minimalPath, listPhonemesWithStates );
else 
	 [startTimeStamps, listTokens ]  = parseMinPath_words(minimalPath, listPhonemesWithStates, wordsSequence, withDurations  )
end

writeDetectedToFile ( startTimeStamps, listTokens,  [URI_testFile_noExt DETECTED_EXT], evalLevel );


% eval in python 
detected = [URI_testFile_noExt DETECTED_EXT];
anno = [URI_testFile_noExt ANNOTATION_EXT];

command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentStep/evaluation/WordLevelEvaluator.py ' anno ' ' detected ' ' int2str(evalLevel)]
system( command); 
