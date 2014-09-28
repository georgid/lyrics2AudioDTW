
%%%% syllables2phones : 
% mapping table 
% maps parsed syllables into METU-bet
function phonemesSequence = syllables2phonemes(syllables, graphemesAndPhonemes)

phonemesSequence = {};	


graphemes = graphemesAndPhonemes{1,1};
phonemes = graphemesAndPhonemes{1,2};

numGraphemes = size(graphemes, 1);
phonemesSequence = {};

for i = 1:size(syllables,2)
	
	phonemesSequence{end + 1} = {};
	
	currSyllable =  lower(syllables{1, i});
	% for each grapheme in syll
	for j = 1:size(currSyllable,2)
		
		% check in lookup table
		for h = 1:numGraphemes
			
			% convert hex unicodes !!not efficient
			if size(graphemes{h},2) == 4
				graphemes{h} = char(hex2dec(graphemes{h}));
			end	
			
			
			if strcmp(currSyllable(1,j) , ' ')
				currPhoneme = 'sp';	
				break;
				
			% get phoneme for grapheme
			elseif strcmp(currSyllable(1,j) , graphemes{h} )
				currPhoneme = phonemes{h};	
				break;
			end	
% 			
			
		end
		% end of check of lookup table 
		
		if ~strcmp(currPhoneme, '')
			phonemesSequence{end}{end + 1} = currPhoneme;
		end
				
	end
	
end



end
