function totalDistMatrix = blackListNonVocal(listStartNonVocalSections, listEndNonVocalSections, LengthQuery, totalDistMatrix, numFramesPerSec)
	



	for s=1:size(listStartNonVocalSections,2)
	startFr = listStartNonVocalSections(s) * numFramesPerSec;
		if startFr == 0
			startFr  = 1;
		end
		endFr = listEndNonVocalSections(s) * numFramesPerSec + LengthQuery;
		endFr = min (endFr, size(totalDistMatrix,2));
		totalDistMatrix(LengthQuery, startFr:endFr) = inf;

	end


end