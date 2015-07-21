
% full-fledged doit. just misses weighting of resutls

URI_targetFile_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma';
URI_toTakeTempoFrom = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma_2AndSil';
URI_scorePath = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' ;
SECTION_NUM = 2;

% URI_toTakeTempoFrom = '/Users/joro/Documents/Phd/UPF/ISTANBUL/goekhan/02_Kimseye_2_zemin';
% URI_targetFile_noExt  = '/Users/joro/Documents/Phd/UPF/ISTANBUL/goekhan/02_Kimseye';
% URI_scorePath = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/nihavent--sarki--curcuna--kimseye_etmem--kemani_sarkis_efendi/' ;
% SECTION_NUM = 2;

addpath('../queryByLyrics');

% construct 
tempoCoeff1 = 1;
tempoCoeff2 = 0.1;
addpath('../queryByLyricsVsLyrics')

pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';

hasDeltas = 1;



[queryPhonemesWithStates, targetPhonemes ] = doitLyricsVsLyrics(URI_toTakeTempoFrom, URI_scorePath,  SECTION_NUM, tempoCoeff1, tempoCoeff2);

% for i=1:100
% 	lastIndex = size(targetPhonemes, 2);
% 	targetPhonemes{lastIndex + 1} = 'sp_0';
% end

% parse states

MFCCs = readMFCC_extractedWithHTK(URI_toTakeTempoFrom, hasDeltas);
withRealFeatures = 1;
simMatrixOneSection = calcSimMatrixLyrics(pathToModels,  queryPhonemesWithStates, MFCCs, hasDeltas, withRealFeatures);

costMatrixSanity  = -log(simMatrixSanity);

costMatrixSanity = cutOffDists( costMatrixSanity );

%% construct accumulated cost matrix

	disp(fprintf('penalty...%d', penaltyNextState));


	[totalDistMatrix, backPtrMatrix] = subSequence_dtw(costMatrix, penaltyNextState);

LengthQuery = size(simMatrixOneSection, 1);



%% visualize
addpath('../visualize');

% 1 - words, 0- phonemes
whichLevel = 1;

% ground gruth
visLAST(costMatrix, URI_targetFile_noExt, SECTION_NUM, queryPhonemesWithStates, [], whichLevel);
% visLAST(totalDistMatrix, URI_targetFile_noExt, SECTION_NUM, queryPhonemesWithStates, [], whichLevel);

%% back-track N paths



%%%%%%%%%%%%%% blacklist silent sections: TODO: optimize: instead of
%%%%%%%%%%%%%% blakclisting, run dtw only on vocal sections 

allCosts = {};
bagOfAllCosts = [];
for i=1:10
	
	disp(fprintf('iteration...%d',i));
	
	
	% find optimal path (with min dist)
	[currMinimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath_subSequence (totalDistMatrix, backPtrMatrix);
	
% 	%%%%%%%%%%%%%%% check if start index is in non-vocal section 
% 	isIndex = isIndexInNonVocal(firstTargetFrameIndex, listStartNonVocalSections, listEndNonVocalSections, numFramesPerSec);
% 	if isIndex
% 		totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;
% 		disp(fprintf('%d in non-vocal', firstTargetFrameIndex));
% 		continue;
% 	end
	
	hold on; plot(pathXs, pathYs, '*', 'Color', 'k' );
	disp(fprintf('last target index: %d, distance is : %f', lastTargetFrameIndex , dist));
	
	
% 	totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;
	
	%blacklist region around found path 10%
	halfLengthBlackList = round(0.025 * size(queryPhonemesWithStates,2)); 
	rightBlackListVal = min(lastTargetFrameIndex + halfLengthBlackList, size(totalDistMatrix,2) );
	totalDistMatrix(LengthQuery , lastTargetFrameIndex - halfLengthBlackList : rightBlackListVal  ) = inf;
	
		
[bagOfAllCosts, allCosts] = calcCostForPaths(costMatrix, currMinimalPath, bagOfAllCosts, allCosts );

end

