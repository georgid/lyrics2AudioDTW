%###### Evaluation of lyrics-to-audio alignemnt done with DTW

% TODO: load needed arguments

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
