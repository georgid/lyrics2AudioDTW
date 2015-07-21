
%%%% visualize cost matrix and transcript

function visualizePath(matrix, fromTs, toTs, URI_testFile_noExt, listPhonemesWithStates)


%  serialize TextGrid to .anno 

addpath('../queryByLyrics'); 


%  serialize TextGrid to .anno 
command = ['/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/AlignmentDuration/dtw/textGrid2Anno.py '   num2str(SECTION_NUM) ' ' URI_testFile_noExt ];
[status, URI_anno] = system( command); 
URI_anno = strtrim(URI_anno);

%%%% load annotated transcript .anno
% URI_anno = [URI_testFile_noExt '.TextGrid.anno'];
if exist(URI_anno)
	fid = fopen(URI_anno);
	annotation = textscan(fid, '%f %f %s', 'Delimiter','\n');
	fclose(fid);

	
	drawAnnotation(annotation, fromTs, toTs);

else
	disp(['no file .anno found for' URI_testFile_noExt ]);
end
	
% name models on left vertical side
set(gca, 'YTick',1:size(listPhonemesWithStates,2), 'YTickLabel', listPhonemesWithStates');
figure(gcf);

