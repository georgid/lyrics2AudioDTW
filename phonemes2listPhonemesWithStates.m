
function listPhonemesWithStates = phonemes2listPhonemesWithStates(phonemes_URI, phonemeDurations_URI)

	addpath('..');
	
	fid = fopen(phonemes_URI,'r');
	phonemes = textscan(fid, '%s', 'Delimiter', '/n');
	phonemes = phonemes{1,1}';
	fclose(fid);

	phonemeDurations = [];


		fid = fopen(phonemeDurations_URI,'r');
		phonemeDurations = textscan(fid, '%f');
		phonemeDurations = phonemeDurations{1,1}';
		fclose(fid);


	listPhonemesWithStates = {};
	numPhonemesInTranscript = size(phonemes,2);

	%%%%% create sim matrix: 

	whichRowInMatrix = 1;

	for d=1:numPhonemesInTranscript
			% used obs. posterior prob form trained model 
	% 		similarityMatrix(d,f) = getObsProb(aggregFeatureVectors, gmm, d);

			currModelName = phonemes{d};

	% 		duration =  3* phonemeDurations(d);
			duration =   phonemeDurations(d);


			listPhonemesWithStates{whichRowInMatrix} = currModelName ;

			if strcmp(currModelName , 'sp')
				numStates = 1; 
			else 
				numStates = 3;
			end

			repeatFactor = duration / numStates;

			% all states
			for whichState = 1:numStates

				for  r = 1:repeatFactor

					whichRowInMatrix = whichRowInMatrix + 1;
				end

	% 			listPhonemesWithStates{whichRowInMatrix} = currModelName ;

			end

	end	