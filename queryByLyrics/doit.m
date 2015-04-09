URI_targetFile_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma'



% URI_targetFile_noExt =  '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma_2_zemin_from_24_931985_to_33_767787'

numFramesPerSec = 100;

URI_scorePath = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' 

SECTION_NUM = 2

URI_recordingQueryToGetTempoFrom = URI_targetFile_noExt;

command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/ScoreParserDTW.py ' URI_scorePath ' ' num2str(SECTION_NUM) ' ' URI_recordingQueryToGetTempoFrom ]
[status, commandOut] = system( command); 
commandOut

URI_phonemes = [URI_scorePath '/' num2str(SECTION_NUM) '.phn']
URI_durations = [URI_scorePath '/' num2str(SECTION_NUM)  '.dur']


% URI_target_file_fullName_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma_2_zemin_from_24_931985_to_33_767787';


% without the sim matrix part
% listPhonemesWithStates = phonemes2listPhonemesWithStates(URI_phonemes, URI_durations);

[simMatrix, listPhonemesWithStates] = calcSimMatrix(URI_targetFile_noExt, URI_phonemes, URI_durations );



load('similarityMatrix');

[totalDistMatrix, costMatrix, backPtrMatrix] = searchDTW(URI_targetFile_noExt, similarityMatrix, listPhonemesWithStates, fromFrame, toFrame);

LengthQuery = size(simMatrix, 1);


%% visualize
addpath('../visualize')
visualizeDistMatrix(totalDistMatrix, 0, 0);

% ground gruth
whichSection = 2;
visLAST(totalDistMatrix, URI_targetFile_noExt, whichSection, listPhonemesWithStates, [], []);


%%%%%%%%%%%%%% blacklist silent sections: TODO: optimize: instead of
%%%%%%%%%%%%%% blakclisting, run dtw only on vocal sections
%%%%  


% TODO: read from somewhere?
listStartNonVocalSections = [0, 61,  121, 216];
listEndNonVocalSections = [23.6, 84, 188, size(simMatrix, 2) / numFramesPerSec ];

totalDistMatrix = blackListNonVocal(listStartNonVocalSections, listEndNonVocalSections, LengthQuery, totalDistMatrix, numFramesPerSec);


% fromFrame = 23.6 * 100;
% toFrame = 61 * 100;
weightPaths = [];


totalCosts = [];
for i=1:30
	
	disp(fprintf('iteration...%d',i));
	
	
	% find optimal path (with min dist)
	[minimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath_subSequence (totalDistMatrix, backPtrMatrix);
	
	% check if start index is in non-vocal section 
	isIndex = isIndexInNonVocal(firstTargetFrameIndex, listStartNonVocalSections, listEndNonVocalSections, numFramesPerSec);
	if isIndex
		totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;
		disp(fprintf('%d in non-vocal', firstTargetFrameIndex));
		continue;
	end
	
	if ~ismember(i, indexesTop)
				disp(fprintf('path %d is not top 10 ', i));
		continue;
	end
	
	hold on; plot(pathXs, pathYs, '*', 'Color', 'k' );
	disp(fprintf('last target index: %d, distance is : %f', lastTargetFrameIndex , dist));
	
	
% 	totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;
	
	%blacklist region around found path 10%
	halfLengthBlackList = round(0.025 * size(listPhonemesWithStates,2)); 
	rightBlackListVal = min(lastTargetFrameIndex + halfLengthBlackList, size(totalDistMatrix,2) );
	totalDistMatrix(LengthQuery , lastTargetFrameIndex - halfLengthBlackList : rightBlackListVal  ) = inf;
	
		
	a = costMatrix .* minimalPath;
	costs = a(a~=0);
	totalCosts = [totalCosts; costs ]; 
		
	% weight
	weights = costs < cutOffDist;
	weightPaths(i) = sum(weights);

	pressed_key = input('Accept this graph (y/n)? ','s');

	
end

% figure; a = hist(totalCosts, 30);
[n,xout] = hist(totalCosts, 30);
[maxCnt, idxMax] = max(n);
cutOffDist = xout(idxMax);

% TODO: here second loop to get weights

%%%%%%%%%%%%%%%%%%%%%
% Sort by weights
[	weightPathsSorted, indexes] = sort(weightPaths, 'descend');
	
indexesTop = indexes(1:10);

 