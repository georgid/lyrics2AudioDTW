
addpath('../queryByLyrics');

% SANITY CHECK
tempoCoeff1 = 1.0;
tempoCoeff2 = 1.0;
addpath('../queryByLyricsVsLyrics')
[simMatrix, listPhonemesWithStates ] = doitLyricsVsLyrics(tempoCoeff1, tempoCoeff2);


% END SANITY CHECK




% for penalty=20:5:100
	penalty = 0
	disp(fprintf('penalty = %d',  penalty ));	
	% load('similarityMatrix');
	fromFrame  = 0;
	toFrame = 0;
	[totalDistMatrix, costMatrix, backPtrMatrix] = searchDTW( simMatrix, fromFrame, toFrame, penalty);

	LengthQuery = size(simMatrix, 1);


	%% visualize
	addpath('../visualize')
	visualizeDistMatrix(totalDistMatrix, 0, 0);

	% ground gruth
	whichSection = 2;
	visLAST(totalDistMatrix, URI_targetFile_noExt, whichSection, listPhonemesWithStates, [], []);



	% fromFrame = 23.6 * 100;
	% toFrame = 61 * 100;


	%% no selection of path




	for i=1:5

		disp(fprintf('iteration...%d',i));


		% find optimal path (with min dist)
		[minimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath_subSequence (totalDistMatrix, backPtrMatrix);



		% plot path
		hold on; plot(pathXs, pathYs, '*', 'Color', 'k' );
		disp(fprintf('last target index: %d, distance is : %f', lastTargetFrameIndex , dist));


	% 	totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;

		%blacklist region around found path 10%
		halfLengthBlackList = round(0.025 * size(listPhonemesWithStates,2)); 
		rightBlackListVal = min(lastTargetFrameIndex + halfLengthBlackList, size(totalDistMatrix,2) );
		totalDistMatrix(LengthQuery , lastTargetFrameIndex - halfLengthBlackList : rightBlackListVal  ) = inf;





	end
		pressed_key = input('Accept this graph (y/n)? ','s');


% end % penalty



