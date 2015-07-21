function 	obsProbsRow = cutOffSilentRegions( isModelSilence, obsProbsRow,  listStartNonVocalSections, listEndNonVocalSections, numFramesPerSec )

% if isModelSilence
% 	obsProbsRow(1:end) = realmin;
% end

	for s=1:size(listStartNonVocalSections,2)
	startFr = listStartNonVocalSections(s) * numFramesPerSec;
		if startFr == 0
			startFr  = 1;
		end

% add queryLength to exclude these regions
% 		endFr = listEndNonVocalSections(s) * numFramesPerSec + LengthQuery;

		
		endFr = listEndNonVocalSections(s) * numFramesPerSec;

		endFr = min (endFr, size(obsProbsRow,1));
		
		if isModelSilence % silent regions with prob. = 1
			
			obsProbsRow( startFr:endFr) = 0.999999;
		else	% vocal: silent regions with prob = 0, rest remains as it is according to pdf
			obsProbsRow( startFr:endFr) = realmin;

		end

	end
	

end

