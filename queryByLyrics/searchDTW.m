function [costMatrix, pathXs, pathYs]  = searchDTW(URI_targetFile_noExt, simMatrix, listPhonemesWithStates, fromFrameTs, toFrameTs)



% take log 
costMatrix  = -log(simMatrix(:,fromFrameTs: toFrameTs));

addpath('visualize');

% subseq dtw, returns -loglikmatrix 
[totalDistMatrix, backPtrMatrix] = subSequence_dtw(costMatrix);

% find optimal path (with min dist)
[minimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath_subSequence (totalDistMatrix, backPtrMatrix);




end