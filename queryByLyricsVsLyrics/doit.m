%%%%%% 
%%%% sanity check
%%%%%%


URI_targetFile_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma';

addpath('../queryByLyrics');

% construct 
tempoCoeff1 = 1;
tempoCoeff2 = 1;
addpath('../queryByLyricsVsLyrics')

pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';

hasDeltas = 1;
[queryPhonemesWithStates, targetPhonemes ] = doitLyricsVsLyrics(URI_targetFile_noExt, tempoCoeff1, tempoCoeff2);

for i=1:100
	lastIndex = size(targetPhonemes, 2);
	targetPhonemes{lastIndex + 1} = 'sp_0';
end

% parse states
simMatrixSanity = calcSimMatrixLyrics(pathToModels,  queryPhonemesWithStates, targetPhonemes, hasDeltas);


%% construct accumulated cost matrix
close all;
% for penaltyNextState = 80:2:100
	
	penaltyNextState = 0;
	disp(fprintf('penalty...%d',penaltyNextState));

	
	% load('similarityMatrix');
% 	fromFrame  = 0;
% 	toFrame = 0;
% 	[totalDistMatrix, costMatrix, backPtrMatrix] = searchDTW( simMatrix, fromFrame, toFrame, penalty);

	costMatrixSanity  = -log(simMatrixSanity);
	[totalDistMatrixSanity, backPtrMatrix] = subSequence_dtw(costMatrixSanity, penaltyNextState);

	
	LengthQuery = size(simMatrixSanity, 1);

	%%%%%%%%%%% visualize
	addpath('../visualize')

	% ground gruth
	whichSection = 2;
% 	visLAST(totalDistMatrixSanity, URI_targetFile_noExt, whichSection, queryPhonemesWithStates, targetPhonemes, [], []);
	visLAST(costMatrixSanity, URI_targetFile_noExt, whichSection, queryPhonemesWithStates, targetPhonemes, [], []);

	
	for i=1:10

		disp(fprintf('iteration...%d',i));


		% find optimal path (with min dist)
		[minimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrixSanity ] = traceBackMinimalPath_subSequence (totalDistMatrixSanity, backPtrMatrix);
		
		% flag meaning that we do not have any paths more
		
		if firstTargetFrameIndex == -1
			break;
			disp('no path matches found anymore . Stopping! ');
		end

		% plot path
		hold on; plot(pathXs, pathYs, '*', 'Color', 'k' );
		disp(fprintf('last target index: %d, distance is : %f', lastTargetFrameIndex , dist));


% 		totalDistMatrixSanity(LengthQuery , lastTargetFrameIndex )  = inf;

% 		blacklist region around found path 5%
		halfLengthBlackList = round(0.025 * size(queryPhonemesWithStates,2)); 
		rightBlackListVal = min(lastTargetFrameIndex + halfLengthBlackList, size(totalDistMatrixSanity,2) );
		totalDistMatrixSanity(LengthQuery , lastTargetFrameIndex - halfLengthBlackList : rightBlackListVal  ) = inf;

	end
				pressed_key = input('Accept this graph (y/n)? ','s');


% end % penalty

