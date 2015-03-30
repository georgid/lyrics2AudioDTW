function visLAST(costMatrix, URI_testFile_noExt, listPhonemesWithStates, pathXs, pathYs)

% visualize

% visFromFrameTs = 30;
% visToFrameTs = 128;

visFromFrameTs = 1;
visToFrameTs = size(costMatrix,2) / 100;

addpath('visualize');

% pathXs = []
% pathYs = []


% values bigger than 250 are set to 250
threshold = 150
IndexGrThan = costMatrix > threshold;
costMatrix = costMatrix - IndexGrThan.*(costMatrix - threshold);

visualizePath(costMatrix,  visFromFrameTs , visToFrameTs, URI_testFile_noExt, listPhonemesWithStates, pathXs, pathYs);

end