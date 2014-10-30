function [similarityMatrix, listPhonemesWithStates] = getObsProbGMM_MFCCs(pathToModels, URI_testFile_noExt, phonemes, phonemeDurations, hasDeltas)

MFCCs = readMFCC_extractedWithHTK(URI_testFile_noExt, hasDeltas);

dlmwrite([URI_testFile_noExt  '.mfc_txt'], MFCCs ) ;

listPhonemesWithStates = {};
numPhonemesInTranscript = size(phonemes,2);

%%%%% create sim matrix: 

whichRowInMatrix = 1;

for d=1:numPhonemesInTranscript
		% used obs. posterior prob form trained model 
		
		%%%%%% for each model (each line) compute for all audio the obs probs as cost
		
		currModelName = phonemes{d};
		
		listPhonemesWithStates{whichRowInMatrix} = currModelName ;

		if strcmp(currModelName , 'sp')
			numStates = 1; 
		else 
			numStates = 3;
		end
		
		% iterate through states
		for whichState = 1:numStates
			
			
			[means, vars2, weights] = loadModels(pathToModels, currModelName, whichState,  hasDeltas );
			gmm = gmdistribution(means,vars2,weights);
			obsProbsT =  pdf(gmm, MFCCs);
% TODO: take 2 dim and visualize
% ezsurf(@(x,y)pdf(obj,[x y]),[-100 100],[-100 100])

			similarityMatrix(whichRowInMatrix,:) = obsProbsT'; 
			whichRowInMatrix = whichRowInMatrix + 1;

		
		end
		
end
	
end	