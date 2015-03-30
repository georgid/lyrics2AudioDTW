% function doit


% here load a file from data.m
%---------------------------
% 
% for i=1:length(list)
% URI_testFile_noExt = list{i}

pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';

ANNOTATION_EXT = '.TextGrid'

% parameters: 

hasDeltas =	1;
withDurations = 0;
addpath('matlab_htk')

% not scaled only
% 
% % read the score 
% addpath('readLyrics');
% [Symbols, NoteDurations, Lyrics, Offset, OtherInfo] = readSymbTr( URI_symbTr, [], 'symbTr_v1', '', '53-TET',          false);
% 
% %%%% calc phoneme durations. manually point to starting and ending noteNums
% %%%% . end is the starting of next syllable
% [phonemes, phonemeDurations, wordsSequence] = calcPhonemeDurations(NoteDurations, Lyrics, startNoteNum, endNoteNum);
% %
% % PYTHON: phonemes = makamScore.serializeLyricsForSection(5, '/tmp/test.phn')
% % TODO: get syllables.durations in python
% %  phonemeDurations from calcPhonemeDurations.syllable2phonemeDurations(phonemes, syllables.durations, )
% 


str_ = textscan(URI_testFile_noExt, '%s', 'delimiter', '_')
SECTION_NUM = str_{1,1}{end-1}
command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentStep/dtw/ScoreParserDTW.py ' URI_score ' ' num2str(SECTION_NUM) ' ' num2str(withDurations)]
system( command); 



fid = fopen('/tmp/test.phn','r');
phonemes = textscan(fid, '%s', 'Delimiter', '/n');
phonemes = phonemes{1,1}';
fclose(fid);

fid = fopen('/tmp/test.durations','r');
phonemeDurations = textscan(fid, '%f');
phonemeDurations = phonemeDurations{1,1}';
fclose(fid);

pathToModels = '/Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/model/hmmdefs9gmm9iter'


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

addpath('visualize');
% visualizePath(totalDistMatrix, URI_testFile_noExt, listPhonemesWithStates, pathXs, pathYs)



 %%%%%%%%%%%%%%%%%%%%% prepare for EVALUATION.
% prepare for output
addpath('eval');
wordsSequence = [];
 [startTimeStamps, listTokens ]  = parseMinPath_words(minimalPath, listPhonemesWithStates, wordsSequence, withDurations  )

 
 

% eval in python 
detected = [URI_testFile_noExt DETECTED_EXT];

writeDetectedToFile ( startTimeStamps, listTokens,  detected, 1 );

anno = [URI_testFile_noExt ANNOTATION_EXT];


% end
%% 1-words Level,
evalLevel = 1; 

command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentStep/evaluation/WordLevelEvaluator.py ' anno ' ' detected ' ' int2str(evalLevel)]
system( command); 
