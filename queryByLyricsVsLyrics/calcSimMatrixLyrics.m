%%%%
% @param queryPhonemeStates on the vert. axis
% @partm targetPhonemeStates on the horizontal (instead of audio query) : takes
% mean of component with biggest weight as if it were a feature vector
% 


function similarityMatrix = calcSimMatrixLyrics(pathToModels,  queryPhonemeStates, targetPhonemeStates, hasDeltas, withRealFeatures, listStartNonVocalSections, listEndNonVocalSections, withSilenceCutOff)

addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/');
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyrics');

numFramesPerSec = 100;

numStates1 = size(queryPhonemeStates,2);

if withRealFeatures
	numStates2 = size(targetPhonemeStates,1);
else
	numStates2 = size(targetPhonemeStates,2);
end

similarityMatrix = zeros(numStates1, numStates2);

whichRowInMatrix = 1;
samplePoints = [];

modelNames = {};
gmms = {};

		

for rowIdx = 1:numStates1
		% used obs. posterior prob form trained model 
% 		similarityMatrix(d,f) = getObsProb(aggregFeatureVectors, gmm, d);
		
		fullModelName = queryPhonemeStates{rowIdx};		
		
		[isModelSilence, loadedGmm1, modelNames, gmms] = checkModelAndLoadGmm(fullModelName, modelNames, gmms, pathToModels, hasDeltas);
		
		
			
		if ~withRealFeatures
			% reinitialize points from all columns for this row
			samplePoints = getSamplePoints(targetPhonemeStates, modelNames, gmms, pathToModels, hasDeltas);
		else
			samplePoints = targetPhonemeStates;
		end
		
		obsProbsRowT =  pdf(loadedGmm1, samplePoints);
		
		if withSilenceCutOff
			obsProbsRowT = cutOffSilentRegions( isModelSilence, obsProbsRowT,  listStartNonVocalSections, listEndNonVocalSections, numFramesPerSec );
		end 
		
		similarityMatrix(rowIdx,:) = obsProbsRowT'; 
			
		disp(fprintf('at row %d out of %d', rowIdx, numStates1));
		
end	% end of row loop
		
end	





%%%%%%%%%[%
% generate sample fueature vectors from models
function samplePoints = getSamplePoints(targetPhonemeStates, modelNames, gmms, pathToModels, hasDeltas)
		
		numStates2 = size(targetPhonemeStates,2);

		samplePoints = [];
		
		for colIdx = 1:numStates2
			
			fullModelName = targetPhonemeStates{colIdx};
		
			[isSilence, loadedGmm2, modelNames, gmms] = checkModelAndLoadGmm(fullModelName, modelNames, gmms , pathToModels, hasDeltas);

			
			
			
			% get random point form this distrib
% 			samplePoint = random(loadedGmm2);
			
			%get means
	
			weights = loadedGmm2.PComponents;
			means = loadedGmm2.mu;		
			[weight, idx ] = max(weights);
			samplePoint = means(idx, :);
	
			
			samplePoints = [samplePoints; samplePoint];
		end

end