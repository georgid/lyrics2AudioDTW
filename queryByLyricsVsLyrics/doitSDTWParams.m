function doitSDTWParams(URI_score, URI_wholeAudio_noExt, SECTION_NUM)
% 
% URI_wholeAudio_noExt = '/Users/joro/Documents/Phd/UPF//ISTANBUL//goekhan/02_Kimseye'
% URI_score = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/nihavent--sarki--curcuna--kimseye_etmem--kemani_sarkis_efendi'
% SECTION_NUM = 4
% 
% 
% URI_score = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' ;
% URI_wholeAudio_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma';
% SECTION_NUM = 2


% LIST of data in file: 
% ~/Documents/Phd/UPF/papers/DurationHSMM_polyphonic_EUSIPCO/TableResultsPhraseLevel.lyx



hasDeltas = 1;
% firts call data.m

%% phoneme query
addpath('../queryByLyrics');
% construct 
tempoCoeff1 = 1;
tempoCoeff2 = 0.1;
addpath('../queryByLyricsVsLyrics')

pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';



[queryPhonemesWithStates, targetPhonemes ] = lyrics2StatesNetwork(URI_wholeAudio_noExt, URI_score,  SECTION_NUM, tempoCoeff1, tempoCoeff2);
% for i=1:100
% 	lastIndex = size(targetPhonemes, 2);
% 	targetPhonemes{lastIndex + 1} = 'sp_0';
% end


%% calc distanceMatrix
withSilenceCutOff = 0;

withRealFeatures = 0;
withRealFeatures = 1;

startFrame = 0;
endFrame = 0;

if withRealFeatures
	featureVectors = readMFCC_extractedWithHTK(URI_wholeAudio_noExt, hasDeltas, startFrame, endFrame);
% 	featureVectors = readMFCC_extractedWithHTK(URI_targetNoExt, hasDeltas, startFrame, endFrame);
else
	featureVectors = targetPhonemes;
end


% get non-vocal vocal sections
numFramesPerSec = 100;
[ listStartNonVocalSections listEndNonVocalSections] = getVocalNonVocalSections(URI_wholeAudio_noExt, featureVectors, numFramesPerSec);
listStartNonVocalSections = 0;
listEndNonVocalSections = 10.8;

% cuts off silence as well
simMatrix = calcSimMatrixLyrics(pathToModels,  queryPhonemesWithStates, featureVectors, hasDeltas, withRealFeatures, listStartNonVocalSections, listEndNonVocalSections, withSilenceCutOff);


costMatrix  = -log(simMatrix);


%% ground gruth
	whichLevel = 4; % sections
	onlyBoundaires = 0;
	weightDiag = 15.3;
	cuttOffIndex = 3;

	addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/visualize')
	visLAST(costMatrix, URI_wholeAudio_noExt, SECTION_NUM, queryPhonemesWithStates, targetPhonemes, whichLevel, onlyBoundaires, weightDiag, cuttOffIndex );


%% construct accumulated dist matrix

% start and end indices
pathsXBegins = [];
pathsXEnds = [];


for weightDiag = 15.3:0.3:15.3
	for cuttOffIndex =  3:3
	addpath('../queryByLyrics');
	disp(fprintf('weight diag...%d', weightDiag));
	
	% prepare : cut-off big distances 
	costMatrixSanity = cutOffDists( costMatrix, cuttOffIndex );
		
	
	[totalDistMatrixSanity, backPtrMatrix] = subSequence_dtw(costMatrixSanity, weightDiag);
	% 	totalDistMatrix = blackListNonVocal(listStartNonVocalSections, listEndNonVocalSections, LengthQuery, totalDistMatrix, numFramesPerSec);

	
	
	LengthQuery = size(simMatrix, 1);

	%%%%%%%%%%% visualize
	addpath('../visualize');

	
		for i=1:15

			disp(fprintf('iteration...%d',i));


			% find optimal path (with min dist)
			[minimalPath, currPathXs, currPathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrixSanity ] = traceBackMinimalPath_subSequence (totalDistMatrixSanity, backPtrMatrix);
			
			% flag meaning that we do not have any paths more

			if firstTargetFrameIndex == -1
								disp('no path matches found anymore . Stopping! ');
				break;
			end
			
			pathsXBegins = [pathsXBegins currPathXs(1)]; 
			pathsXEnds = [pathsXEnds currPathXs(end)];
			
			% plot path
			hold on; plot(currPathXs, currPathYs, '*', 'Color', 'k' );

			disp(fprintf('last target index: %d, distance is : %f', lastTargetFrameIndex , dist));



	% 		blacklist region around found path 5%
			regionPercent = 0.9
			halfLengthBlackList = round(regionPercent/2.0 * size(queryPhonemesWithStates,2)); 
			rightBlackListIdx = min(lastTargetFrameIndex + halfLengthBlackList, size(totalDistMatrixSanity,2) );
			leftBlackListIdx = lastTargetFrameIndex - halfLengthBlackList;

			totalDistMatrixSanity(LengthQuery , leftBlackListIdx : rightBlackListIdx  ) = inf;

		end
% 				pressed_key = input('Accept this graph (y/n)? ','s');
	end

end % weight

pathsXBegins_URI = [URI_wholeAudio_noExt  '_' num2str(SECTION_NUM) '.tsv'];
pathsXEnds_URI = [URI_scorePath '_'  num2str(SECTION_NUM) '.tsv'];

dlmwrite(pathsXBegins_URI, pathsXBegins);
dlmwrite(pathsXEnds_URI,pathsXEnds);

