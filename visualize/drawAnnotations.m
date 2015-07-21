%  
% load annotation. from. use furst TextGrid_[arsing to convert praat to  form. 
% draw them as vert lines in cost matrix
% 
function drawAnnotations(phonemes, fromTs, toTs, onlyBoundaries)

addpath('../hline_vline/')

numFramesPerSec = 100

% hold handleFigure;
hold;

if ~onlyBoundaries

	for i=1:size(phonemes{1},1) 
		startTs = phonemes{1}(i,1);
		if (startTs < fromTs) || (startTs > toTs)
			continue
		end
		startTs = startTs - fromTs;
		letter = phonemes{3}{i};
		vline(startTs*numFramesPerSec, 'r', letter);
	end
	
else % only first and final boundary

	startTs = phonemes{1}(1,1);
	endTs = phonemes{2}(end,1);	
	lyrics = '';
	for i=1:size(phonemes{3},1) 

		lyrics =  [ lyrics phonemes{3}{i} ' '];
	end

	vline(startTs*numFramesPerSec, 'r', lyrics);
	vline(endTs*numFramesPerSec, 'r', '');
end


end