function similarityMatrix = calcSimMatrixLyrics(pathToModels,  stateNewtork1, stateNetwork2, hasDeltas)

addpath('..');

numStates1 = size(stateNewtork1,2);

numStates2 = size(stateNetwork2,2);

similarityMatrix = zeros(numStates1, numStates2);

whichRowInMatrix = 1;
samplePoints = [];

modelNames = {};
gmms = {};

		

for rowIdx = 1:numStates1
		% used obs. posterior prob form trained model 
% 		similarityMatrix(d,f) = getObsProb(aggregFeatureVectors, gmm, d);
		
		fullModelName = stateNewtork1{rowIdx};		
		
		[loadedGmm1, modelNames, gmms] = checkModelAndLoadGmm(fullModelName, modelNames, gmms, pathToModels, hasDeltas);

		% reinitialize points from all columns for this row
		samplePoints = [];
		for colIdx = 1:numStates2
			
					fullModelName = stateNetwork2{colIdx};
		
				[loadedGmm2, modelNames, gmms] = checkModelAndLoadGmm(fullModelName, modelNames, gmms , pathToModels, hasDeltas);

			
			
			
			% get random point form this distrib
% 			samplePoint = random(loadedGmm2);
			
			%get means
	
			weights = loadedGmm2.PComponents;
			means = loadedGmm2.mu;		
			[weight, idx ] = max(weights);
			samplePoint = means(idx, :);
	
			
			samplePoints = [samplePoints; samplePoint];
		end
			
		obsProbsT =  pdf(loadedGmm1, samplePoints);

			
		similarityMatrix(rowIdx,:) = obsProbsT'; 
			
		disp(fprintf('at row %d out of %d', rowIdx, numStates1));
		
end	% end of row loop
		
end	

function [loadedGmm, modelNames, gmms, means, weights] = checkModelAndLoadGmm(fullModelName, modelNames, gmms, pathToModels, hasDeltas)

[isMemb, idx] = ismember(fullModelName, modelNames);
		if isMemb
			loadedGmm = gmms{idx};
		
		else % create
			
			[currModelName, whichState] = parseModelName(fullModelName );
			[means, vars2, weights] = loadModels(pathToModels, currModelName, whichState,  hasDeltas );
			loadedGmm = gmdistribution(means,vars2,weights);
			
		% store created gmm and name
			sizeNames = size(modelNames,1);
			modelNames{sizeNames + 1} = fullModelName;
			
			sizeGmm = size(gmms,1);
			gmms{sizeGmm + 1} = loadedGmm;
			
		end
		
end