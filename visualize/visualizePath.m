
%%%% visualize similarity matrix and transcript

function visualizePath(totalDistMatrix, URI_testFile_noExt, listPhonemesWithStates, pathXs, pathYs)


figure; imagesc(totalDistMatrix);figure(gcf);


%%%% load annotated transcript. TODO: read annotations from TextGrid

URI_anno = [URI_testFile_noExt '.anno'];
if exist(URI_anno)
	fid = fopen([URI_testFile_noExt '.anno']);
	annotation = textscan(fid, '%f %f %s');
	fclose(fid);

	% draw vertical annotation lines
	drawAnnotations(annotation);
else
	disp(['no file .anno found for' URI_testFile_noExt ]);
end
	
% name models on left vertical side
set(gca, 'YTick',1:size(listPhonemesWithStates,2), 'YTickLabel', listPhonemesWithStates');
figure(gcf);

hold on; plot(pathXs, pathYs, '*', 'Color', 'k' );
