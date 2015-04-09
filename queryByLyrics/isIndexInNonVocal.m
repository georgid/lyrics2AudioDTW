function isIndexIn = isIndexInNonVocal(detectedStartIndex, listStartNonVocalSections, listEndNonVocalSections, numFramesPerSec)

isIndexIn = 0;

if size(listStartNonVocalSections, 2) ~= size(listStartNonVocalSections, 2)
	print 'begin and end Ts are not same size';

	
end
	for i = 1:  size(listStartNonVocalSections, 2)
		tmpEnd = listEndNonVocalSections(1, i) * numFramesPerSec;
		tmpStart = listStartNonVocalSections(1,i)* numFramesPerSec;
		if tmpStart < detectedStartIndex &&  detectedStartIndex < tmpEnd
			
			isIndexIn = 1;
			break;
		end
	end
	
end