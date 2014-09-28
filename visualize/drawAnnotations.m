%  
% load annotation. from. use furst TextGrid_[arsing to convert praat to  form. 
% draw them as vert lines in sim matrix
% 
function drawAnnotations(phoneme)

addpath('/Users/joro/Downloads/hline_vline/')


% hold handleFigure;
hold 

for i=1:size(phoneme{1},1) 
	startTs = phoneme{1}(i,1)
	letter = phoneme{3}{i}
	vline(startTs*100, 'g', letter)
end


end