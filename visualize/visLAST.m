function visLAST(totalDistMatrix, URI_targetFile_noExt, SECTION_NUM, listPhonemesWithStates, targetPhonemes, whichLevel, onlyBoundaries, weightDiag, cuttOffIndex)


%%%%%%%%%%% focus on a part of the result

% visFromFrameTs = 30;
% visToFrameTs = 128;

visFromTs = 0;
visToTs = size(totalDistMatrix,2) / 100;



visualizeDistMatrix(totalDistMatrix, 0, 0, weightDiag, cuttOffIndex);
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/visualize');


%  serialize TextGrid to .anno 
command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/textGrid2AnnoOneSection.py '   num2str(SECTION_NUM) ' ' URI_targetFile_noExt ' ' num2str(whichLevel)];

% command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/textGrid2Anno.py '    URI_targetFile_noExt ' ' num2str(whichLevel)]


[status, URI_anno] = system( command); 
URI_anno = strtrim(URI_anno);

%%%% load annotated transcript .anno
if exist(URI_anno)
	fid = fopen(URI_anno);
	annotation = textscan(fid, '%f %f %s', 'Delimiter','\n');
	fclose(fid);

	% draw vertical annotation lines. this for query-by-lyrics

% 		drawAnnotations(annotation, visFromTs, visToTs, onlyBoundaries);

	
else
	disp(['no file .anno found for' URI_targetFile_noExt ]);
end

listPhonemesWithStates = cleanUplistPhonemesWithStates(listPhonemesWithStates);

% name models on left vertical side
set(gca, 'YTick',1:size(listPhonemesWithStates,2), 'YTickLabel', listPhonemesWithStates');
figure(gcf);

if ~isempty(targetPhonemes)
	targetPhonemes = cleanUplistPhonemesWithStates(targetPhonemes);

	set(gca, 'XTick',1:size(targetPhonemes,2), 'XTickLabel', targetPhonemes, 'XAxisLocation', 'top');
	figure(gcf);
end


end