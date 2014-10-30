
%%%%%%
%	turn beginIndicesPhonemes to begin indices of words. use wordSequence
%	to count phonemes in a word 
%
%%%%%%
function beginIndicesWords = beginIndicesPhonemes2BeginIndicesWords(beginIndicesPhonemes, wordsSequence, hasDurations)

%%%% HERE TAKE ONLY start times of words
beginIndicesWords = zeros(size(beginIndicesPhonemes)); 

indicesOnes = find(beginIndicesPhonemes);


% first 3 are sil

	lengthSilence = 3;

currWordStartIndex = 1;
for wrdIndex = 1:length(wordsSequence)
	
	
	% put one at begin of word
	ind = indicesOnes(currWordStartIndex) + lengthSilence;
	beginIndicesWords(ind,1) = 1;

	
	% increment
	% 	add +1 for sp 
	wordLength = length(wordsSequence{wrdIndex}) + 1;
	currWordStartIndex = currWordStartIndex + wordLength;
	
end

%  last sil. 
	if (hasDurations)
		ind = indicesOnes(currWordStartIndex) + lengthSilence;
	else
% 		FIXME. This does not fit. 
		ind = indicesOnes(currWordStartIndex) + 1;
	end	

beginIndicesWords(ind,1) = 1;


beginIndicesWords = logical(beginIndicesWords);

%%%% END of code for start times of words