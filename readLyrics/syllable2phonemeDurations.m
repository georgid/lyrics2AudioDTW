
% how to divide duration of a syllable, given in score into the phonemes, constituting the syllable 
% important design choice. 

function [phonemes, phonemesDurations] = syllable2phonemeDurations(phonemesSequence, syllableDurations, graphemesAndPhonemes)

phonemes = {};
phonemesDurations = [];


% make sure same length

if size(phonemesSequence,1) ~= size(syllableDurations,1)
	disp('not same duration');
end


% loop in syllables
for i = 1:size(phonemesSequence,2) 
	numPhonemesInSyllable = size(phonemesSequence{i},2);
	
	positionVowels = [];
	
	currSyllDur = syllableDurations(i);

	% loop in phonemes in each syllable
	for h = 1: numPhonemesInSyllable
		currPhoneme = phonemesSequence{i}{h};
		
		
		% check if vowel
		vowels = graphemesAndPhonemes{1,2};
		
		if ismember(currPhoneme, {vowels{1:10}})
			positionVowels = [positionVowels  h];
		end
		
		% expand phonemes into syllables
		phonemes{end + 1} = currPhoneme;

	end
	
	if length(positionVowels) > 1
		disp('more than one vowel in syllable! Not implemented yet');
		break;
	end
	
	% again loop assigning durations
	vowelDur = currSyllDur - numPhonemesInSyllable + 1;
	
	for h = 1: numPhonemesInSyllable
	
		if h == positionVowels(1)
			phonemesDurations = [phonemesDurations vowelDur];
		else
			phonemesDurations = [phonemesDurations 1];
		end
	
		
	end
	
end





end