% DEPRECATED!!! % 

%%%%%%%%%%%%% params

numFramesPerSec = 100;

URI_scorePath = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' ;

SECTION_NUM = 2;

URI_targetFile_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma';

% URI_targetFile_noExt =  '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma_2_zemin_from_24_931985_to_33_767787'

URI_recordingQueryToGetTempoFrom = URI_targetFile_noExt;




%%%%%%%%%%%%%%%%%%%%
command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/ScoreParserDTW.py ' URI_scorePath ' ' num2str(SECTION_NUM) ' ' URI_recordingQueryToGetTempoFrom ]
[status, commandOut] = system( command); 
commandOut

URI_phonemes = [URI_scorePath '/' num2str(SECTION_NUM) '.phn']
URI_durations = [URI_scorePath '/' num2str(SECTION_NUM)  '.dur']


% URI_target_file_fullName_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma_2_zemin_from_24_931985_to_33_767787';


% without the sim matrix part
% listPhonemesWithStates = phonemes2listPhonemesWithStates(URI_phonemes, URI_durations);

[similarityMatrix, listPhonemesWithStates] = calcSimMatrix(URI_targetFile_noExt, URI_phonemes, URI_durations );


%% construct accumulated cost matrix
close all;
	
	penaltyNextState = 85;
	disp(fprintf('penalty...%d', penaltyNextState));


	costMatrix  = -log(similarityMatrix);
	[totalDistMatrix, backPtrMatrix] = subSequence_dtw(costMatrix, penaltyNextState);

LengthQuery = size(similarityMatrix, 1);




%% back-track N paths



%%%%%%%%%%%%%% blacklist silent sections: TODO: optimize: instead of
%%%%%%%%%%%%%% blakclisting, run dtw only on vocal sections 



% TODO: read from somewhere?
listStartNonVocalSections = [0, 61,  121, 216];
listEndNonVocalSections = [23.6, 84, 188, size(similarityMatrix, 2) / numFramesPerSec ];

totalDistMatrix = blackListNonVocal(listStartNonVocalSections, listEndNonVocalSections, LengthQuery, totalDistMatrix, numFramesPerSec);


% fromFrame = 23.6 * 100;
% toFrame = 61 * 100;


allCosts = {};
bagOfAllCosts = [];
for i=1:30
	
	disp(fprintf('iteration...%d',i));
	
	
	% find optimal path (with min dist)
	[currMinimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath_subSequence (totalDistMatrix, backPtrMatrix);
	
	%%%%%%%%%%%%%%% check if start index is in non-vocal section 
	isIndex = isIndexInNonVocal(firstTargetFrameIndex, listStartNonVocalSections, listEndNonVocalSections, numFramesPerSec);
	if isIndex
		totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;
		disp(fprintf('%d in non-vocal', firstTargetFrameIndex));
		continue;
	end
	
	hold on; plot(pathXs, pathYs, '*', 'Color', 'k' );
	disp(fprintf('last target index: %d, distance is : %f', lastTargetFrameIndex , dist));
	
	
% 	totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;
	
	%blacklist region around found path 10%
	halfLengthBlackList = round(0.025 * size(listPhonemesWithStates,2)); 
	rightBlackListVal = min(lastTargetFrameIndex + halfLengthBlackList, size(totalDistMatrix,2) );
	totalDistMatrix(LengthQuery , lastTargetFrameIndex - halfLengthBlackList : rightBlackListVal  ) = inf;
	
		
[bagOfAllCosts, allCosts] = calcCostForPaths(costMatrix, currMinimalPath, bagOfAllCosts, allCosts );

end



%% visualize
addpath('../visualize');

% ground gruth
whichSection = 2;
visLAST(totalDistMatrix, URI_targetFile_noExt, whichSection, listPhonemesWithStates, [], [], []);


%% WEIGHTING


indexesTop = calcWeights(bagOfAllCosts, allCosts);
% seleect weighted paths. dirty implementation : calc. again paths

%%%%%%%%%%%%%% blacklist silent sections: TODO: optimize: instead of
%%%%%%%%%%%%%% blakclisting, run dtw only on vocal sections 



% TODO: read from somewhere?
listStartNonVocalSections = [0, 61,  121, 216];
listEndNonVocalSections = [23.6, 84, 188, size(similarityMatrix, 2) / numFramesPerSec ];

totalDistMatrix = blackListNonVocal(listStartNonVocalSections, listEndNonVocalSections, LengthQuery, totalDistMatrix, numFramesPerSec);


for i=1:30
	
	disp(fprintf('iteration...%d',i));
	
	
	% find optimal path (with min dist)
	[minimalPath, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath_subSequence (totalDistMatrix, backPtrMatrix);
	
	%%%%%%%%%%%%%%% check if start index is in non-vocal section 
	isIndex = isIndexInNonVocal(firstTargetFrameIndex, listStartNonVocalSections, listEndNonVocalSections, numFramesPerSec);
	if isIndex
		totalDistMatrix(LengthQuery , lastTargetFrameIndex )  = inf;
		disp(fprintf('%d in non-vocal', firstTargetFrameIndex));
		continue;
	end
	
	%%%%%%%%%%%% get only top paths based on weights
% 	if ~ismember(i, indexesTop)
% 				disp(fprintf('path %d is not top 10 ', i));
% 		continue;
% 	end
	
	hold on; plot(pathXs, pathYs, '*', 'Color', 'k' );
	disp(fprintf('last target index: %d, distance is : %f', lastTargetFrameIndex , dist));
end


 