function [similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs_durations(pathToModels, URI_testFile_noExt, phonemes, phonemeDurations, hasDeltas)

MFCCs = readMFCC_extractedWithHTK(URI_testFile_noExt, hasDeltas);

listPhonemesWithStates = {};
numPhonemesInTranscript = size(phonemes,2);

%%%%% create sim matrix: 

whichRowInMatrix = 1;

for d=1:numPhonemesInTranscript
		% used obs. posterior prob form trained model 
% 		similarityMatrix(d,f) = getObsProb(aggregFeatureVectors, gmm, d);
		
		currModelName = phonemes{d};
		
		duration =  3* phonemeDurations(d);
		
		listPhonemesWithStates{whichRowInMatrix} = currModelName ;
		
		if strcmp(currModelName , 'sp')
			numStates = 1; 
		else 
			numStates = 3;
		end
		
		repeatFactor = duration / numStates;
		
		% all states
		for whichState = 1:numStates
			
			
			[means, vars2, weights] = loadModels(pathToModels, currModelName, whichState,  hasDeltas );


			gmm = gmdistribution(means,vars2,weights);

			obsProbsT =  pdf(gmm, MFCCs);
			
			for  r = 1:repeatFactor
				similarityMatrix(whichRowInMatrix,:) = obsProbsT'; 
			
				whichRowInMatrix = whichRowInMatrix + 1;
			end
			
% 			listPhonemesWithStates{whichRowInMatrix} = currModelName ;
			
		end
		
end	
	
	
end	