function [similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs_durations_scaled(pathToModels, URI_testFile_noExt, phonemes, phonemeDurations, hasDeltas)

MFCCs = readMFCC_extractedWithHTK(URI_testFile_noExt, hasDeltas);


numFeatVectors = size(MFCCs,1);

numPhonemesInTranscript = size(phonemes,2);
scaleFactor = double( numFeatVectors) / double(sum(phonemeDurations));

%%%%% create sim matrix: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startRow = 1;
for d=1:numPhonemesInTranscript
		% used obs. posterior prob form trained model 
% 		similarityMatrix(d,f) = getObsProb(aggregFeatureVectors, gmm, d);
		
		currModelName = phonemes{d};
		
		duration = 3 * phonemeDurations(d);
		
		listPhonemesWithStates{startRow} = currModelName ;
		
			if strcmp(currModelName , 'sp')
				numStates = 1; 
			else 
				numStates = 3; 
			end
		
		% TODO : round not per state, but for calc for each state/total duration and then round
		numRows = round( double(duration) * scaleFactor / double(numStates));

		for st = 1:numStates

				
				% get prob
				[means, vars2, weights] = loadModels(pathToModels, currModelName, st,  hasDeltas );
				gmm = gmdistribution(means,vars2,weights);
				obsProbsT =  pdf(gmm, MFCCs);

			% stretch vallues in matrix
			for row = startRow:startRow + numRows -1
						similarityMatrix(row,:) = obsProbsT'; 
			end
			startRow = row + 1;

		end	
	
	
end	


end