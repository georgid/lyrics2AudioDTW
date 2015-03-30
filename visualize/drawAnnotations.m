%  
% load annotation. from. use furst TextGrid_[arsing to convert praat to  form. 
% draw them as vert lines in cost matrix
% 
function drawAnnotations(phonemes, fromTs, toTs)

addpath('/Users/joro/Downloads/hline_vline/')

numFramesPerSec = 100

% hold handleFigure;
hold;

for i=1:size(phonemes{1},1) 
	startTs = phonemes{1}(i,1);
	if (startTs < fromTs) || (startTs > toTs)
		continue
	end
	startTs = startTs - fromTs;
	letter = phonemes{3}{i};
	vline(startTs*numFramesPerSec, 'r', letter);
end


end