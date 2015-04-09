function [totalDistMatrix, costMatrix, backPtrMatrix]  = searchDTW(URI_targetFile_noExt, simMatrix, listPhonemesWithStates, fromFrame, toFrame)


if fromFrame==0 && toFrame  == 0
	fromFrame = 1;
	toFrame = size(simMatrix,2);
end


% take log 

costMatrix  = -log(simMatrix(:,fromFrame: toFrame));

% values bigger than 250 are set to 250
% threshold = 150;
% IndexGrThan = costMatrix > threshold;
% costMatrix = costMatrix - IndexGrThan.*(costMatrix - threshold);


addpath('visualize');

% subseq dtw, returns -loglikmatrix 
[totalDistMatrix, backPtrMatrix] = subSequence_dtw(costMatrix);





end